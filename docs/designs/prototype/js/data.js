/* ============================================================
   Pockito prototype — centralised mock data
   One dataset. Every screen derives from it; nothing is
   hardcoded per-screen, so totals always reconcile.
   ============================================================ */
window.DB = (function () {

  const TODAY = '2026-08-15';
  const ME = 'u_me';

  /* ── currencies ───────────────────────────────────────── */
  const CURRENCIES = {
    EUR: { code: 'EUR', symbol: '€', decimals: 2, name: 'Euro' },
    USD: { code: 'USD', symbol: '$', decimals: 2, name: 'US Dollar' },
    JPY: { code: 'JPY', symbol: '¥', decimals: 0, name: 'Japanese Yen' },
    GBP: { code: 'GBP', symbol: '£', decimals: 2, name: 'British Pound' },
    CHF: { code: 'CHF', symbol: 'Fr', decimals: 2, name: 'Swiss Franc' }
  };

  /* Rates → EUR (the reporting currency). CHF is deliberately absent
     so the "can't combine — no rate" state is reachable. */
  const RATES = {
    base: 'EUR',
    capturedAt: '2026-08-15',
    source: 'European Central Bank',
    to: { EUR: 1, USD: 0.92, JPY: 0.0059, GBP: 1.17 }
  };

  /* ── people ───────────────────────────────────────────── */
  const USERS = {
    u_me:   { id: 'u_me',   name: 'Ghassen', initials: 'G', isYou: true },
    u_mira: { id: 'u_mira', name: 'Mira',    initials: 'M' },
    u_sam:  { id: 'u_sam',  name: 'Sam',     initials: 'S' }
  };

  const PROFILE = {
    userId: ME,
    displayName: 'Ghassen',
    email: 'ghassen@example.com',
    country: 'DE',
    countryName: 'Germany',
    reportingCurrency: 'EUR',
    locale: 'en-DE',
    timezone: 'Europe/Berlin',
    weekStartsOn: 'monday',
    theme: 'system',
    language: 'English'
  };

  /* ── accounts (unit of payment) ───────────────────────── */
  const ACCOUNTS = [
    { id: 'a_rev',   name: 'Revolut',    type: 'BANK',    currency: 'EUR', opening: 320000,  isDefault: true,  archived: false, colorIdx: 2,  icon: 'card',    sortOrder: 0 },
    { id: 'a_n26',   name: 'N26',        type: 'BANK',    currency: 'EUR', opening: 148050,  isDefault: false, archived: false, colorIdx: 3,  icon: 'bank',    sortOrder: 1 },
    { id: 'a_visa',  name: 'Visa',       type: 'CARD',    currency: 'EUR', opening: -42800,  isDefault: false, archived: false, colorIdx: 5,  icon: 'card',    sortOrder: 2 },
    { id: 'a_sav',   name: 'Savings',    type: 'SAVINGS', currency: 'EUR', opening: 1250000, isDefault: false, archived: false, colorIdx: 1,  icon: 'savings', sortOrder: 3 },
    { id: 'a_chase', name: 'Chase',      type: 'BANK',    currency: 'USD', opening: 214000,  isDefault: false, archived: false, colorIdx: 8,  icon: 'bank',    sortOrder: 4 },
    { id: 'a_cash',  name: 'Cash',       type: 'CASH',    currency: 'JPY', opening: 18400,   isDefault: false, archived: false, colorIdx: 4,  icon: 'cash',    sortOrder: 5 },
    { id: 'a_old',   name: 'Old PayPal', type: 'DIGITAL', currency: 'EUR', opening: 0,       isDefault: false, archived: true,  colorIdx: 10, icon: 'wallet',  sortOrder: 6 }
  ];

  /* ── categories ───────────────────────────────────────── */
  const CATEGORIES = [
    { id: 'c_gro',  name: 'Groceries',     type: 'EXPENSE', icon: 'cart',          colorIdx: 1,  system: true },
    { id: 'c_din',  name: 'Restaurants',   type: 'EXPENSE', icon: 'restaurant',    colorIdx: 5,  system: true },
    { id: 'c_tra',  name: 'Transport',     type: 'EXPENSE', icon: 'transit',       colorIdx: 3,  system: true },
    { id: 'c_hou',  name: 'Housing',       type: 'EXPENSE', icon: 'housing',       colorIdx: 4,  system: true },
    { id: 'c_uti',  name: 'Utilities',     type: 'EXPENSE', icon: 'utilities',     colorIdx: 7,  system: true },
    { id: 'c_hea',  name: 'Health',        type: 'EXPENSE', icon: 'health',        colorIdx: 9,  system: true },
    { id: 'c_sho',  name: 'Shopping',      type: 'EXPENSE', icon: 'shopping',      colorIdx: 6,  system: true },
    { id: 'c_ent',  name: 'Entertainment', type: 'EXPENSE', icon: 'entertainment', colorIdx: 12, system: true },
    { id: 'c_trv',  name: 'Travel',        type: 'EXPENSE', icon: 'travel',        colorIdx: 8,  system: true },
    { id: 'c_edu',  name: 'Education',     type: 'EXPENSE', icon: 'education',     colorIdx: 11, system: true },
    { id: 'c_gif',  name: 'Gifts',         type: 'EXPENSE', icon: 'gift',          colorIdx: 9,  system: true },
    { id: 'c_fee',  name: 'Fees',          type: 'EXPENSE', icon: 'receipt',       colorIdx: 10, system: true },
    { id: 'c_cof',  name: 'Coffee',        type: 'EXPENSE', icon: 'restaurant',    colorIdx: 7,  system: false },
    { id: 'c_sal',  name: 'Salary',        type: 'INCOME',  icon: 'income',        colorIdx: 1,  system: true },
    { id: 'c_fre',  name: 'Freelance',     type: 'INCOME',  icon: 'income',        colorIdx: 3,  system: true },
    { id: 'c_ref',  name: 'Refunds',       type: 'INCOME',  icon: 'income',        colorIdx: 11, system: true }
  ];

  /* ── spaces (unit of account) ─────────────────────────── */
  const SPACES = [
    {
      id: 's_flat', name: 'Flat', type: 'HOUSEHOLD', currency: 'EUR',
      colorIdx: 2, icon: 'housing', status: 'ACTIVE', createdAt: '2026-02-12',
      members: [
        { userId: 'u_me',   role: 'OWNER',  status: 'ACTIVE', joinedAt: '2026-02-12' },
        { userId: 'u_mira', role: 'MEMBER', status: 'ACTIVE', joinedAt: '2026-02-14' }
      ],
      defaultSplit: { method: 'PERCENTAGE', shares: { u_me: 60, u_mira: 40 } },
      notifications: { expenses: true, settlements: true, activity: false }
    },
    {
      id: 's_tokyo', name: 'Tokyo Trip', type: 'TRIP', currency: 'JPY',
      colorIdx: 4, icon: 'travel', status: 'ACTIVE', createdAt: '2026-07-28',
      members: [
        { userId: 'u_me',   role: 'OWNER',  status: 'ACTIVE', joinedAt: '2026-07-28' },
        { userId: 'u_mira', role: 'MEMBER', status: 'ACTIVE', joinedAt: '2026-07-28' },
        { userId: 'u_sam',  role: 'MEMBER', status: 'ACTIVE', joinedAt: '2026-07-29' }
      ],
      defaultSplit: { method: 'EQUAL' },
      notifications: { expenses: true, settlements: true, activity: true }
    },
    {
      id: 's_ski', name: 'Ski 2025', type: 'TRIP', currency: 'EUR',
      colorIdx: 10, icon: 'travel', status: 'ARCHIVED', createdAt: '2025-01-04',
      members: [
        { userId: 'u_me',   role: 'OWNER',  status: 'ACTIVE', joinedAt: '2025-01-04' },
        { userId: 'u_sam',  role: 'MEMBER', status: 'ACTIVE', joinedAt: '2025-01-05' }
      ],
      defaultSplit: { method: 'EQUAL' },
      notifications: { expenses: false, settlements: false, activity: false }
    }
  ];

  const INVITES = [
    { id: 'i_1', spaceId: 's_flat', token: '8fK2mQ9Qz', status: 'PENDING',
      invitedBy: 'u_me', sentAt: '2026-08-13', expiresAt: '2026-08-20' }
  ];

  /* Invitation addressed TO the current user, so SPACE-009 is reachable. */
  const INCOMING_INVITE = {
    id: 'i_in', spaceId: 's_book', token: 'inv_bookclub',
    spaceName: 'Book Club', spaceType: 'FRIENDS', spaceCurrency: 'EUR',
    invitedByName: 'Sam', memberCount: 4, createdAt: '2026-06-01',
    status: 'PENDING', expiresAt: '2026-08-22'
  };

  /* ── splits (shared expenses, in the space's currency) ─── */
  const SPLITS = [
    { id: 'x_util', spaceId: 's_flat', title: 'Stadtwerke gas & power', totalMinor: 12400,
      currency: 'EUR', occurredOn: '2026-08-04', categoryId: 'c_uti',
      method: 'PERCENTAGE', origin: 'SPACE_DEFAULT', payerUserId: 'u_me',
      status: 'ACTIVE', createdBy: 'u_me', source: 'mobile',
      shares: [{ userId: 'u_me', amountMinor: 7440 }, { userId: 'u_mira', amountMinor: 4960 }] },

    { id: 'x_shop', spaceId: 's_flat', title: 'Weekly shop', totalMinor: 8400,
      currency: 'EUR', occurredOn: '2026-08-09', categoryId: 'c_gro',
      method: 'PERCENTAGE', origin: 'SPACE_DEFAULT', payerUserId: 'u_mira',
      status: 'ACTIVE', createdBy: 'u_mira', source: 'mobile',
      shares: [{ userId: 'u_me', amountMinor: 5040 }, { userId: 'u_mira', amountMinor: 3360 }] },

    { id: 'x_lokal', spaceId: 's_flat', title: 'Dinner at Lokal', totalMinor: 9800,
      currency: 'EUR', occurredOn: '2026-08-13', categoryId: 'c_din',
      method: 'EQUAL', origin: 'CUSTOM', payerUserId: 'u_me',
      status: 'ACTIVE', createdBy: 'u_me', source: 'mcp', client: 'ChatGPT',
      shares: [{ userId: 'u_me', amountMinor: 4900 }, { userId: 'u_mira', amountMinor: 4900 }] },

    { id: 'x_ryokan', spaceId: 's_tokyo', title: 'Ryokan Sakura', totalMinor: 42000,
      currency: 'JPY', occurredOn: '2026-08-07', categoryId: 'c_hou',
      method: 'EQUAL', origin: 'SPACE_DEFAULT', payerUserId: 'u_sam',
      status: 'ACTIVE', createdBy: 'u_sam', source: 'mobile',
      shares: [{ userId: 'u_me', amountMinor: 14000 }, { userId: 'u_mira', amountMinor: 14000 }, { userId: 'u_sam', amountMinor: 14000 }] },

    /* Cross-currency: paid from a EUR account into a JPY space. */
    { id: 'x_shink', spaceId: 's_tokyo', title: 'Shinkansen tickets', totalMinor: 27600,
      currency: 'JPY', occurredOn: '2026-08-07', categoryId: 'c_tra',
      method: 'EQUAL', origin: 'SPACE_DEFAULT', payerUserId: 'u_me',
      status: 'ACTIVE', createdBy: 'u_me', source: 'mobile',
      shares: [{ userId: 'u_me', amountMinor: 9200 }, { userId: 'u_mira', amountMinor: 9200 }, { userId: 'u_sam', amountMinor: 9200 }] },

    { id: 'x_sushi', spaceId: 's_tokyo', title: 'Sushi Zanmai', totalMinor: 9600,
      currency: 'JPY', occurredOn: '2026-08-09', categoryId: 'c_din',
      method: 'EQUAL', origin: 'SPACE_DEFAULT', payerUserId: 'u_mira',
      status: 'ACTIVE', createdBy: 'u_mira', source: 'mobile',
      shares: [{ userId: 'u_me', amountMinor: 3200 }, { userId: 'u_mira', amountMinor: 3200 }, { userId: 'u_sam', amountMinor: 3200 }] }
  ];

  /* ── transactions (in the account's currency) ─────────── */
  const TRANSACTIONS = [
    { id: 't_sal',   type: 'INCOME',  amountMinor: 385000, currency: 'EUR', toAccountId: 'a_rev',
      categoryId: 'c_sal', occurredOn: '2026-08-01', merchant: 'Monthly salary', source: 'mobile' },
    { id: 't_gym',   type: 'EXPENSE', amountMinor: 3900, currency: 'EUR', fromAccountId: 'a_n26',
      categoryId: 'c_hea', occurredOn: '2026-08-01', merchant: 'Urban Sports', subscriptionId: 'sb_gym', source: 'mobile' },
    { id: 't_edeka', type: 'EXPENSE', amountMinor: 4290, currency: 'EUR', fromAccountId: 'a_rev',
      categoryId: 'c_gro', occurredOn: '2026-08-03', merchant: 'Edeka', source: 'mobile' },

    /* linked to x_util — the payer's materialised transaction */
    { id: 't_util',  type: 'EXPENSE', amountMinor: 12400, currency: 'EUR', fromAccountId: 'a_n26',
      categoryId: 'c_uti', occurredOn: '2026-08-04', merchant: 'Stadtwerke gas & power',
      splitId: 'x_util', source: 'mobile' },

    { id: 't_cof',   type: 'EXPENSE', amountMinor: 420, currency: 'EUR', fromAccountId: 'a_rev',
      categoryId: 'c_cof', occurredOn: '2026-08-04', merchant: 'Bonanza Coffee', source: 'mobile' },
    { id: 't_bvg',   type: 'EXPENSE', amountMinor: 4900, currency: 'EUR', fromAccountId: 'a_rev',
      categoryId: 'c_tra', occurredOn: '2026-08-05', merchant: 'BVG monthly ticket', source: 'mobile' },
    { id: 't_nflx',  type: 'EXPENSE', amountMinor: 1099, currency: 'EUR', fromAccountId: 'a_visa',
      categoryId: 'c_ent', occurredOn: '2026-08-06', merchant: 'Netflix', subscriptionId: 'sb_nflx', source: 'mobile' },

    /* cross-currency: EUR account paying a JPY-denominated split */
    { id: 't_shink', type: 'EXPENSE', amountMinor: 16284, currency: 'EUR', fromAccountId: 'a_rev',
      categoryId: 'c_tra', occurredOn: '2026-08-07', merchant: 'Shinkansen tickets',
      splitId: 'x_shink', sourceAmountMinor: 27600, sourceCurrency: 'JPY',
      exchangeRate: 0.0059, source: 'mobile' },

    { id: 't_zal',   type: 'EXPENSE', amountMinor: 8600, currency: 'EUR', fromAccountId: 'a_visa',
      categoryId: 'c_sho', occurredOn: '2026-08-08', merchant: 'Zalando', source: 'mobile' },
    { id: 't_tr1',   type: 'TRANSFER', amountMinor: 50000, currency: 'EUR', fromAccountId: 'a_rev',
      toAccountId: 'a_sav', occurredOn: '2026-08-11', merchant: 'To Savings', source: 'mobile' },
    { id: 't_rewe',  type: 'EXPENSE', amountMinor: 3250, currency: 'EUR', fromAccountId: 'a_rev',
      categoryId: 'c_gro', occurredOn: '2026-08-12', merchant: 'Rewe', source: 'mobile' },

    /* linked to x_lokal — created via MCP */
    { id: 't_lokal', type: 'EXPENSE', amountMinor: 9800, currency: 'EUR', fromAccountId: 'a_rev',
      categoryId: 'c_din', occurredOn: '2026-08-13', merchant: 'Dinner at Lokal',
      splitId: 'x_lokal', source: 'mcp', client: 'ChatGPT' },

    { id: 't_must',  type: 'EXPENSE', amountMinor: 1850, currency: 'EUR', fromAccountId: 'a_rev',
      categoryId: 'c_din', occurredOn: '2026-08-14', merchant: "Mustafa's", source: 'mobile' },
    { id: 't_cash',  type: 'EXPENSE', amountMinor: 1200, currency: 'JPY', fromAccountId: 'a_cash',
      categoryId: 'c_cof', occurredOn: '2026-08-14', merchant: 'Doutor', source: 'mobile' },
    { id: 't_fre',   type: 'INCOME',  amountMinor: 62000, currency: 'EUR', toAccountId: 'a_n26',
      categoryId: 'c_fre', occurredOn: '2026-08-15', merchant: 'Design retainer', source: 'mobile' }
  ];

  /* ── settlements ──────────────────────────────────────── */
  const SETTLEMENTS = [
    { id: 'st_jul', spaceId: 's_flat', fromUserId: 'u_mira', toUserId: 'u_me',
      amountMinor: 6200, currency: 'EUR', status: 'CONFIRMED', note: 'July balance',
      createdBy: 'u_mira', confirmedBy: 'u_me', settledAt: '2026-07-31', source: 'mobile' },
    /* Awaiting the current user's confirmation → SETL-006 reachable */
    { id: 'st_pend', spaceId: 's_tokyo', fromUserId: 'u_mira', toUserId: 'u_me',
      amountMinor: 5000, currency: 'JPY', status: 'PROPOSED', note: 'Part of the trip',
      createdBy: 'u_mira', settledAt: null, createdAt: '2026-08-14', source: 'mobile' }
  ];

  /* ── budgets ──────────────────────────────────────────── */
  const BUDGETS = [
    { id: 'b_gro',  name: 'Groceries',   scope: 'PERSONAL', categoryId: 'c_gro', limitMinor: 25000, currency: 'EUR', startsOn: '2026-08-01', alerts: [80, 100] },
    { id: 'b_din',  name: 'Eating out',  scope: 'PERSONAL', categoryId: 'c_din', limitMinor: 12000, currency: 'EUR', startsOn: '2026-08-01', alerts: [80, 100] },
    { id: 'b_sho',  name: 'Shopping',    scope: 'PERSONAL', categoryId: 'c_sho', limitMinor: 6000,  currency: 'EUR', startsOn: '2026-08-01', alerts: [80, 100] },
    { id: 'b_futil',name: 'Utilities',   scope: 'SPACE', spaceId: 's_flat', categoryId: 'c_uti', limitMinor: 15000, currency: 'EUR', startsOn: '2026-08-01', alerts: [80, 100] },
    { id: 'b_tdin', name: 'Eating out',  scope: 'SPACE', spaceId: 's_tokyo', categoryId: 'c_din', limitMinor: 40000, currency: 'JPY', startsOn: '2026-08-01', alerts: [80, 100] }
  ];

  /* ── subscriptions ────────────────────────────────────── */
  const SUBSCRIPTIONS = [
    { id: 'sb_gym',  name: 'Urban Sports', amountMinor: 3900, currency: 'EUR', accountId: 'a_n26',  categoryId: 'c_hea', icon: 'health',
      cadence: { frequency: 'MONTHLY', interval: 1, dayOfMonth: 1 }, startsOn: '2025-03-01', nextDueOn: '2026-09-01', lastPaidOn: '2026-08-01', status: 'ACTIVE' },
    { id: 'sb_nflx', name: 'Netflix', amountMinor: 1099, currency: 'EUR', accountId: 'a_visa', categoryId: 'c_ent', icon: 'entertainment',
      cadence: { frequency: 'MONTHLY', interval: 1, dayOfMonth: 6 }, startsOn: '2024-11-06', nextDueOn: '2026-09-06', lastPaidOn: '2026-08-06', status: 'ACTIVE' },
    { id: 'sb_spot', name: 'Spotify', amountMinor: 1099, currency: 'EUR', accountId: 'a_rev', categoryId: 'c_ent', icon: 'entertainment',
      cadence: { frequency: 'MONTHLY', interval: 1, dayOfMonth: 18 }, startsOn: '2023-05-18', nextDueOn: '2026-08-18', lastPaidOn: '2026-07-18', status: 'ACTIVE' },
    { id: 'sb_icl',  name: 'iCloud+', amountMinor: 299, currency: 'EUR', accountId: 'a_visa', categoryId: 'c_fee', icon: 'receipt',
      cadence: { frequency: 'MONTHLY', interval: 1, dayOfMonth: 14 }, startsOn: '2022-01-14', nextDueOn: '2026-08-14', lastPaidOn: '2026-07-14', status: 'ACTIVE' },
    { id: 'sb_dom',  name: 'Domain renewal', amountMinor: 1400, currency: 'EUR', accountId: 'a_rev', categoryId: 'c_fee', icon: 'link',
      cadence: { frequency: 'YEARLY', interval: 1, monthOfYear: 11, dayOfMonth: 3 }, startsOn: '2021-11-03', nextDueOn: '2026-11-03', lastPaidOn: '2025-11-03', status: 'ACTIVE' },
    { id: 'sb_pod',  name: 'Podcast host', amountMinor: 1900, currency: 'EUR', accountId: 'a_rev', categoryId: 'c_ent', icon: 'entertainment',
      cadence: { frequency: 'MONTHLY', interval: 1, dayOfMonth: 22 }, startsOn: '2024-02-22', nextDueOn: null, lastPaidOn: '2026-06-22', status: 'PAUSED' }
  ];

  /* ── notifications ────────────────────────────────────── */
  const NOTIFICATIONS = [
    { id: 'n_1', type: 'AI_APPROVAL',      at: '2026-08-15T14:32', read: false,
      text: '<b>ChatGPT</b> needs your approval to record a payment', target: { screen: 'AI-007' } },
    { id: 'n_2', type: 'SETTLEMENT_REQUEST', at: '2026-08-14T18:40', read: false,
      text: '<b>Mira</b> says she paid you ¥5,000', target: { screen: 'SETL-006', id: 'st_pend' } },
    { id: 'n_3', type: 'AI_CHANGE',        at: '2026-08-13T19:12', read: false,
      text: '<b>ChatGPT</b> added Dinner at Lokal · €98.00 to Flat', target: { screen: 'SPACE-010', id: 'x_lokal' } },
    { id: 'n_4', type: 'EXPENSE_ADDED',    at: '2026-08-09T11:02', read: true,
      text: '<b>Mira</b> added Weekly shop · €84.00 to Flat', target: { screen: 'SPACE-010', id: 'x_shop' } },
    { id: 'n_5', type: 'BUDGET_ALERT',     at: '2026-08-08T09:30', read: true,
      text: "You've used 100% of your Shopping budget", target: { screen: 'BUD-002', id: 'b_sho' } },
    { id: 'n_6', type: 'INVITE',           at: '2026-08-06T16:20', read: true,
      text: '<b>Sam</b> invited you to Book Club', target: { screen: 'SPACE-009' } },
    { id: 'n_7', type: 'SETTLEMENT_CONFIRMED', at: '2026-07-31T20:05', read: true,
      text: '<b>Mira</b> settled €62.00 with you in Flat', target: { screen: 'SETL-005', id: 'st_jul' } }
  ];

  /* ── AI connections ───────────────────────────────────── */
  const AI_CONNECTIONS = [
    { id: 'con_gpt', clientId: 'chatgpt', clientName: 'ChatGPT', verified: true, status: 'ACTIVE',
      scopes: ['profile:read','accounts:read','transactions:read','analytics:read','spaces:read',
               'balances:read','settlements:read','budgets:read','subscriptions:read',
               'transactions:write','expenses:write','subscriptions:write'],
      limits: { perTxnMinor: 20000, dailyTotalMinor: 100000, dailyCount: 50,
                usedTodayMinor: 9800, usedTodayCount: 1, spaces: 'ALL', accounts: 'ALL' },
      createdAt: '2026-08-12', lastUsedAt: '2026-08-15T14:32', writeCount: 14, readCount: 312 },
    { id: 'con_cla', clientId: 'claude', clientName: 'Claude', verified: true, status: 'ACTIVE',
      scopes: ['profile:read','accounts:read','transactions:read','analytics:read','spaces:read','balances:read'],
      limits: { perTxnMinor: 0, dailyTotalMinor: 0, dailyCount: 0, usedTodayMinor: 0, usedTodayCount: 0, spaces: 'ALL', accounts: 'ALL' },
      createdAt: '2026-08-05', lastUsedAt: '2026-08-15T09:12', writeCount: 0, readCount: 87 },
    { id: 'con_lab', clientId: 'sidekick', clientName: 'Finance Sidekick', verified: false, status: 'SUSPENDED',
      suspendReason: 'Unusual activity — repeated blocked attempts',
      scopes: ['transactions:read','analytics:read'],
      limits: { perTxnMinor: 5000, dailyTotalMinor: 20000, dailyCount: 20, usedTodayMinor: 0, usedTodayCount: 0, spaces: 'ALL', accounts: 'ALL' },
      createdAt: '2026-08-14', lastUsedAt: '2026-08-14T22:10', writeCount: 0, readCount: 9 }
  ];

  const AI_ACTIVITY = [
    { id: 'aa_1', connectionId: 'con_gpt', client: 'ChatGPT', at: '2026-08-13T19:12', gate: 'two_phase',
      action: 'Added €98.00 expense', context: 'Flat · Restaurants', target: { screen: 'SPACE-010', id: 'x_lokal' }, outcome: 'SUCCESS' },
    { id: 'aa_2', connectionId: 'con_cla', client: 'Claude', at: '2026-08-12T11:17', gate: 'two_phase',
      action: 'Updated transaction category', context: 'Shopping → Groceries', target: { screen: 'TXN-002', id: 't_rewe' }, outcome: 'SUCCESS' },
    { id: 'aa_3', connectionId: 'con_gpt', client: 'ChatGPT', at: '2026-08-11T08:44', gate: 'two_phase',
      action: 'Added €32.50 expense', context: 'Personal · Groceries', target: { screen: 'TXN-002', id: 't_rewe' }, outcome: 'SUCCESS' },
    { id: 'aa_4', connectionId: 'con_lab', client: 'Finance Sidekick', at: '2026-08-14T22:10', gate: null,
      action: 'Tried to invite a member', context: 'Flat', target: null, outcome: 'BLOCKED' }
  ];

  const AI_APPROVALS = [
    { id: 'apr_1', connectionId: 'con_gpt', client: 'ChatGPT', tool: 'request_settlement',
      createdAt: '2026-08-15T14:32', expiresAt: '2026-08-15T15:02', state: 'PENDING',
      summary: 'Record that Mira paid you ¥5,000',
      reason: 'The user said Mira paid them back for the trip.',
      detail: [['Space','Tokyo Trip'],['From','Mira'],['To','You'],['Amount','¥5,000'],['Recorded on','Cash']],
      impact: 'Your balance in Tokyo Trip goes from <b>Mira owes you ¥12,400</b> to <b>Mira owes you ¥7,400</b>. ¥5,000 will be added to Cash.',
      payload: { kind: 'SETTLEMENT', spaceId: 's_tokyo', fromUserId: 'u_mira', toUserId: 'u_me', amountMinor: 5000, accountId: 'a_cash' } }
  ];

  /* ── space activity feed ──────────────────────────────── */
  const SPACE_ACTIVITY = [
    { id: 'ev_1', spaceId: 's_flat',  at: '2026-08-13T19:12', actor: 'u_me',   type: 'EXPENSE_ADDED',   text: 'added Dinner at Lokal', amountMinor: 9800, currency: 'EUR', via: 'ChatGPT', target: { screen: 'SPACE-010', id: 'x_lokal' } },
    { id: 'ev_2', spaceId: 's_flat',  at: '2026-08-09T11:02', actor: 'u_mira', type: 'EXPENSE_ADDED',   text: 'added Weekly shop',     amountMinor: 8400, currency: 'EUR', target: { screen: 'SPACE-010', id: 'x_shop' } },
    { id: 'ev_3', spaceId: 's_flat',  at: '2026-08-04T08:30', actor: 'u_me',   type: 'EXPENSE_ADDED',   text: 'added Stadtwerke gas & power', amountMinor: 12400, currency: 'EUR', target: { screen: 'SPACE-010', id: 'x_util' } },
    { id: 'ev_4', spaceId: 's_flat',  at: '2026-07-31T20:05', actor: 'u_mira', type: 'SETTLEMENT',      text: 'settled with you',      amountMinor: 6200, currency: 'EUR', target: { screen: 'SETL-005', id: 'st_jul' } },
    { id: 'ev_5', spaceId: 's_flat',  at: '2026-02-14T10:00', actor: 'u_mira', type: 'MEMBER_JOINED',   text: 'joined the space' },
    { id: 'ev_6', spaceId: 's_tokyo', at: '2026-08-14T18:40', actor: 'u_mira', type: 'SETTLEMENT',      text: 'says she paid you',     amountMinor: 5000, currency: 'JPY', target: { screen: 'SETL-005', id: 'st_pend' } },
    { id: 'ev_7', spaceId: 's_tokyo', at: '2026-08-09T13:20', actor: 'u_mira', type: 'EXPENSE_ADDED',   text: 'added Sushi Zanmai',    amountMinor: 9600, currency: 'JPY', target: { screen: 'SPACE-010', id: 'x_sushi' } },
    { id: 'ev_8', spaceId: 's_tokyo', at: '2026-08-07T09:05', actor: 'u_me',   type: 'EXPENSE_ADDED',   text: 'added Shinkansen tickets', amountMinor: 27600, currency: 'JPY', target: { screen: 'SPACE-010', id: 'x_shink' } },
    { id: 'ev_9', spaceId: 's_tokyo', at: '2026-08-07T08:50', actor: 'u_sam',  type: 'EXPENSE_ADDED',   text: 'added Ryokan Sakura',   amountMinor: 42000, currency: 'JPY', target: { screen: 'SPACE-010', id: 'x_ryokan' } },
    { id: 'ev_10', spaceId: 's_tokyo', at: '2026-07-29T12:00', actor: 'u_sam', type: 'MEMBER_JOINED',   text: 'joined the space' }
  ];

  return {
    TODAY, ME, CURRENCIES, RATES, USERS, PROFILE,
    ACCOUNTS, CATEGORIES, SPACES, INVITES, INCOMING_INVITE,
    SPLITS, TRANSACTIONS, SETTLEMENTS, BUDGETS, SUBSCRIPTIONS,
    NOTIFICATIONS, AI_CONNECTIONS, AI_ACTIVITY, AI_APPROVALS, SPACE_ACTIVITY,
    seq: 1000
  };
})();
