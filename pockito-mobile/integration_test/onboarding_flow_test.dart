import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pockito/app/pockito_app_state.dart';
import 'package:pockito/config/pockito_config.dart';
import 'package:pockito/data/auth_service.dart';
import 'package:pockito/data/pockito_api.dart';
import 'package:pockito/main.dart';

/// Drives the real app, on a real device, against the real backend.
///
/// The one thing that is substituted is the hop out to the browser: an access token is
/// obtained beforehand by the same Authorization Code + PKCE flow the app performs, and
/// injected here. Everything after that point is genuine — a real Keycloak-issued token, a
/// real HTTP call to Pockito API, real Core, real PostgreSQL and real object storage.
///
/// Run it with a token from `infra/local/scripts/get-token.sh`:
///
///   flutter test integration_test/onboarding_flow_test.dart \
///     --dart-define=POCKITO_TEST_ACCESS_TOKEN=$TOKEN \
///     --dart-define=POCKITO_API_BASE_URL=http://localhost:8080/api/v1
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const token = String.fromEnvironment('POCKITO_TEST_ACCESS_TOKEN');

  setUpAll(() {
    if (token.isEmpty) {
      fail('POCKITO_TEST_ACCESS_TOKEN is required; obtain one with get-token.sh');
    }
  });

  testWidgets('a new user is taken through onboarding and lands on Home', (tester) async {
    final config = PockitoConfig.fromEnvironment();
    final auth = PreAuthenticatedSession(token);
    final state = PockitoAppState(auth: auth, api: PockitoApi(config: config, auth: auth));

    await tester.pumpWidget(PockitoApp(state: state));

    // Start-up: restore the session, fetch the profile, decide where to go.
    await state.start();
    await tester.pumpAndSettle(const Duration(seconds: 10));

    expect(state.stage, AppStage.onboarding,
        reason: 'a brand-new Keycloak subject has no completed Pockito profile');
    expect(find.text('What should we call you?'), findsOneWidget);

    // 1. Name.
    await tester.enterText(find.byType(TextField), 'Integration Kito');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // 2. Avatar — skipped; the picker is a system sheet, and the upload path is covered
    //    byte-for-byte by the backend suite.
    expect(find.text('Add a photo'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // 3. Language. Choosing Japanese must re-render the flow in Japanese immediately.
    expect(find.text('Choose your language'), findsOneWidget);
    await tester.tap(find.text('日本語'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text('言語を選択'), findsOneWidget,
        reason: 'the language applies live, not only after finishing');

    await tester.tap(find.text('次へ'));
    await tester.pumpAndSettle();

    // 4. Appearance.
    expect(find.text('外観を選択'), findsOneWidget);
    await tester.tap(find.text('ダーク'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(state.preferences.theme.wire, 'DARK');

    await tester.tap(find.text('次へ'));
    await tester.pumpAndSettle();

    // 5. Currency.
    expect(find.text('既定の通貨を設定'), findsOneWidget);
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('JPY').last);
    await tester.pumpAndSettle();

    // Finish.
    await tester.tap(find.text('設定を完了'));
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Home, with everything the user chose actually applied.
    expect(state.stage, AppStage.ready);
    expect(state.profile!.displayName, 'Integration Kito');
    expect(state.profile!.onboardingCompleted, isTrue);
    expect(state.preferences.defaultCurrency, 'JPY');
    expect(find.textContaining('Integration Kito'), findsWidgets,
        reason: 'Home greets the real user by name');
    expect(find.text('まだ記録はありません'), findsOneWidget,
        reason: 'Home renders in the language chosen during onboarding');

    // Onboarding must not reappear on the next start.
    await state.retry();
    await tester.pumpAndSettle(const Duration(seconds: 10));
    expect(state.stage, AppStage.ready);
  });

  testWidgets('settings shows the saved profile and can change a preference', (tester) async {
    final config = PockitoConfig.fromEnvironment();
    final auth = PreAuthenticatedSession(token);
    final state = PockitoAppState(auth: auth, api: PockitoApi(config: config, auth: auth));

    await tester.pumpWidget(PockitoApp(state: state));
    await state.start();
    await tester.pumpAndSettle(const Duration(seconds: 10));
    expect(state.stage, AppStage.ready, reason: 'this subject onboarded in the test above');

    await tester.tap(find.text('設定'));
    await tester.pumpAndSettle();

    expect(find.text('プロフィール'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle(const Duration(seconds: 8));
    expect(state.preferences.language.wire, 'EN');
    // "Settings" appears twice once the language changes — the navigation label and the
    // page heading — which is itself the point: the whole shell re-renders, not just the
    // page body.
    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('設定'), findsNothing, reason: 'no Japanese text should survive');
  });
}

/// An [AuthService] that already holds a token.
///
/// Stands in only for the browser round-trip; the token it returns is genuine, so every
/// request the app makes is authenticated exactly as it would be in production.
class PreAuthenticatedSession implements AuthService {
  PreAuthenticatedSession(this._token);

  final String _token;
  bool _signedIn = true;

  @override
  bool get hasSession => _signedIn;

  @override
  Future<bool> restore() async => _signedIn;

  @override
  Future<bool> signIn({bool register = false}) async {
    _signedIn = true;
    return true;
  }

  @override
  Future<String?> accessToken() async => _signedIn ? _token : null;

  @override
  Future<void> signOut() async => signOutLocally();

  @override
  Future<void> signOutLocally() async => _signedIn = false;

  @override
  String? get subject => null;
}
