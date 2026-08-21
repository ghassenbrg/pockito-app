import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/data/repositories/mock_pockito_repository.dart';
import 'package:pockito/domain/models/financial_models.dart';

void main() {
  group('MockPockitoRepository currency and overview invariants', () {
    late MockPockitoRepository repository;

    setUp(() {
      repository = MockPockitoRepository();
    });

    test('converts currencies using each currency minor-unit scale', () {
      expect(repository.convertMinor(17200, 'JPY', 'EUR'), 10148);
      expect(repository.convertMinor(16284, 'EUR', 'JPY'), 27600);
      expect(repository.convertMinor(1234, 'EUR', 'EUR'), 1234);
      expect(repository.convertMinor(1234, 'CHF', 'EUR'), isNull);
    });

    test('seeded home totals stay aligned with the product fixture', () {
      // Every account's opening balance is what was there *before* the six
      // months of history the fixture now carries, so today's balances are
      // the same figures the product was designed around: Revolut €6,142.06,
      // Savings €13,000.00.
      expect(repository.netWorthMinor('EUR'), 2132922);
      expect(
        repository.accountBalance(repository.accountById('a_rev')!),
        614206,
      );
      expect(
        repository.accountBalance(repository.accountById('a_sav')!),
        1300000,
      );

      // The fixture now carries six months of history, so "this month" has
      // to be stated rather than assumed.
      bool thisMonth(DateTime when) =>
          when.year == repository.today.year &&
          when.month == repository.today.month;
      final personalSpending = repository.transactions
          .where(
            (transaction) =>
                transaction.type == MoneyEventType.expense &&
                transaction.splitId == null &&
                thisMonth(transaction.occurredOn),
          )
          .map(
            (transaction) =>
                repository.convertMinor(
                  transaction.amountMinor,
                  transaction.currency,
                  'EUR',
                ) ??
                0,
          )
          .fold(0, (sum, value) => sum + value);
      final sharedSpending = repository.sharedExpenses
          .where(
            (expense) =>
                thisMonth(expense.occurredOn) &&
                expense.status == RecordStatus.confirmed,
          )
          .map(
            (expense) => repository.convertMinor(
              expense.shares
                  .firstWhere(
                    (share) => share.userId == repository.currentUserId,
                  )
                  .amountMinor,
              expense.currency,
              'EUR',
            )!,
          )
          .fold(0, (sum, value) => sum + value);
      expect(personalSpending, 157017);
      expect(sharedSpending, 32956);

      final spending = repository.spendingForMonth(repository.today);
      expect(spending.currency, 'EUR');
      // Personal + your share of every shared expense, and never the whole of
      // a shared expense someone else covered.
      expect(spending.spentMinor, personalSpending + sharedSpending);
      expect(spending.spentMinor, 189973);
      expect(spending.outflowMinor, 197271);
      expect(spending.incomeMinor, 447000);

      final shared = repository.sharedSummary();
      // Flat +€48.20 plus Tokyo +¥4,200 converted at 0.0059.
      expect(shared.owedMinor, 7298);
      expect(shared.owingMinor, 0);
      expect(shared.currency, 'EUR');
    });

    test(
      'editing who paid removes the obsolete linked cash movement',
      () async {
        final original = repository.sharedExpenseById('x_util')!;
        final beforeSpent = repository
            .spendingForMonth(repository.today)
            .spentMinor;
        final beforeNetWorth = repository.netWorthMinor('EUR');

        await repository.saveSharedExpense(
          original.copyWith(
            payers: const [ExpensePayer(userId: 'u_mira', amountMinor: 12400)],
          ),
        );

        expect(repository.transactionById('t_util'), isNull);
        expect(
          repository.spendingForMonth(repository.today).spentMinor,
          beforeSpent,
        );
        expect(repository.netWorthMinor('EUR'), beforeNetWorth + 12400);
      },
    );

    test('settlements move cash without changing spending', () async {
      final beforeSpent = repository
          .spendingForMonth(repository.today)
          .spentMinor;
      final cash = repository.accountById('a_cash')!;
      final beforeCash = repository.accountBalance(cash);
      final proposal = repository.settlements.firstWhere(
        (settlement) => settlement.id == 'st_pend',
      );

      await repository.confirmSettlement(proposal.id, accountId: cash.id);

      expect(
        repository.spendingForMonth(repository.today).spentMinor,
        beforeSpent,
      );
      expect(repository.accountBalance(cash), beforeCash + 5000);
      expect(
        repository.transactions
            .where((transaction) => transaction.settlementId == 'st_pend')
            .single
            .type,
        MoneyEventType.settlement,
      );
    });
  });

  group('Mandatory acceptance accounting oracle', () {
    late MockPockitoRepository repository;
    late Account rakuten;
    late Account cash;
    late Account revolut;
    late SharedSpace household;
    late String kanaId;
    late String franId;

    setUp(() async {
      repository = MockPockitoRepository.empty();
      rakuten = await repository.saveAccount(
        const Account(
          id: '',
          name: 'Rakuten Bank',
          type: AccountType.bank,
          currency: 'JPY',
          openingBalanceMinor: 500000,
          isDefault: true,
        ),
      );
      cash = await repository.saveAccount(
        const Account(
          id: '',
          name: 'Cash',
          type: AccountType.cash,
          currency: 'JPY',
          openingBalanceMinor: 10000,
        ),
      );
      revolut = await repository.saveAccount(
        const Account(
          id: '',
          name: 'Revolut Savings',
          type: AccountType.savings,
          currency: 'EUR',
          openingBalanceMinor: 245000,
        ),
      );
      household = await repository.saveSpace(
        SharedSpace(
          id: '',
          name: 'Household',
          type: SpaceType.household,
          currency: 'JPY',
          members: [SpaceMember(userId: repository.currentUserId)],
          defaultSplitMethod: SplitMethod.percentage,
          defaultPercentages: {repository.currentUserId: 60},
        ),
      );
      for (final name in ['Kana', 'Fran']) {
        final invitation = await repository.inviteMember(
          household.id,
          name: name,
          email: '${name.toLowerCase()}@example.com',
        );
        await repository.respondToInvitation(
          invitation.id,
          InvitationStatus.accepted,
        );
      }
      household = repository.spaceById(household.id)!;
      kanaId = repository.invitations
          .firstWhere((item) => item.name == 'Kana')
          .userId!;
      franId = repository.invitations
          .firstWhere((item) => item.name == 'Fran')
          .userId!;
    });

    test(
      'same and cross-currency transfers conserve their native amounts',
      () async {
        await repository.saveTransaction(
          MoneyTransaction(
            id: '',
            type: MoneyEventType.transfer,
            amountMinor: 20000,
            currency: 'JPY',
            occurredOn: repository.today,
            merchant: 'Transfer to Cash',
            fromAccountId: rakuten.id,
            toAccountId: cash.id,
          ),
        );
        await repository.saveTransaction(
          MoneyTransaction(
            id: '',
            type: MoneyEventType.transfer,
            amountMinor: 100000,
            currency: 'JPY',
            occurredOn: repository.today,
            merchant: 'Transfer to Revolut',
            fromAccountId: rakuten.id,
            toAccountId: revolut.id,
            destinationAmountMinor: 59000,
            destinationCurrency: 'EUR',
            exchangeRate: .0059,
            fxRateMode: FxRateMode.manual,
            rateUpdatedAt: repository.today,
          ),
        );

        expect(repository.accountBalance(rakuten), 380000);
        expect(repository.accountBalance(cash), 30000);
        expect(repository.accountBalance(revolut), 304000);
        expect(repository.spendingForMonth(repository.today).spentMinor, 0);
        expect(repository.spendingForMonth(repository.today).incomeMinor, 0);
      },
    );

    test(
      'shared expenses preserve space amount and only tracked wallets move',
      () async {
        final groceries = await repository.saveSharedExpense(
          SharedExpense(
            id: '',
            spaceId: household.id,
            title: 'Groceries',
            totalMinor: 10000,
            currency: 'JPY',
            occurredOn: repository.today,
            categoryId: 'c_groceries',
            method: SplitMethod.percentage,
            payers: [
              ExpensePayer(
                userId: repository.currentUserId,
                amountMinor: 10000,
              ),
            ],
            shares: [
              SplitShare(userId: repository.currentUserId, amountMinor: 6000),
              SplitShare(userId: kanaId, amountMinor: 4000),
              SplitShare(userId: franId, amountMinor: 0),
            ],
          ),
          accountId: rakuten.id,
        );
        final afterTracked = repository.accountBalance(rakuten);
        final edited = await repository.saveSharedExpense(
          groceries.copyWith(title: 'Groceries corrected', cycleId: 'current'),
          accountId: rakuten.id,
        );
        expect(edited.cycleId, household.currentCycleId);
        final outside = await repository.saveSharedExpense(
          SharedExpense(
            id: '',
            spaceId: household.id,
            title: 'Kana groceries outside Pockito',
            totalMinor: 8000,
            currency: 'JPY',
            occurredOn: repository.today,
            categoryId: 'c_groceries',
            method: SplitMethod.equal,
            payers: [ExpensePayer(userId: kanaId, amountMinor: 8000)],
            shares: [
              SplitShare(userId: repository.currentUserId, amountMinor: 2667),
              SplitShare(userId: kanaId, amountMinor: 2667),
              SplitShare(userId: franId, amountMinor: 2666),
            ],
          ),
        );
        final foreign = await repository.saveSharedExpense(
          SharedExpense(
            id: '',
            spaceId: household.id,
            title: 'Household supplies in EUR',
            totalMinor: 17000,
            currency: 'JPY',
            occurredOn: repository.today,
            categoryId: 'c_household',
            method: SplitMethod.equal,
            payers: [
              ExpensePayer(
                userId: repository.currentUserId,
                amountMinor: 17000,
              ),
            ],
            shares: [
              SplitShare(userId: repository.currentUserId, amountMinor: 5667),
              SplitShare(userId: kanaId, amountMinor: 5667),
              SplitShare(userId: franId, amountMinor: 5666),
            ],
            walletAmountMinor: 10000,
            walletCurrency: 'EUR',
            exchangeRate: .0058823529,
            fxRateMode: FxRateMode.manual,
            rateUpdatedAt: repository.today,
          ),
          accountId: revolut.id,
        );

        expect(
          groceries.shares.fold(0, (sum, item) => sum + item.amountMinor),
          10000,
        );
        expect(outside.paidFromAccountId, isNull);
        expect(repository.accountBalance(rakuten), afterTracked);
        expect(repository.accountBalance(revolut), 235000);
        expect(foreign.totalMinor, 17000);
        expect(foreign.walletAmountMinor, 10000);
        expect(foreign.walletCurrency, 'EUR');
        final memberSum = household.members.fold(
          0,
          (sum, member) =>
              sum + repository.memberBalance(household.id, member.userId),
        );
        expect(memberSum, 0);
      },
    );

    test('foreign-currency subscriptions debit the wallet currency', () async {
      final subscription = await repository.saveSubscription(
        Subscription(
          id: '',
          name: 'Netflix',
          amountMinor: 1490,
          currency: 'JPY',
          accountId: revolut.id,
          categoryId: 'c_ent',
          icon: 'entertainment',
          cadence: const SubscriptionCadence(dayOfMonth: 27),
          startsOn: repository.today,
          nextDueOn: repository.today,
        ),
      );
      final before = repository.accountBalance(revolut);
      final payment = await repository.recordSubscriptionPayment(
        subscription.id,
        accountId: revolut.id,
        date: repository.today,
      );

      expect(payment.currency, 'EUR');
      expect(payment.sourceCurrency, 'JPY');
      expect(payment.sourceAmountMinor, 1490);
      expect(payment.exchangeRate, isNotNull);
      expect(
        repository.accountBalance(revolut),
        before - repository.convertMinor(1490, 'JPY', 'EUR')!,
      );
    });

    test(
      'partial and final settlement retain immutable history across a cycle',
      () async {
        final expense = await repository.saveSharedExpense(
          SharedExpense(
            id: '',
            spaceId: household.id,
            title: 'Utilities',
            totalMinor: 12000,
            currency: 'JPY',
            occurredOn: repository.today,
            categoryId: 'c_utilities',
            method: SplitMethod.exact,
            payers: [ExpensePayer(userId: kanaId, amountMinor: 12000)],
            shares: [
              SplitShare(userId: repository.currentUserId, amountMinor: 7500),
              SplitShare(userId: kanaId, amountMinor: 4500),
              SplitShare(userId: franId, amountMinor: 0),
            ],
          ),
        );
        expect(
          repository.memberBalance(household.id, repository.currentUserId),
          -7500,
        );
        expect(repository.memberBalance(household.id, kanaId), 7500);

        // A proposal is a claim, not a payment: nothing moves until the
        // person receiving the money agrees it arrived.
        final partial = await repository.proposeSettlement(
          Settlement(
            id: '',
            spaceId: household.id,
            fromUserId: repository.currentUserId,
            toUserId: kanaId,
            amountMinor: 3000,
            currency: 'JPY',
            createdAt: repository.today,
          ),
          accountId: rakuten.id,
        );
        expect(partial.status, SettlementStatus.proposed);
        expect(
          repository.memberBalance(household.id, repository.currentUserId),
          -7500,
          reason: 'a proposed settlement must not move a balance',
        );
        await repository.simulateCounterpartyResponse(
          partial.id,
          confirm: true,
        );
        expect(
          repository.memberBalance(household.id, repository.currentUserId),
          -4500,
        );
        expect(
          repository.settlementRecommendations(household.id).single.amountMinor,
          4500,
        );

        final finalSettlement = await repository.proposeSettlement(
          Settlement(
            id: '',
            spaceId: household.id,
            fromUserId: repository.currentUserId,
            toUserId: kanaId,
            amountMinor: 4500,
            currency: 'JPY',
            createdAt: repository.today,
          ),
          accountId: rakuten.id,
        );
        await repository.simulateCounterpartyResponse(
          finalSettlement.id,
          confirm: true,
        );
        expect(
          household.members.map(
            (m) => repository.memberBalance(household.id, m.userId),
          ),
          everyElement(0),
        );

        final previousCycleId = household.currentCycleId;
        final snapshot = await repository.startNewCycle(household.id);
        household = repository.spaceById(household.id)!;
        expect(snapshot.id, previousCycleId);
        expect(snapshot.expenseIds, contains(expense.id));
        expect(snapshot.spentMinor, 12000);
        expect(
          repository.memberBalance(household.id, repository.currentUserId),
          0,
        );
        expect(repository.sharedExpenseById(expense.id), isNotNull);
        expect(
          () => repository.voidSharedExpense(expense.id),
          throwsA(isA<StateError>()),
        );
      },
    );
  });
}
