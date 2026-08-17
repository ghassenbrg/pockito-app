/* ============================================================
   Pockito prototype — domain rules
   The only place financial logic exists. Screens never compute.

   Implements, from the specs:
     · the two lenses      — cash flow vs spending (§5, P2)
     · the three currency roles (§5.6)
     · derived balances    — never stored
     · split calculation   — with rounding to the payer
     · member balances     — always in the space's currency
     · settlement minimisation
     · budget consumption  — personal counts your share, space counts all
   ============================================================ */
window.Domain = (function () {
  const D = window.DB;
  const ME = D.ME;

  /* ── money ────────────────────────────────────────────── */
  function cur(code) { return D.CURRENCIES[code] || D.CURRENCIES.EUR; }

  function fmt(minor, code, opts) {
    opts = opts || {};
    const c = cur(code);
    const neg = minor < 0;
    const v = Math.abs(minor) / Math.pow(10, c.decimals);
    const s = v.toLocaleString('en-US', {
      minimumFractionDigits: c.decimals, maximumFractionDigits: c.decimals
    });
    const sign = neg ? '−' : (opts.plus ? '+' : '');
    return sign + c.symbol + s;
  }
  /* Appends the ISO code when the amount is not in the reporting currency. */
  function fmtC(minor, code) {
    const s = fmt(minor, code);
    return code === D.PROFILE.reportingCurrency ? s
      : s + ' <span class="ccy">' + code + '</span>';
  }
  function parseToMinor(str, code) {
    const c = cur(code);
    const n = parseFloat(String(str).replace(/[^0-9.\-]/g, ''));
    if (isNaN(n)) return 0;
    return Math.round(n * Math.pow(10, c.decimals));
  }

  /* ── FX (unit of reporting) ───────────────────────────── */
  function rate(from, to) {
    const R = D.RATES.to;
    if (from === to) return 1;
    if (R[from] == null || R[to] == null) return null;
    return R[from] / R[to];
  }
  /* Convert into the reporting currency. Returns null when no rate exists —
     the caller must then refuse to combine rather than approximate (P6). */
  function toReporting(minor, from) {
    const to = D.PROFILE.reportingCurrency;
    if (from === to) return minor;
    const r = rate(from, to);
    if (r == null) return null;
    const major = minor / Math.pow(10, cur(from).decimals);
    return Math.round(major * r * Math.pow(10, cur(to).decimals));
  }
  function convert(minor, from, to) {
    if (from === to) return minor;
    const r = rate(from, to);
    if (r == null) return null;
    const major = minor / Math.pow(10, cur(from).decimals);
    return Math.round(major * r * Math.pow(10, cur(to).decimals));
  }

  /* ── lookups ──────────────────────────────────────────── */
  const account   = id => D.ACCOUNTS.find(a => a.id === id);
  const category  = id => D.CATEGORIES.find(c => c.id === id);
  const space     = id => D.SPACES.find(s => s.id === id);
  const split     = id => D.SPLITS.find(s => s.id === id);
  const txn       = id => D.TRANSACTIONS.find(t => t.id === id);
  const budget    = id => D.BUDGETS.find(b => b.id === id);
  const sub       = id => D.SUBSCRIPTIONS.find(s => s.id === id);
  const settlement= id => D.SETTLEMENTS.find(s => s.id === id);
  const user      = id => D.USERS[id] || { id, name: 'Unknown', initials: '?' };
  const userName  = id => (id === ME ? 'You' : user(id).name);
  const conn      = id => D.AI_CONNECTIONS.find(c => c.id === id);

  function member(spaceId, userId) {
    const s = space(spaceId);
    return s && s.members.find(m => m.userId === userId);
  }
  const activeAccounts = () => D.ACCOUNTS.filter(a => !a.archived).sort((a, b) => a.sortOrder - b.sortOrder);
  const archivedAccounts = () => D.ACCOUNTS.filter(a => a.archived);
  const activeSpaces = () => D.SPACES.filter(s => s.status === 'ACTIVE');
  const archivedSpaces = () => D.SPACES.filter(s => s.status === 'ARCHIVED');
  const liveTxns = () => D.TRANSACTIONS.filter(t => t.status !== 'VOIDED' && !t.deleted);
  const liveSplits = () => D.SPLITS.filter(s => s.status !== 'VOIDED' && !s.deleted);

  /* ── dates ────────────────────────────────────────────── */
  const MONTHS = ['January','February','March','April','May','June','July','August','September','October','November','December'];
  function dateLabel(d) {
    if (d === D.TODAY) return 'Today';
    const y = new Date(D.TODAY); y.setDate(y.getDate() - 1);
    if (d === y.toISOString().slice(0, 10)) return 'Yesterday';
    const p = d.split('-');
    const short = MONTHS[+p[1] - 1].slice(0, 3);
    return (+p[2]) + ' ' + short + (p[0] !== D.TODAY.slice(0, 4) ? ' ' + p[0] : '');
  }
  function dateLong(d) {
    const p = d.split('-');
    return (+p[2]) + ' ' + MONTHS[+p[1] - 1] + ' ' + p[0];
  }
  function daysUntil(d) {
    return Math.round((new Date(d) - new Date(D.TODAY)) / 86400000);
  }
  function dueLabel(d) {
    if (!d) return '';
    const n = daysUntil(d);
    if (n === 0) return 'Due today';
    if (n < 0) return 'Overdue by ' + Math.abs(n) + (Math.abs(n) === 1 ? ' day' : ' days');
    if (n === 1) return 'Due tomorrow';
    return 'Due in ' + n + ' days';
  }
  function relTime(iso) {
    const then = new Date(iso.replace(' ', 'T'));
    const now = new Date(D.TODAY + 'T18:00');
    const mins = Math.round((now - then) / 60000);
    if (mins < 60) return Math.max(1, mins) + 'm ago';
    if (mins < 1440) return Math.round(mins / 60) + 'h ago';
    const days = Math.round(mins / 1440);
    if (days < 7) return days + 'd ago';
    return dateLabel(iso.slice(0, 10));
  }
  function monthOf(d) { return d.slice(0, 7); }
  const CURRENT_MONTH = monthOf(D.TODAY);
  function monthLabel(m) {
    const p = m.split('-');
    return MONTHS[+p[1] - 1] + ' ' + p[0];
  }

  /* ── CASH FLOW lens — what actually moved ─────────────── */
  function balance(accountId) {
    const a = account(accountId);
    if (!a) return 0;
    let bal = a.opening;
    liveTxns().forEach(t => {
      if (t.fromAccountId === accountId) bal -= t.amountMinor;
      if (t.toAccountId === accountId) bal += t.amountMinor;
    });
    return bal;
  }
  /* Net worth across currencies. Refuses to combine without a rate. */
  function netWorth() {
    const byCur = {};
    let total = 0, ok = true;
    const missing = [];
    activeAccounts().forEach(a => {
      const b = balance(a.id);
      byCur[a.currency] = (byCur[a.currency] || 0) + b;
      const c = toReporting(b, a.currency);
      if (c == null) { ok = false; if (!missing.includes(a.currency)) missing.push(a.currency); }
      else total += c;
    });
    return { total: ok ? total : null, byCurrency: byCur, missing, currency: D.PROFILE.reportingCurrency };
  }
  function cashFlow(month) {
    month = month || CURRENT_MONTH;
    let out = 0, inn = 0;
    liveTxns().filter(t => monthOf(t.occurredOn) === month).forEach(t => {
      const v = toReporting(t.amountMinor, t.currency);
      if (v == null) return;
      if (t.type === 'EXPENSE' || t.type === 'SETTLEMENT_OUT') out += v;
      if (t.type === 'SETTLEMENT') { if (t.fromAccountId) out += v; else inn += v; }
      if (t.type === 'INCOME') inn += v;
    });
    return { out, in: inn, currency: D.PROFILE.reportingCurrency };
  }
  function accountMonth(accountId, month) {
    month = month || CURRENT_MONTH;
    let out = 0, inn = 0;
    liveTxns().filter(t => monthOf(t.occurredOn) === month).forEach(t => {
      if (t.fromAccountId === accountId) out += t.amountMinor;
      if (t.toAccountId === accountId) inn += t.amountMinor;
    });
    return { out, in: inn };
  }

  /* ── SPENDING lens — your share of what was consumed ──── */
  function spending(month) {
    month = month || CURRENT_MONTH;
    let total = 0;
    /* personal expenses only — a shared expense's transaction is excluded,
       because the split carries your share instead */
    liveTxns().forEach(t => {
      if (t.type !== 'EXPENSE' || t.splitId) return;
      if (monthOf(t.occurredOn) !== month) return;
      const v = toReporting(t.amountMinor, t.currency);
      if (v != null) total += v;
    });
    /* your share of every shared expense, whoever paid */
    liveSplits().forEach(s => {
      if (monthOf(s.occurredOn) !== month) return;
      const mine = s.shares.find(x => x.userId === ME);
      if (!mine) return;
      const v = toReporting(mine.amountMinor, s.currency);
      if (v != null) total += v;
    });
    /* settlements are never spending */
    return { total, currency: D.PROFILE.reportingCurrency };
  }

  /* Category breakdown, spending lens, reporting currency. */
  function spendingByCategory(month) {
    month = month || CURRENT_MONTH;
    const map = {};
    const add = (cid, v) => { if (v != null) map[cid || '_none'] = (map[cid || '_none'] || 0) + v; };
    liveTxns().forEach(t => {
      if (t.type !== 'EXPENSE' || t.splitId) return;
      if (monthOf(t.occurredOn) !== month) return;
      add(t.categoryId, toReporting(t.amountMinor, t.currency));
    });
    liveSplits().forEach(s => {
      if (monthOf(s.occurredOn) !== month) return;
      const mine = s.shares.find(x => x.userId === ME);
      if (!mine) return;
      add(s.categoryId, toReporting(mine.amountMinor, s.currency));
    });
    const total = Object.values(map).reduce((a, b) => a + b, 0);
    return Object.entries(map)
      .map(([cid, amt]) => ({ categoryId: cid, amountMinor: amt, percent: total ? amt / total * 100 : 0 }))
      .sort((a, b) => b.amountMinor - a.amountMinor);
  }

  /* ── splits ───────────────────────────────────────────── */
  /* Rounding remainder always goes to the payer, and is disclosed. */
  function computeShares(totalMinor, method, memberIds, values, payerId) {
    const inc = memberIds.filter(id => values.included[id]);
    if (!inc.length) return [];
    if (method === 'EQUAL') {
      const per = Math.floor(totalMinor / inc.length);
      const rem = totalMinor - per * inc.length;
      return inc.map(id => ({ userId: id, amountMinor: per + (id === payerId ? rem : 0) }));
    }
    if (method === 'PERCENTAGE') {
      let run = 0;
      return inc.map((id, i) => {
        if (i === inc.length - 1) return { userId: id, amountMinor: totalMinor - run };
        const a = Math.round(totalMinor * (+values.percent[id] || 0) / 100);
        run += a;
        return { userId: id, amountMinor: a };
      });
    }
    return inc.map(id => ({ userId: id, amountMinor: +values.exact[id] || 0 }));
  }
  function roundingFor(totalMinor, method, count) {
    if (method !== 'EQUAL' || !count) return 0;
    return totalMinor - Math.floor(totalMinor / count) * count;
  }

  /* ── member balances — always in the space's currency ─── */
  function memberBalances(spaceId, scope) {
    const s = space(spaceId);
    if (!s) return {};
    const net = {};
    s.members.forEach(m => net[m.userId] = 0);
    /* CYCLE scope: only rows after the last confirmed settlement. The boundary
       settlement ITSELF is excluded, so its zero-out effect stays in the cycle
       it closed rather than leaking into the new one. */
    const bnd = scope === 'lifetime' ? null : lastSettlement(spaceId);
    liveSplits().filter(x => x.spaceId === spaceId).forEach(x => {
      if (bnd && x.occurredOn < bnd.settledAt) return;
      net[x.payerUserId] = (net[x.payerUserId] || 0) + x.totalMinor;
      x.shares.forEach(sh => net[sh.userId] = (net[sh.userId] || 0) - sh.amountMinor);
    });
    D.SETTLEMENTS.filter(st => st.spaceId === spaceId && st.status === 'CONFIRMED').forEach(st => {
      if (bnd && (st.id === bnd.id || st.settledAt < bnd.settledAt)) return;
      net[st.fromUserId] = (net[st.fromUserId] || 0) + st.amountMinor;
      net[st.toUserId]   = (net[st.toUserId]   || 0) - st.amountMinor;
    });
    return net;
  }
  function lastSettlement(spaceId) {
    const done = D.SETTLEMENTS
      .filter(s => s.spaceId === spaceId && s.status === 'CONFIRMED' && s.settledAt)
      .sort((a, b) => b.settledAt.localeCompare(a.settledAt) || b.id.localeCompare(a.id));
    return done.length ? done[0] : null;
  }
  function lastSettlementAt(spaceId) {
    const s = lastSettlement(spaceId);
    return s ? s.settledAt : null;
  }
  const myBalance = (spaceId, scope) => memberBalances(spaceId, scope)[ME] || 0;

  /* Minimum set of payments that clears everyone. */
  function settlementPlan(spaceId, scope) {
    const net = memberBalances(spaceId, scope);
    const cred = Object.entries(net).filter(([, v]) => v > 0).map(([u, v]) => ({ u, v })).sort((a, b) => b.v - a.v);
    const debt = Object.entries(net).filter(([, v]) => v < 0).map(([u, v]) => ({ u, v: -v })).sort((a, b) => b.v - a.v);
    const out = [];
    let i = 0, j = 0;
    while (i < cred.length && j < debt.length) {
      const amt = Math.min(cred[i].v, debt[j].v);
      if (amt > 0) out.push({ fromUserId: debt[j].u, toUserId: cred[i].u, amountMinor: amt });
      cred[i].v -= amt; debt[j].v -= amt;
      if (cred[i].v < 1) i++;
      if (debt[j].v < 1) j++;
    }
    return out;
  }
  /* Aggregate across spaces, converted to reporting currency. */
  function sharedSummary() {
    let owed = 0, owe = 0;
    const rows = [];
    activeSpaces().forEach(s => {
      const n = myBalance(s.id);
      const c = toReporting(n, s.currency);
      rows.push({ spaceId: s.id, net: n, currency: s.currency, converted: c });
      if (c == null) return;
      if (c > 0) owed += c; else owe += -c;
    });
    return { owed, owe, rows, currency: D.PROFILE.reportingCurrency };
  }
  function outstandingBetween(spaceId, fromId, toId) {
    const plan = settlementPlan(spaceId);
    const p = plan.find(x => x.fromUserId === fromId && x.toUserId === toId);
    return p ? p.amountMinor : 0;
  }

  /* ── budgets ──────────────────────────────────────────── */
  function budgetUsed(b, month) {
    month = month || CURRENT_MONTH;
    let used = 0;
    if (b.scope === 'PERSONAL') {
      /* personal counts YOUR SHARE of shared expenses */
      liveTxns().forEach(t => {
        if (t.type !== 'EXPENSE' || t.splitId) return;
        if (t.categoryId !== b.categoryId || monthOf(t.occurredOn) !== month) return;
        const v = convert(t.amountMinor, t.currency, b.currency);
        if (v != null) used += v;
      });
      liveSplits().forEach(s => {
        if (s.categoryId !== b.categoryId || monthOf(s.occurredOn) !== month) return;
        const mine = s.shares.find(x => x.userId === ME);
        if (!mine) return;
        const v = convert(mine.amountMinor, s.currency, b.currency);
        if (v != null) used += v;
      });
    } else {
      /* space counts EVERY member's share */
      liveSplits().forEach(s => {
        if (s.spaceId !== b.spaceId || s.categoryId !== b.categoryId) return;
        if (monthOf(s.occurredOn) !== month) return;
        used += s.shares.reduce((a, x) => a + x.amountMinor, 0);
      });
    }
    return used;
  }
  function budgetStatus(b, month) {
    const used = budgetUsed(b, month);
    const pct = b.limitMinor ? used / b.limitMinor * 100 : 0;
    const daysInMonth = 31, elapsed = +D.TODAY.slice(8), remaining = daysInMonth - elapsed;
    return {
      used, limit: b.limitMinor, remaining: b.limitMinor - used, percent: pct,
      state: pct > 100 ? 'OVER' : pct >= 80 ? 'NEAR' : 'OK',
      daysElapsed: elapsed, daysRemaining: remaining,
      dailyAvg: elapsed ? Math.round(used / elapsed) : 0,
      allowancePerDay: remaining > 0 ? Math.max(0, Math.round((b.limitMinor - used) / remaining)) : 0,
      projected: elapsed ? Math.round(used / elapsed * daysInMonth) : 0
    };
  }
  function budgetTxns(b, month) {
    month = month || CURRENT_MONTH;
    const rows = [];
    if (b.scope === 'PERSONAL') {
      liveTxns().forEach(t => {
        if (t.type !== 'EXPENSE' || t.splitId) return;
        if (t.categoryId !== b.categoryId || monthOf(t.occurredOn) !== month) return;
        rows.push({ kind: 'txn', ref: t, amountMinor: t.amountMinor, currency: t.currency });
      });
      liveSplits().forEach(s => {
        if (s.categoryId !== b.categoryId || monthOf(s.occurredOn) !== month) return;
        const mine = s.shares.find(x => x.userId === ME);
        if (mine) rows.push({ kind: 'split', ref: s, amountMinor: mine.amountMinor, currency: s.currency, share: true });
      });
    } else {
      liveSplits().forEach(s => {
        if (s.spaceId !== b.spaceId || s.categoryId !== b.categoryId) return;
        if (monthOf(s.occurredOn) !== month) return;
        rows.push({ kind: 'split', ref: s, amountMinor: s.totalMinor, currency: s.currency });
      });
    }
    return rows.sort((a, b2) => b2.amountMinor - a.amountMinor);
  }

  /* ── subscriptions ────────────────────────────────────── */
  function monthlyEquivalent(s) {
    const f = s.cadence.frequency, i = s.cadence.interval || 1;
    let m = s.amountMinor;
    if (f === 'DAILY')   m = s.amountMinor * 30.44 / i;
    if (f === 'WEEKLY')  m = s.amountMinor * 4.33 / i;
    if (f === 'MONTHLY') m = s.amountMinor / i;
    if (f === 'YEARLY')  m = s.amountMinor / (12 * i);
    return Math.round(m);
  }
  function subsMonthlyTotal() {
    const byCur = {};
    let total = 0, ok = true;
    D.SUBSCRIPTIONS.filter(s => s.status === 'ACTIVE').forEach(s => {
      const m = monthlyEquivalent(s);
      byCur[s.currency] = (byCur[s.currency] || 0) + m;
      const c = toReporting(m, s.currency);
      if (c == null) ok = false; else total += c;
    });
    return { total: ok ? total : null, byCurrency: byCur, currency: D.PROFILE.reportingCurrency };
  }
  function cadenceLabel(c) {
    const i = c.interval || 1;
    const every = i === 1 ? 'Every' : 'Every ' + i;
    if (c.frequency === 'DAILY')   return i === 1 ? 'Every day' : every + ' days';
    if (c.frequency === 'WEEKLY')  return (i === 1 ? 'Every week' : every + ' weeks');
    if (c.frequency === 'MONTHLY') return (i === 1 ? 'Monthly' : every + ' months') + (c.dayOfMonth ? ' on the ' + ordinal(c.dayOfMonth) : '');
    if (c.frequency === 'YEARLY')  return (i === 1 ? 'Yearly' : every + ' years') + (c.monthOfYear ? ' in ' + MONTHS[c.monthOfYear - 1] : '');
    return 'Monthly';
  }
  function ordinal(n) {
    const s = ['th','st','nd','rd'], v = n % 100;
    return n + (s[(v - 20) % 10] || s[v] || s[0]);
  }
  function nextDueAfter(sub) {
    const d = new Date(sub.nextDueOn || D.TODAY);
    const c = sub.cadence, i = c.interval || 1;
    if (c.frequency === 'DAILY') d.setDate(d.getDate() + i);
    if (c.frequency === 'WEEKLY') d.setDate(d.getDate() + 7 * i);
    if (c.frequency === 'MONTHLY') d.setMonth(d.getMonth() + i);
    if (c.frequency === 'YEARLY') d.setFullYear(d.getFullYear() + i);
    return d.toISOString().slice(0, 10);
  }

  /* ── transaction helpers ──────────────────────────────── */
  function txnSign(t) {
    if (t.type === 'INCOME') return '+';
    if (t.type === 'TRANSFER') return '';
    return '−';
  }
  function txnTitle(t) {
    if (t.merchant) return t.merchant;
    if (t.type === 'TRANSFER') return (account(t.fromAccountId) || {}).name + ' → ' + (account(t.toAccountId) || {}).name;
    const c = category(t.categoryId);
    return c ? c.name : 'Transaction';
  }
  function txnAccount(t) { return account(t.fromAccountId || t.toAccountId); }
  function myShareOf(t) {
    if (!t.splitId) return null;
    const s = split(t.splitId);
    if (!s) return null;
    const mine = s.shares.find(x => x.userId === ME);
    return mine ? { amountMinor: mine.amountMinor, currency: s.currency, split: s } : null;
  }
  /* Transactions visible in the ledger, newest first. */
  function ledger(filters) {
    filters = filters || {};
    let rows = liveTxns().slice();
    if (filters.month) rows = rows.filter(t => monthOf(t.occurredOn) === filters.month);
    if (filters.accountId) rows = rows.filter(t => t.fromAccountId === filters.accountId || t.toAccountId === filters.accountId);
    if (filters.types && filters.types.length) rows = rows.filter(t => filters.types.includes(t.type));
    if (filters.categoryIds && filters.categoryIds.length) rows = rows.filter(t => filters.categoryIds.includes(t.categoryId));
    if (filters.spaceIds && filters.spaceIds.length) {
      rows = rows.filter(t => {
        if (filters.spaceIds.includes('__personal')) return !t.splitId;
        const s = t.splitId && split(t.splitId);
        return s && filters.spaceIds.includes(s.spaceId);
      });
    }
    if (filters.sources && filters.sources.length) rows = rows.filter(t => filters.sources.includes(t.source || 'mobile'));
    if (filters.minMinor) rows = rows.filter(t => t.amountMinor >= filters.minMinor);
    if (filters.maxMinor) rows = rows.filter(t => t.amountMinor <= filters.maxMinor);
    if (filters.q) {
      const q = filters.q.toLowerCase();
      rows = rows.filter(t => {
        const c = category(t.categoryId);
        const a = txnAccount(t);
        return (t.merchant || '').toLowerCase().includes(q)
          || (c && c.name.toLowerCase().includes(q))
          || (a && a.name.toLowerCase().includes(q))
          || String(t.amountMinor).includes(q.replace(/[^0-9]/g, ''));
      });
    }
    return rows.sort((a, b) => b.occurredOn.localeCompare(a.occurredOn) || b.id.localeCompare(a.id));
  }
  function groupByDate(rows) {
    const g = {};
    rows.forEach(t => (g[t.occurredOn] = g[t.occurredOn] || []).push(t));
    return Object.keys(g).sort().reverse().map(d => ({ date: d, rows: g[d] }));
  }
  function spaceSplits(spaceId, filters) {
    filters = filters || {};
    let rows = liveSplits().filter(s => s.spaceId === spaceId);
    if (filters.status === 'settled') rows = rows.filter(s => s.status === 'SETTLED');
    if (filters.status === 'unsettled') rows = rows.filter(s => s.status !== 'SETTLED');
    if (filters.payers && filters.payers.length) rows = rows.filter(s => filters.payers.includes(s.payerUserId));
    if (filters.categoryIds && filters.categoryIds.length) rows = rows.filter(s => filters.categoryIds.includes(s.categoryId));
    return rows.sort((a, b) => b.occurredOn.localeCompare(a.occurredOn));
  }

  /* ── mutations ────────────────────────────────────────── */
  const nextId = p => p + '_' + (++D.seq);

  function addTransaction(t) {
    t.id = t.id || nextId('t');
    t.source = t.source || 'mobile';
    D.TRANSACTIONS.push(t);
    return t;
  }
  function addSharedExpense(cfg) {
    /* One entry → one Split, and AT MOST one Transaction (the payer's). */
    const sp = space(cfg.spaceId);
    const s = {
      id: nextId('x'), spaceId: cfg.spaceId, title: cfg.title,
      totalMinor: cfg.totalMinor, currency: sp.currency,
      occurredOn: cfg.occurredOn, categoryId: cfg.categoryId,
      method: cfg.method, origin: cfg.origin || 'CUSTOM',
      payerUserId: cfg.payerUserId, status: 'ACTIVE',
      createdBy: ME, source: cfg.source || 'mobile', shares: cfg.shares
    };
    D.SPLITS.push(s);
    let tx = null;
    if (cfg.payerUserId === ME && cfg.accountId && cfg.accountId !== 'UNTRACKED') {
      const acc = account(cfg.accountId);
      const paid = convert(cfg.totalMinor, sp.currency, acc.currency);
      tx = addTransaction({
        type: 'EXPENSE', amountMinor: paid, currency: acc.currency,
        fromAccountId: cfg.accountId, categoryId: cfg.categoryId,
        occurredOn: cfg.occurredOn, merchant: cfg.title, splitId: s.id,
        sourceAmountMinor: acc.currency !== sp.currency ? cfg.totalMinor : undefined,
        sourceCurrency:    acc.currency !== sp.currency ? sp.currency : undefined,
        exchangeRate:      acc.currency !== sp.currency ? rate(sp.currency, acc.currency) : undefined,
        source: cfg.source || 'mobile'
      });
    }
    D.SPACE_ACTIVITY.unshift({
      id: nextId('ev'), spaceId: cfg.spaceId, at: D.TODAY + 'T' + nowClock(),
      actor: ME, type: 'EXPENSE_ADDED', text: 'added ' + cfg.title,
      amountMinor: cfg.totalMinor, currency: sp.currency,
      target: { screen: 'SPACE-010', id: s.id }
    });
    return { split: s, txn: tx };
  }
  function updateSharedExpense(id, patch) {
    const s = split(id);
    if (!s) return null;
    Object.assign(s, patch);
    const t = D.TRANSACTIONS.find(x => x.splitId === id && x.fromAccountId);
    if (t && patch.totalMinor != null) {
      const acc = account(t.fromAccountId);
      t.amountMinor = convert(patch.totalMinor, s.currency, acc.currency);
      if (acc.currency !== s.currency) { t.sourceAmountMinor = patch.totalMinor; t.sourceCurrency = s.currency; }
    }
    if (t && patch.title) t.merchant = patch.title;
    if (t && patch.categoryId) t.categoryId = patch.categoryId;
    return s;
  }
  function deleteTransaction(id) {
    const t = txn(id);
    if (!t) return;
    t.deleted = true;
    if (t.splitId) { const s = split(t.splitId); if (s) s.deleted = true; }
  }
  function restoreTransaction(id) {
    const t = D.TRANSACTIONS.find(x => x.id === id);
    if (!t) return;
    delete t.deleted;
    if (t.splitId) { const s = D.SPLITS.find(x => x.id === t.splitId); if (s) delete s.deleted; }
  }
  function deleteSplit(id) {
    const s = D.SPLITS.find(x => x.id === id);
    if (s) s.deleted = true;
    const t = D.TRANSACTIONS.find(x => x.splitId === id);
    if (t) t.deleted = true;
  }
  function confirmSettlement(cfg) {
    const sp = space(cfg.spaceId);
    const st = {
      id: nextId('st'), spaceId: cfg.spaceId, fromUserId: cfg.fromUserId,
      toUserId: cfg.toUserId, amountMinor: cfg.amountMinor, currency: sp.currency,
      status: 'CONFIRMED', note: cfg.note || '', createdBy: ME, confirmedBy: ME,
      settledAt: D.TODAY, source: cfg.source || 'mobile'
    };
    D.SETTLEMENTS.push(st);
    if (cfg.accountId) {
      const acc = account(cfg.accountId);
      const amt = convert(cfg.amountMinor, sp.currency, acc.currency);
      const iPay = cfg.fromUserId === ME;
      addTransaction({
        type: 'SETTLEMENT', amountMinor: amt, currency: acc.currency,
        fromAccountId: iPay ? cfg.accountId : undefined,
        toAccountId: iPay ? undefined : cfg.accountId,
        occurredOn: D.TODAY, settlementId: st.id,
        merchant: 'Settled with ' + userName(iPay ? cfg.toUserId : cfg.fromUserId),
        sourceAmountMinor: acc.currency !== sp.currency ? cfg.amountMinor : undefined,
        sourceCurrency:    acc.currency !== sp.currency ? sp.currency : undefined
      });
    }
    D.SPACE_ACTIVITY.unshift({
      id: nextId('ev'), spaceId: cfg.spaceId, at: D.TODAY + 'T' + nowClock(),
      actor: cfg.fromUserId, type: 'SETTLEMENT', text: 'settled with ' + userName(cfg.toUserId),
      amountMinor: cfg.amountMinor, currency: sp.currency,
      target: { screen: 'SETL-005', id: st.id }
    });
    return st;
  }
  function nowClock() {
    const n = new Date();
    return String(n.getHours()).padStart(2, '0') + ':' + String(n.getMinutes()).padStart(2, '0');
  }
  function paySubscription(id, cfg) {
    const s = sub(id);
    if (!s) return null;
    const t = addTransaction({
      type: 'EXPENSE', amountMinor: cfg.amountMinor != null ? cfg.amountMinor : s.amountMinor,
      currency: s.currency, fromAccountId: cfg.accountId || s.accountId,
      categoryId: s.categoryId, occurredOn: cfg.occurredOn || s.nextDueOn || D.TODAY,
      merchant: s.name, subscriptionId: s.id
    });
    s.lastPaidOn = t.occurredOn;
    s.nextDueOn = nextDueAfter(s);
    return t;
  }
  function skipSubscription(id) {
    const s = sub(id);
    if (!s) return;
    s.nextDueOn = nextDueAfter(s);
  }

  return {
    D, ME, TODAY: D.TODAY, CURRENT_MONTH, MONTHS,
    cur, fmt, fmtC, parseToMinor, rate, toReporting, convert,
    account, category, space, split, txn, budget, sub, settlement, user, userName, member, conn,
    activeAccounts, archivedAccounts, activeSpaces, archivedSpaces, liveTxns, liveSplits,
    dateLabel, dateLong, daysUntil, dueLabel, relTime, monthOf, monthLabel, ordinal,
    balance, netWorth, cashFlow, accountMonth,
    spending, spendingByCategory,
    computeShares, roundingFor,
    memberBalances, myBalance, settlementPlan, sharedSummary, lastSettlementAt, outstandingBetween,
    budgetUsed, budgetStatus, budgetTxns,
    monthlyEquivalent, subsMonthlyTotal, cadenceLabel, nextDueAfter,
    txnSign, txnTitle, txnAccount, myShareOf, ledger, groupByDate, spaceSplits,
    addTransaction, addSharedExpense, updateSharedExpense, deleteTransaction, restoreTransaction,
    deleteSplit, confirmSettlement, paySubscription, skipSubscription, nextId
  };
})();
