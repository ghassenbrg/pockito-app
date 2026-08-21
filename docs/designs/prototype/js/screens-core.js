/* ============================================================
   Screens — personal finance
   HOME-001..003 · ACC-001..006 · TXN-001..006 · SPLIT-001 · PICK-001..007
   ============================================================ */
window.Screens = window.Screens || {};
(function () {
  const M = window.Domain, U = window.UI, S = window.Screens;
  const esc = U.esc;

  /* ══ HOME-001 ══════════════════════════════════════════ */
  S['HOME-001'] = function (st) {
    const month = st.month;
    const nw = M.netWorth();
    const sp = M.spending(month);
    const cf = M.cashFlow(month);
    const shared = M.sharedSummary();
    const accs = M.activeAccounts();
    const budgets = M.D.BUDGETS
      .map(b => ({ b, s: M.budgetStatus(b, month) }))
      .sort((a, b) => b.s.percent - a.s.percent).slice(0, 2);
    const upcoming = M.D.SUBSCRIPTIONS
      .filter(s => s.status === 'ACTIVE' && s.nextDueOn && M.daysUntil(s.nextDueOn) <= 14)
      .sort((a, b) => a.nextDueOn.localeCompare(b.nextDueOn)).slice(0, 3);
    const recent = M.ledger({}).slice(0, 5);
    const unread = M.D.NOTIFICATIONS.filter(n => !n.read).length;
    const pendingApproval = M.D.AI_APPROVALS.filter(a => a.state === 'PENDING');
    const pendingSettle = M.D.SETTLEMENTS.filter(s => s.status === 'PROPOSED' && s.toUserId === M.ME);

    let out = U.header({
      title: 'Good morning', subtitle: esc(M.D.PROFILE.displayName) + ' · ' + M.monthLabel(month),
      actions: [
        { icon: 'bell', label: 'Notifications', onClick: 'go:NOTIF-001', badge: unread > 0 },
        { html: `<button class="ico-btn" data-act="go:SET-001" aria-label="Profile">${U.avatar(M.ME, 32)}</button>` }
      ]
    });

    /* Approval banner takes precedence over the settlement banner. */
    if (pendingApproval.length) out += U.banner({
      tone: 'warning', icon: 'shield', act: 'go:AI-007',
      text: pendingApproval.length === 1
        ? `<b>${esc(pendingApproval[0].client)}</b> needs your approval`
        : `${pendingApproval.length} actions need your approval`,
      cta: 'Review'
    });
    else if (pendingSettle.length) out += U.banner({
      tone: 'shared', icon: 'settle', act: 'open-sheet:SETL-006', arg: pendingSettle[0].id,
      text: `<b>${esc(M.userName(pendingSettle[0].fromUserId))}</b> says she paid you ` +
            M.fmt(pendingSettle[0].amountMinor, pendingSettle[0].currency),
      cta: 'Review'
    });

    /* hero — the two lenses side by side.
       With nothing recorded there are no lenses to compare, so the hero
       invites the first account instead of asserting a lot of zeroes. */
    const hasMoved = cf.out > 0 || cf.in > 0 || sp.total > 0;
    const spentPct = cf.out ? Math.round(sp.total / cf.out * 100) : 0;
    const incomeSources = [...new Set(M.liveTxns()
      .filter(t => t.type === 'INCOME' && M.monthOf(t.occurredOn) === month)
      .map(t => { const c = M.category(t.categoryId); return c ? c.name : null; })
      .filter(Boolean))];
    out += `<div class="hero">
      <div class="hero-top">
        <span class="hero-label">Net worth</span>
        <button class="chip-mini" data-act="open-sheet:HOME-002">${M.monthLabel(month).split(' ')[0]}
          ${U.icon('chevron-down','pk-icon--xs')}</button>
      </div>
      ${nw.total != null
        ? `<button class="hero-amt" data-act="open-sheet:HOME-003">${M.fmt(nw.total, nw.currency)}</button>
           <div class="hero-sub">${accs.length
             ? 'Across ' + accs.length + (accs.length === 1 ? ' account · ' : ' accounts · ') + nw.currency
             : 'Add an account to see where you stand'}</div>`
        : `<button class="hero-amt" style="font-size:22px;line-height:1.3" data-act="open-sheet:HOME-003">
             ${Object.entries(nw.byCurrency).map(([c, v]) => M.fmt(v, c)).join(' · ')}</button>
           <div class="hero-sub">Can't combine — no rate for ${nw.missing.join(', ')}</div>`}
      ${hasMoved ? `<div class="hero-split">
        <div class="hs">
          <div class="hs-label">Spent
            <button class="info-btn" data-act="explain-lens" aria-label="What counts as spent">i</button></div>
          <div class="hs-val">${M.fmt(sp.total, sp.currency)}</div>
          ${U.shareRule(sp.total, Math.max(cf.out, sp.total))}
          <div class="hs-note">${cf.out
            ? spentPct + '% of ' + M.fmt(cf.out, cf.currency) + ' that left your accounts'
            : 'All of it is your share of shared expenses'}</div>
        </div>
        <div class="hs">
          <div class="hs-label">In</div>
          <div class="hs-val">${M.fmt(cf.in, cf.currency)}</div>
          <div class="hs-note" style="margin-top:12px">${incomeSources.length
            ? esc(incomeSources.slice(0, 2).join(' and '))
            : 'Nothing in yet this month'}</div>
        </div>
      </div>` : `<div class="hero-quiet">Nothing recorded in ${M.monthLabel(month)} yet.
        Tap ＋ to add your first expense.</div>`}
    </div>`;

    /* accounts rail */
    out += `<div class="sec">${U.sectionHead('Accounts', 'See all', 'tab:accounts')}
      <div class="rail" style="margin:0 -16px;padding-left:16px;padding-right:16px">
        ${accs.map(a => `<button class="acc-card" data-act="go:ACC-002" data-arg="${a.id}">
          <span class="acc-dot" style="background:${U.catColor(a.colorIdx)}"></span>
          <div class="acc-name">${esc(a.name)}</div>
          <div class="acc-bal ${M.balance(a.id) < 0 ? 'neg' : ''}">${M.fmtC(M.balance(a.id), a.currency)}</div>
        </button>`).join('')}
        <button class="acc-card is-add" data-act="open-sheet:ACC-003">${U.icon('plus','pk-icon--sm')} Add</button>
      </div></div>`;

    /* shared */
    if (M.activeSpaces().length) {
      out += `<div class="sec">${U.sectionHead('Shared', 'See all', 'tab:spaces')}
        ${U.card(`<div class="grid2" style="border-bottom:1px solid var(--pk-border-subtle)">
          <div><div class="stat-l">You're owed</div>
            <div class="stat-v money ${shared.owed ? 'pos' : 'muted'}">${M.fmt(shared.owed, shared.currency)}</div></div>
          <div><div class="stat-l">You owe</div>
            <div class="stat-v money ${shared.owe ? 'owe' : 'muted'}">${M.fmt(shared.owe, shared.currency)}</div></div>
        </div>` +
        M.activeSpaces().map(s => {
          const n = M.myBalance(s.id);
          const solo = s.members.length < 2;
          return U.row({
            lead: U.mark(s.icon, s.colorIdx),
            title: esc(s.name),
            sub: solo ? 'Just you · invite someone'
              : `${s.members.length} members · ${M.spaceSplits(s.id).length} expenses`,
            value: solo ? '' : (n ? `<span class="money ${n > 0 ? 'pos' : 'owe'}">${M.fmt(Math.abs(n), s.currency)}</span>`
                                  : '<span class="money muted">—</span>'),
            note: solo ? '' : (n > 0 ? "You're owed" : n < 0 ? 'You owe' : 'Settled'),
            act: 'go:SPACE-002', arg: s.id
          });
        }).join(''))}</div>`;
    }

    /* budgets */
    if (budgets.length) {
      out += `<div class="sec">${U.sectionHead('Budgets', 'See all', 'go:BUD-001')}
        ${U.card(budgets.map(({ b, s }) => budgetBlock(b, s)).join(''))}</div>`;
    }

    /* upcoming */
    if (upcoming.length) {
      out += `<div class="sec">${U.sectionHead('Upcoming', 'See all', 'go:SUB-001')}
        ${U.card(upcoming.map(s => U.row({
          lead: U.mark(s.icon, M.category(s.categoryId).colorIdx),
          title: esc(s.name),
          sub: M.dueLabel(s.nextDueOn) + ' · ' + esc(M.account(s.accountId).name),
          value: U.money(s.amountMinor, s.currency),
          extra: `<span style="margin-top:5px">${U.btn('Pay', 'secondary', 'open-sheet:SUB-005',
            { block: false, arg: s.id, cls: 'btn--sm' })}</span>`,
          act: 'go:SUB-002', arg: s.id
        })).join(''))}</div>`;
    }

    /* recent */
    out += `<div class="sec">${U.sectionHead('Recent', 'See all', 'tab:activity')}
      ${U.card(recent.length ? recent.map(t => U.txnRow(t)).join('')
        : U.inlineEmpty('Nothing recorded yet. Tap ＋ to add your first one.'))}</div>`;

    return out;
  };

  function budgetBlock(b, s) {
    const sp = b.spaceId ? M.space(b.spaceId) : null;
    return `<button class="bud" data-act="go:BUD-002" data-arg="${b.id}"
        style="display:block;width:100%;text-align:left;background:none;border:0;font-family:var(--pk-font-sans);cursor:pointer">
      <div class="bud-head">
        <span class="bud-name" style="color:var(--pk-text-primary)">${esc(b.name)}
          ${sp ? U.pill(sp.name, 'shared') : ''}</span>
        <span class="bud-amt money">${M.fmt(s.used, b.currency)} / ${M.fmt(s.limit, b.currency)}</span>
      </div>
      ${U.progress(s.percent, sp ? (s.state === 'OVER' ? 'over' : 'shared') : (s.state === 'OVER' ? 'over' : s.state === 'NEAR' ? 'near' : 'ok'))}
      <div class="bud-foot">
        <span class="${s.state === 'OVER' ? 'money neg' : 'money'}">${s.state === 'OVER'
          ? M.fmt(-s.remaining, b.currency) + ' over' : M.fmt(s.remaining, b.currency) + ' left'}</span>
        <span>${s.daysRemaining} days left</span>
      </div></button>`;
  }
  S._budgetBlock = budgetBlock;

  /* ══ HOME-002 · month picker ═══════════════════════════ */
  S['HOME-002'] = function (st) {
    const months = ['2026-05','2026-06','2026-07','2026-08'];
    return U.sheet({
      title: 'Select month', leftLabel: 'Cancel', size: 'auto',
      body: `<div style="padding:8px 16px 20px">
        <div style="display:grid;grid-template-columns:repeat(2,1fr);gap:8px">
          ${months.map(m => `<button class="btn ${m === st.month ? 'btn--primary' : 'btn--ghost'}"
            data-act="set-month" data-arg="${m}">${M.monthLabel(m)}</button>`).join('')}
        </div>
        <p style="font-size:12px;color:var(--pk-text-tertiary);margin:14px 0 0;text-align:center">
          Months before your first transaction aren't available.</p>
      </div>`
    });
  };

  /* ══ HOME-003 · net worth breakdown ════════════════════ */
  S['HOME-003'] = function () {
    const nw = M.netWorth();
    const accs = M.activeAccounts().slice().sort((a, b) => M.balance(b.id) - M.balance(a.id));
    const others = [...new Set(accs.map(a => a.currency))].filter(c => c !== nw.currency);
    return U.sheet({
      title: 'Net worth', size: 'mid',
      body: `<div style="padding:16px;text-align:center;border-bottom:1px solid var(--pk-border-subtle)">
          <div class="detail-amt" style="font-size:30px">${nw.total != null ? M.fmt(nw.total, nw.currency) : '—'}</div>
          <div class="detail-sub">in ${nw.currency}</div>
        </div>
        ${accs.map(a => {
          const b = M.balance(a.id);
          const conv = M.toReporting(b, a.currency);
          return U.row({
            lead: U.mark(a.icon, a.colorIdx),
            title: esc(a.name),
            sub: esc(a.type[0] + a.type.slice(1).toLowerCase()) +
              (a.currency !== nw.currency ? ' · ' + M.fmt(b, a.currency) + ' ' + a.currency : ''),
            value: conv != null ? U.money(conv, nw.currency) : '<span class="money muted">—</span>',
            act: 'go:ACC-002', arg: a.id
          });
        }).join('')}
        ${others.length ? `<div style="padding:14px 16px;border-top:1px solid var(--pk-border-subtle)">
          <div style="font-size:11.5px;color:var(--pk-text-tertiary);margin-bottom:6px">
            Converted using rates from ${M.dateLong(M.D.RATES.capturedAt)} · ${esc(M.D.RATES.source)}</div>
          ${others.map(c => `<div style="font-family:var(--pk-font-mono);font-size:11.5px;color:var(--pk-text-secondary)">
            ${c} → ${nw.currency} · ${(M.rate(c, nw.currency) || 0).toFixed(5)}</div>`).join('')}
        </div>` : ''}
        <div style="padding:12px 16px 22px;font-size:11.5px;color:var(--pk-text-tertiary)">
          Archived accounts aren't included.</div>`
    });
  };

  /* ══ ACC-001 · accounts ════════════════════════════════ */
  S['ACC-001'] = function (st) {
    const accs = M.activeAccounts();
    const arch = M.archivedAccounts();
    const nw = M.netWorth();
    if (!accs.length) return U.header({ title: 'Accounts' }) + U.empty({
      icon: 'wallet', title: 'No accounts yet',
      body: 'Add a bank account, cash, or a card to start tracking your money.',
      ctaLabel: 'Add account', ctaVariant: 'primary', ctaAct: 'open-sheet:ACC-003'
    });
    if (st.reorder) return S['ACC-005'](st);

    let out = U.header({
      title: 'Accounts', subtitle: 'Cash flow — what is actually there',
      actions: [
        { icon: 'plus', label: 'Add account', onClick: 'open-sheet:ACC-003' },
        { icon: 'more', label: 'More', onClick: 'menu:accounts' }
      ]
    });
    if (accs.length > 1) out += `<div class="hero" style="padding:18px 20px">
      <div class="hero-label">Total</div>
      <div class="hero-amt" style="font-size:32px;line-height:36px">${nw.total != null ? M.fmt(nw.total, nw.currency) : '—'}</div>
      <div class="hero-sub">${nw.total != null ? 'Across ' + accs.length + ' accounts' :
        "Can't combine — no rate for " + nw.missing.join(', ')}</div></div>`;

    out += `<div class="sec">${U.card(accs.map(a => U.row({
      lead: U.mark(a.icon, a.colorIdx, 44),
      title: esc(a.name),
      sub: esc(a.type[0] + a.type.slice(1).toLowerCase()) + ' · ' + a.currency + (a.isDefault ? ' · Default' : ''),
      value: `<span class="money ${M.balance(a.id) < 0 ? 'neg' : ''}">${M.fmt(M.balance(a.id), a.currency)}</span>`,
      act: 'go:ACC-002', arg: a.id, chevron: true
    })).join(''))}</div>`;

    if (arch.length) out += `<div class="sec">${U.card(U.row({
      title: `Archived (${arch.length})`, act: 'go:ACC-006', chevron: true
    }))}</div>`;
    out += U.note('Balances are derived from transactions, never stored. A shared expense you paid counts here in full — the part others owe you is a claim, not cash.', 'plain');
    return out;
  };

  /* ══ ACC-005 · reorder mode ════════════════════════════ */
  S['ACC-005'] = function () {
    const accs = M.activeAccounts();
    return U.header({ title: 'Reorder', actions: [
      { html: U.btn('Done', 'tertiary', 'reorder-done', { block: false }) }] })
      + `<div class="sec">${U.card(accs.map((a, i) => `<div class="row" style="cursor:default">
        ${U.mark(a.icon, a.colorIdx)}
        <span class="row-body"><span class="row-title">${esc(a.name)}</span>
          <span class="row-sub">${esc(a.type)}</span></span>
        <span class="row-end" style="flex-direction:row;gap:4px">
          <button class="ico-btn" data-act="move-acc-up" data-arg="${a.id}" ${i === 0 ? 'disabled' : ''}
            aria-label="Move up" style="width:32px;height:32px">${U.icon('chevron-down','pk-icon--sm')}</button>
          <button class="ico-btn" data-act="move-acc-down" data-arg="${a.id}" ${i === accs.length - 1 ? 'disabled' : ''}
            aria-label="Move down" style="width:32px;height:32px;transform:rotate(180deg)">${U.icon('chevron-down','pk-icon--sm')}</button>
        </span></div>`).join(''))}</div>`;
  };

  /* ══ ACC-006 · archived accounts ═══════════════════════ */
  S['ACC-006'] = function () {
    const arch = M.archivedAccounts();
    return U.header({ title: 'Archived accounts', back: 'back' })
      + `<div class="strip" style="padding-top:0">Archived accounts are hidden from lists and totals. Their history is kept.</div>`
      + `<div class="sec">${U.card(arch.map(a => U.row({
          lead: U.mark(a.icon, a.colorIdx, 44),
          title: esc(a.name), sub: esc(a.type) + ' · ' + a.currency + ' ' + U.pill('Archived', 'neutral'),
          value: `<span class="money muted">${M.fmt(M.balance(a.id), a.currency)}</span>`,
          extra: U.btn('Restore', 'tertiary', 'restore-account', { block: false, arg: a.id, cls: 'btn--sm' }),
          act: 'go:ACC-002', arg: a.id
        })).join(''))}</div>`;
  };

  /* ══ ACC-002 · account detail ══════════════════════════ */
  S['ACC-002'] = function (st) {
    const a = M.account(st.ctx.id);
    if (!a) return U.errorState('This account no longer exists', 'back');
    const bal = M.balance(a.id);
    const mm = M.accountMonth(a.id, st.month);
    const rows = M.ledger({ accountId: a.id }).slice(0, 40);

    let out = U.header({
      title: esc(a.name), back: 'back',
      actions: [{ icon: 'more', label: 'More', onClick: 'menu:account', }]
    });
    if (a.archived) out += U.banner({ tone: 'neutral', icon: 'info',
      text: 'This account is archived. It\'s read-only.' });

    out += `<div class="detail-top">
      ${U.mark(a.icon, a.colorIdx, 56)}
      <div class="detail-title">${esc(a.name)}</div>
      <div class="detail-amt ${bal < 0 ? 'money neg' : 'money'}" style="margin-top:6px">${M.fmt(bal, a.currency)}</div>
      <div class="detail-sub">${esc(a.type[0] + a.type.slice(1).toLowerCase())} · ${a.currency}
        ${a.isDefault ? U.pill('Default', 'neutral') : ''}</div>
    </div>`;

    out += `<div class="sec">${U.card(`<div class="grid2">
      <div><div class="stat-l">Out</div><div class="stat-v money">${M.fmt(mm.out, a.currency)}</div></div>
      <div><div class="stat-l">In</div><div class="stat-v money pos">${M.fmt(mm.in, a.currency)}</div></div>
    </div><div style="padding:0 14px 12px;font-size:12px;color:var(--pk-text-tertiary)"
      class="money">Net ${M.fmt(mm.in - mm.out, a.currency)} in ${M.monthLabel(st.month)}</div>`)}</div>`;

    out += `<div class="sec">${U.sectionHead('Transactions')}
      ${U.card(rows.length ? rows.map(t => U.txnRow(t)).join('')
        : U.inlineEmpty('No transactions yet. Money in and out of this account will show up here.',
            'Add transaction', 'open-add|' + a.id))}
      ${rows.length >= 40 ? U.btn('View all transactions', 'tertiary', 'view-all-account', { arg: a.id }) : ''}</div>`;
    return out;
  };

  /* ══ TXN-001 · activity ════════════════════════════════ */
  S['TXN-001'] = function (st) {
    if (st.search != null) return S['TXN-006'](st);
    const f = Object.assign({}, st.filters);
    const rows = M.ledger(f);
    const nFilters = countFilters(f);
    let out = U.header({
      title: 'Activity', subtitle: 'Every money event',
      actions: [
        { icon: 'search', label: 'Search', onClick: 'open-search' },
        { html: `<button class="ico-btn" data-act="open-sheet:TXN-005" aria-label="Filters"
            style="position:relative">${U.icon('filter')}
            ${nFilters ? `<span class="filter-badge">${nFilters}</span>` : ''}</button>` }
      ]
    });
    if (nFilters) out += filterChips(f);

    const totals = rows.reduce((acc, t) => {
      const v = M.toReporting(t.amountMinor, t.currency) || 0;
      if (t.type === 'EXPENSE') acc.out += v;
      if (t.type === 'INCOME') acc.in += v;
      if (t.type === 'SETTLEMENT') { if (t.fromAccountId) acc.out += v; else acc.in += v; }
      return acc;
    }, { out: 0, in: 0 });

    out += `<div class="sec">${U.card(`<div class="grid2">
      <div><div class="stat-l">Out</div><div class="stat-v money">${M.fmt(totals.out, 'EUR')}</div></div>
      <div><div class="stat-l">In</div><div class="stat-v money pos">${M.fmt(totals.in, 'EUR')}</div></div>
    </div>`)}</div>`;

    if (!rows.length) {
      out += nFilters
        ? U.empty({ icon: 'filter', title: 'No matching transactions',
            body: 'Try removing a filter.', ctaLabel: 'Clear all filters', ctaAct: 'clear-filters' })
        : U.empty({ icon: 'receipt', title: 'No transactions yet',
            body: 'Everything you record — expenses, income, transfers — shows up here.',
            ctaLabel: 'Add transaction', ctaVariant: 'primary', ctaAct: 'open-add' });
      return out;
    }
    M.groupByDate(rows).forEach(g => {
      const dayNet = g.rows.reduce((a, t) => a + (t.type === 'INCOME' ? 1 : -1) *
        (M.toReporting(t.amountMinor, t.currency) || 0), 0);
      out += `<div class="grp-head"><span>${M.dateLabel(g.date)}</span>
        <span class="money">${M.fmt(dayNet, 'EUR')}</span></div>
        <div class="sec" style="margin-bottom:8px">${U.card(g.rows.map(t => U.txnRow(t, { showDate: false })).join(''))}</div>`;
    });
    return out;
  };

  function countFilters(f) {
    let n = 0;
    if (f.month) n++;
    if (f.accountId) n++;
    if (f.types && f.types.length) n++;
    if (f.categoryIds && f.categoryIds.length) n++;
    if (f.spaceIds && f.spaceIds.length) n++;
    if (f.sources && f.sources.length) n++;
    return n;
  }
  S._countFilters = countFilters;

  function filterChips(f) {
    const bits = [];
    if (f.month) bits.push({ k: 'month', label: M.monthLabel(f.month) });
    if (f.accountId) bits.push({ k: 'accountId', label: M.account(f.accountId).name });
    (f.types || []).forEach(t => bits.push({ k: 'types:' + t, label: t[0] + t.slice(1).toLowerCase() }));
    (f.categoryIds || []).forEach(c => bits.push({ k: 'categoryIds:' + c, label: M.category(c).name }));
    (f.spaceIds || []).forEach(s => bits.push({ k: 'spaceIds:' + s,
      label: s === '__personal' ? 'Personal only' : M.space(s).name }));
    (f.sources || []).forEach(s => bits.push({ k: 'sources:' + s, label: s === 'mcp' ? 'Added by AI' : 'Added in app' }));
    return `<div class="fchips">${bits.map(b =>
      `<button class="fchip" data-act="drop-filter" data-arg="${b.k}">${esc(b.label)}
        ${U.icon('close','pk-icon--xs')}</button>`).join('')}
      ${bits.length > 1 ? `<button class="fchip" style="background:var(--pk-bg-sunken);color:var(--pk-text-secondary)"
        data-act="clear-filters">Clear all</button>` : ''}</div>`;
  }

  /* ══ TXN-006 · search ══════════════════════════════════ */
  S['TXN-006'] = function (st) {
    const q = st.search || '';
    const rows = q.length >= 2 ? M.ledger(Object.assign({}, st.filters, { q })) : [];
    let out = `<div class="search-wrap">
      <button class="ico-btn" data-act="close-search" aria-label="Back">${U.icon('arrow-left')}</button>
      <input class="search-inp" id="searchInput" placeholder="Search transactions" value="${esc(q)}"
        data-live="search" autocomplete="off">
    </div>`;
    if (q.length < 2) {
      const recents = st.recentSearches || [];
      out += recents.length
        ? `<div class="sec"><div class="stat-l" style="margin-bottom:8px">Recent searches</div>
           <div class="chips" style="padding-left:0;padding-right:0">${recents.map(r =>
             `<button class="chip" data-act="run-search" data-arg="${esc(r)}">${esc(r)}</button>`).join('')}</div></div>`
        : `<div class="empty"><p>Search by merchant, note, category, or amount.</p></div>`;
      return out;
    }
    if (!rows.length) return out + U.empty({ icon: 'search',
      title: `No transactions match "${esc(q)}"`,
      body: 'Check the spelling, or search for a category or amount.',
      ctaLabel: 'Clear search', ctaAct: 'close-search' });
    M.groupByDate(rows).forEach(g => {
      out += `<div class="grp-head"><span>${M.dateLabel(g.date)}</span></div>
        <div class="sec" style="margin-bottom:8px">${U.card(g.rows.map(t => U.txnRow(t, { showDate: false })).join(''))}</div>`;
    });
    return out;
  };

  /* ══ TXN-002 · transaction detail ══════════════════════ */
  S['TXN-002'] = function (st) {
    const t = M.txn(st.ctx.id);
    if (!t || t.deleted) return U.header({ title: 'Transaction', back: 'back' })
      + U.empty({ icon: 'warning', title: 'This transaction no longer exists',
        body: 'It may have been deleted.', ctaLabel: 'Go back', ctaAct: 'back' });
    const c = M.category(t.categoryId);
    const share = M.myShareOf(t);
    const sp = share && M.space(share.split.spaceId);
    const settled = share && share.split.status === 'SETTLED';

    let out = U.header({ title: 'Transaction', back: 'back', actions: [
      ...(t.type === 'SETTLEMENT' ? [] : [{ html: U.btn('Edit', 'tertiary', settled ? 'dlg:DLG-016' : 'open-sheet:TXN-004', { block: false, arg: t.id }) }]),
      { icon: 'more', label: 'More', onClick: 'menu:txn' }
    ] });

    out += `<div class="detail-top">
      ${t.type === 'TRANSFER' ? U.mark('transfer', 10, 56)
        : t.type === 'SETTLEMENT' ? U.mark('settle', 1, 56)
        : U.mark(c ? c.icon : 'receipt', c ? c.colorIdx : 10, 56)}
      <div class="detail-amt ${t.type === 'INCOME' ? 'money pos' : 'money'}" style="margin-top:12px">
        ${M.txnSign(t)}${M.fmt(t.amountMinor, t.currency).replace('−', '')}</div>
      <div class="detail-title">${esc(M.txnTitle(t))}</div>
      <div class="detail-sub">${M.dateLong(t.occurredOn)}</div>
      ${settled ? '<div style="margin-top:8px">' + U.pill('Settled', 'success') + '</div>' : ''}
    </div>`;

    const kv = [];
    kv.push(['Type', t.type[0] + t.type.slice(1).toLowerCase()]);
    const accLink = id => {
      const a = M.account(id);
      /* The account can be deleted while its transactions live on. */
      return a ? `<button class="link" data-act="go:ACC-002" data-arg="${id}">${esc(a.name)}</button>`
               : '<span class="kv-gone">Deleted account</span>';
    };
    if (t.fromAccountId) kv.push([t.type === 'TRANSFER' ? 'From' : 'Account', accLink(t.fromAccountId)]);
    if (t.toAccountId) kv.push([t.type === 'TRANSFER' ? 'To' : 'Account', accLink(t.toAccountId)]);
    if (t.sourceCurrency) kv.push(['Exchange rate',
      `<span class="money">1 ${t.sourceCurrency} = ${(t.exchangeRate || 0).toFixed(5)} ${t.currency}</span>`]);
    if (t.sourceAmountMinor) kv.push(['Original amount', `<span class="money">${M.fmt(t.sourceAmountMinor, t.sourceCurrency)}</span>`]);
    if (c) kv.push(['Category', `<button class="link" data-act="filter-category" data-arg="${c.id}">${esc(c.name)}</button>`]);
    if (t.subscriptionId) { const sub = M.sub(t.subscriptionId);
      kv.push(['Subscription', sub
        ? `<button class="link" data-act="go:SUB-002" data-arg="${t.subscriptionId}">${esc(sub.name)}</button>`
        : '<span class="kv-gone">Deleted subscription</span>']); }
    if (t.note) kv.push(['Note', esc(t.note)]);
    out += `<div class="sec">${U.card(kv.map(([k, v]) =>
      `<div class="kv"><span class="kv-k">${k}</span><span class="kv-v">${v}</span></div>`).join(''))}</div>`;

    if (share && sp) {
      const others = share.split.shares.filter(x => x.userId !== M.ME);
      const owed = others.reduce((a, x) => a + x.amountMinor, 0);
      out += `<div class="sec">${U.sectionHead('Shared with ' + esc(sp.name), 'Open space', 'go:SPACE-002|' + sp.id)}
        ${U.card(`<div style="padding:14px">
          <div style="display:flex;justify-content:space-between;align-items:baseline">
            <span class="stat-l" style="margin:0">Total</span>
            <span class="money" style="font-size:16px;font-weight:600">${M.fmt(share.split.totalMinor, share.currency)}</span></div>
          <div style="margin-top:10px">${U.shareRule(share.amountMinor, share.split.totalMinor)}</div>
          <div style="display:flex;justify-content:space-between;font-size:11.5px;color:var(--pk-text-tertiary);margin-top:7px">
            <span class="money">Your share ${M.fmt(share.amountMinor, share.currency)}</span>
            <span class="money">${share.split.payerUserId === M.ME ? 'Owed to you ' : 'You owe '}${M.fmt(owed, share.currency)}</span></div>
        </div>` + share.split.shares.map(x => U.row({
          lead: U.avatar(x.userId, 32),
          title: esc(M.userName(x.userId)) + (x.userId === share.split.payerUserId ? ' ' + U.pill('paid', 'shared') : ''),
          value: U.money(x.amountMinor, share.currency)
        })).join('') +
        `<div class="kv" style="border-top:1px solid var(--pk-border-subtle)">
          <span class="kv-k">Split</span><span class="kv-v">${methodLabel(share.split)}</span></div>` +
        U.row({ title: 'View in space', act: 'go:SPACE-010', arg: share.split.id, chevron: true }))}</div>`;

      const otherNames = others.map(x => M.userName(x.userId));
      out += U.note(share.split.payerUserId === M.ME
        ? `You paid ${M.fmt(t.amountMinor, t.currency)}${t.sourceCurrency ? ' (' + M.fmt(share.split.totalMinor, share.currency) + ')' : ''} from ${esc(M.account(t.fromAccountId).name)}. Your share of the spending is ${M.fmt(share.amountMinor, share.currency)} — the rest is what ${otherNames.join(' and ')} ${others.length > 1 ? 'owe' : 'owes'} you.`
        : `${esc(M.userName(share.split.payerUserId))} paid. Your share is ${M.fmt(share.amountMinor, share.currency)}.`);
    }
    if (t.type === 'SETTLEMENT') out += U.note('Settlements move money between people. They don\'t count as spending — your share was counted when the expense was recorded.');

    out += `<div class="meta">Added by ${t.source === 'mcp' ? '' : 'you'}
      ${t.source === 'mcp' ? `<button class="link" data-act="go:AI-004" data-arg="con_gpt"
        style="font-size:11.5px">${U.icon('sparkle','pk-icon--xs')} ${esc(t.client || 'AI')}</button>` : ''}
      · ${M.dateLabel(t.occurredOn)}</div>`;
    return out;
  };

  function methodLabel(s) {
    if (s.method === 'EQUAL') return 'Equally';
    if (s.method === 'EXACT') return 'Exact amounts';
    /* Member order comes from the space; without it, fall back to the shares
       already recorded on the split itself. */
    const sp = M.space(s.spaceId);
    const ids = sp ? sp.members.map(m => m.userId) : s.shares.map(x => x.userId);
    return ids.map(id => {
      const sh = s.shares.find(x => x.userId === id);
      return sh && s.totalMinor ? Math.round(sh.amountMinor / s.totalMinor * 100) : 0;
    }).join('/');
  }
  S._methodLabel = methodLabel;

  /* ══ TXN-005 · filters ═════════════════════════════════ */
  S['TXN-005'] = function (st) {
    const d = st.filterDraft;
    const chip = (label, on, act, arg) =>
      `<button class="chip" aria-pressed="${on}" data-act="${act}" data-arg="${esc(arg)}">${esc(label)}</button>`;
    const count = M.ledger(d).length;
    return U.sheet({
      title: 'Filters', leftLabel: 'Cancel', size: 'tall',
      body: `
        <div class="sec" style="margin-top:14px"><div class="stat-l">Type</div>
          <div class="chips" style="padding-left:0;padding-right:0">
            ${chip('All', !(d.types || []).length, 'f-type', '')}
            ${['EXPENSE','INCOME','TRANSFER','SETTLEMENT'].map(t =>
              chip(t[0] + t.slice(1).toLowerCase(), (d.types || []).includes(t), 'f-type', t)).join('')}
          </div></div>
        <div class="sec"><div class="stat-l">Period</div>
          <div class="chips" style="padding-left:0;padding-right:0">
            ${chip('All time', !d.month, 'f-month', '')}
            ${['2026-08','2026-07','2026-06'].map(m => chip(M.monthLabel(m), d.month === m, 'f-month', m)).join('')}
          </div></div>
        <div class="sec"><div class="stat-l">Accounts</div>
          <div class="chips" style="padding-left:0;padding-right:0">
            ${chip('All', !d.accountId, 'f-acc', '')}
            ${M.activeAccounts().map(a => chip(a.name, d.accountId === a.id, 'f-acc', a.id)).join('')}
          </div></div>
        <div class="sec"><div class="stat-l">Spaces</div>
          <div class="chips" style="padding-left:0;padding-right:0">
            ${chip('All', !(d.spaceIds || []).length, 'f-space', '')}
            ${chip('Personal only', (d.spaceIds || []).includes('__personal'), 'f-space', '__personal')}
            ${M.activeSpaces().map(s => chip(s.name, (d.spaceIds || []).includes(s.id), 'f-space', s.id)).join('')}
          </div></div>
        <div class="sec"><div class="stat-l">Categories</div>
          <div class="chips" style="padding-left:0;padding-right:0;flex-wrap:wrap;overflow:visible">
            ${chip('All', !(d.categoryIds || []).length, 'f-cat', '')}
            ${M.D.CATEGORIES.filter(c => c.type === 'EXPENSE').map(c =>
              chip(c.name, (d.categoryIds || []).includes(c.id), 'f-cat', c.id)).join('')}
          </div></div>
        <div class="sec" style="margin-bottom:28px"><div class="stat-l">Added by</div>
          <div class="chips" style="padding-left:0;padding-right:0">
            ${chip('Anyone', !(d.sources || []).length, 'f-src', '')}
            ${chip('Me in the app', (d.sources || []).includes('mobile'), 'f-src', 'mobile')}
            ${chip('An AI assistant', (d.sources || []).includes('mcp'), 'f-src', 'mcp')}
          </div></div>`,
      footer: `<div style="display:flex;gap:10px;align-items:center">
        ${U.btn('Clear all', 'tertiary', 'filters-clear', { block: false })}
        <div style="flex:1"></div>
        ${U.btn(`Apply · ${count} result${count === 1 ? '' : 's'}`, 'primary', 'filters-apply', { block: false })}
      </div>`
    });
  };

  /* ══ TXN-003 / TXN-004 · add & edit money event ════════ */
  S['TXN-003'] = function (st) {
    const d = st.draft;
    const editing = !!d.editId;
    const isExp = d.type === 'EXPENSE', isInc = d.type === 'INCOME', isTr = d.type === 'TRANSFER';
    const sp = d.share && d.spaceId ? M.space(d.spaceId) : null;
    const acc = M.account(isInc ? d.toAccountId : d.fromAccountId);
    const entryCur = sp ? sp.currency : (acc ? acc.currency : 'EUR');
    const shares = d.share && sp ? M.computeShares(d.amount, d.method,
      sp.members.map(m => m.userId), d.splitValues, d.payerUserId) : [];
    const shareSum = shares.reduce((a, x) => a + x.amountMinor, 0);
    const splitOk = !d.share || (d.amount > 0 && shareSum === d.amount && shares.length > 0);
    const mine = shares.find(x => x.userId === M.ME);
    const crossCur = sp && acc && acc.currency !== sp.currency;
    const rateOk = !crossCur || M.rate(sp.currency, acc.currency) != null;
    /* An account is required to save, and it has to still exist — it can be
       deleted from another screen while this sheet is open. */
    const accOk = !!acc && (!isTr || (!!M.account(d.toAccountId) && d.fromAccountId !== d.toAccountId));
    const canSave = d.amount > 0 && splitOk && rateOk && accOk;

    let body = `<div class="seg" style="margin-top:12px">
      ${['EXPENSE','INCOME','TRANSFER'].map(t =>
        `<button aria-pressed="${d.type === t}" data-act="draft-type" data-arg="${t}"
          ${editing ? 'disabled' : ''}>${t[0] + t.slice(1).toLowerCase()}</button>`).join('')}
    </div>`;

    body += `<div class="amount">
      <div class="amount-val ${d.amount ? '' : 'is-zero'}">${M.fmt(d.amount, entryCur)}</div>
      <div class="amount-cur">${entryCur}${sp ? ' · ' + esc(sp.name) : ''}</div>
      ${crossCur && rateOk ? `<div class="amount-conv">≈ ${M.fmt(M.convert(d.amount, sp.currency, acc.currency), acc.currency)} from ${esc(acc.name)}</div>` : ''}
    </div>`;

    /* fields */
    let fields = '';
    fields += U.field({ icon: 'wallet', label: isInc ? 'To account' : isTr ? 'From' : 'Account',
      value: acc ? esc(acc.name) + ' · <span class="money">' + M.fmt(M.balance(acc.id), acc.currency) + '</span>' : 'Select account',
      placeholder: !acc, act: 'open-picker:account', arg: isInc ? 'toAccountId' : 'fromAccountId' });
    if (isTr) fields += U.field({ icon: 'transfer', label: 'To account',
      value: d.toAccountId ? esc(M.account(d.toAccountId).name) : 'Select account',
      placeholder: !d.toAccountId, act: 'open-picker:account', arg: 'toAccountId' });
    if (!isTr) {
      const c = M.category(d.categoryId);
      fields += U.field({ icon: c ? c.icon : 'receipt', label: 'Category',
        value: c ? esc(c.name) : 'None — won\'t count toward a budget',
        placeholder: !c, act: 'open-picker:category' });
    }
    fields += U.field({ icon: 'calendar', label: 'Date',
      value: M.dateLabel(d.occurredOn), act: 'open-picker:date' });
    fields += U.field({ icon: 'edit', label: 'Note',
      value: d.merchant ? esc(d.merchant) : 'Add a note', placeholder: !d.merchant, act: 'edit-note' });
    if (isExp) fields += U.toggleRow({ icon: 'transfer', label: 'Share this expense',
      on: !!d.share, act: 'toggle-share',
      hint: M.activeSpaces().length ? '' : 'Create a space first to split expenses' });
    body += U.card(fields, 'card--flush');

    /* recent category chips */
    if (!isTr) {
      const recents = M.D.CATEGORIES.filter(c => c.type === (isInc ? 'INCOME' : 'EXPENSE')).slice(0, 5);
      body += `<div class="chips">${recents.map(c =>
        `<button class="chip" aria-pressed="${d.categoryId === c.id}" data-act="draft-cat" data-arg="${c.id}">
          ${esc(c.name)}</button>`).join('')}
        <button class="chip" data-act="open-picker:category">More</button></div>`;
    }

    /* share block */
    if (d.share && isExp) {
      if (!M.activeSpaces().length) {
        body += U.banner({ tone: 'info', icon: 'info', text: 'Create a space to split expenses.',
          cta: 'Create space', act: 'open-sheet:SPACE-005' });
      } else {
        let sb = `<div class="chips">${M.activeSpaces().map(s =>
          `<button class="chip" aria-pressed="${d.spaceId === s.id}" data-act="draft-space" data-arg="${s.id}">
            ${esc(s.name)}</button>`).join('')}</div>`;
        if (sp && sp.members.length > 1) sb += U.field({ icon: 'person', label: 'Paid by',
          value: esc(M.userName(d.payerUserId)), act: 'open-picker:payer' });
        if (sp && sp.members.length < 2) sb += U.banner({ tone: 'info', icon: 'info',
          text: `You're the only member of ${esc(sp.name)}. Invite someone to split expenses.`,
          cta: 'Invite', act: 'open-sheet:SPACE-008' });
        if (crossCur) sb += `<div class="conv-row">
          ${U.icon('currency','pk-icon--sm')}
          <div style="flex:1">${rateOk
            ? `${M.fmt(d.amount, sp.currency)} · about <b>${M.fmt(M.convert(d.amount, sp.currency, acc.currency), acc.currency)}</b> will leave ${esc(acc.name)}
               <div class="conv-rate">${sp.currency} → ${acc.currency} · ${(M.rate(sp.currency, acc.currency) || 0).toFixed(5)}</div>`
            : `<span style="color:var(--pk-danger)">No rate for ${sp.currency} → ${acc.currency} today.</span>`}</div>
        </div>`;
        if (sp) sb += `<button class="split-summary" data-act="open-sheet:SPLIT-001">
          <span class="split-summary-t">
            <span>${splitLabel(d, sp)}</span>${U.icon('chevron-right','pk-icon--sm chev')}</span>
          <span class="split-summary-s">${d.amount
            ? (splitOk ? shares.map(x => esc(M.userName(x.userId)) + ' ' + M.fmt(x.amountMinor, sp.currency)).join(' · ')
                       : `<span style="color:var(--pk-danger)">Doesn't add up · ${M.fmt(Math.abs(d.amount - shareSum), sp.currency)} ${d.amount > shareSum ? 'unassigned' : 'over'}</span>`)
            : 'Enter an amount'}</span>
          ${d.amount && splitOk && mine ? '<span style="display:block;margin-top:9px">' + U.shareRule(mine.amountMinor, d.amount) + '</span>' : ''}
        </button>`;
        body += `<div class="share-block">${sb}</div>`;
      }
    }

    /* Amounts are entered minor-unit first, so there is no decimal point to
       type — the slot goes to "00", which is the key that actually saves taps. */
    const keys = ['1','2','3','4','5','6','7','8','9','00','0','⌫'];
    const keypad = `<div class="keypad" role="group" aria-label="Amount keypad">${keys.map(k =>
      `<button data-act="key" data-arg="${k}" aria-label="${k === '⌫' ? 'Delete' : k}">
        ${k === '⌫' ? U.icon('arrow-left','pk-icon--sm') : k}</button>`).join('')}</div>`;

    const label = !accOk ? (isTr && acc ? 'Pick two different accounts' : 'Pick an account')
      : !splitOk ? "Split doesn't add up"
      : !rateOk ? 'Needs an exchange rate'
      : d.share && isExp ? 'Save shared expense'
      : 'Save ' + d.type.toLowerCase();

    return U.sheet({
      title: editing ? 'Edit ' + d.type.toLowerCase() : (d.share && isExp ? 'New shared expense' : 'New ' + d.type.toLowerCase()),
      body: body, size: 'form',
      footer: keypad + '<div style="height:12px"></div>' +
        U.btn(label, 'primary', editing ? 'save-edit' : 'save-draft', { disabled: !canSave })
    });
  };
  S['TXN-004'] = S['TXN-003'];

  /* ══ NOTE-EDIT · the note behind a money event ═════════ */
  /* Its own sheet rather than a native prompt(): prompt() is unavailable in
     embedded webviews, can't be themed, and gives no length feedback. */
  S['NOTE-EDIT'] = function (st) {
    const MAXN = 120;
    const v = st.noteDraft || '';
    return U.sheet({
      title: 'Note', size: 'auto', leftLabel: 'Cancel', leftAct: 'note-cancel',
      rightLabel: 'Done', rightAct: 'note-save',
      body: `<div class="sec" style="margin-top:16px">
        <textarea class="inp inp--area" data-live="note" maxlength="${MAXN}" rows="3" autofocus
          placeholder="What was this for?"
          aria-describedby="noteCount">${esc(v)}</textarea>
        <div class="note-meta">
          <span class="field-hint">The first line becomes the title on the row.</span>
          <span id="noteCount" class="field-hint">${MAXN - v.length} left</span>
        </div>
        ${U.btn('Clear note', 'tertiary', 'note-clear', { block: false, disabled: !v })}
      </div>` });
  };

  function splitLabel(d, sp) {
    if (d.method === 'EQUAL') return 'Split equally';
    if (d.method === 'EXACT') return 'Exact amounts';
    return 'Split ' + sp.members.map(m => d.splitValues.percent[m.userId] || 0).join('/');
  }

  /* ══ SPLIT-001 · split editor ══════════════════════════ */
  S['SPLIT-001'] = function (st) {
    const d = st.draft, sp = M.space(d.spaceId);
    const ids = sp.members.map(m => m.userId);
    const shares = M.computeShares(d.amount, d.method, ids, d.splitValues, d.payerUserId);
    const sum = shares.reduce((a, x) => a + x.amountMinor, 0);
    const pctSum = ids.filter(i => d.splitValues.included[i])
      .reduce((a, i) => a + (+d.splitValues.percent[i] || 0), 0);
    const balanced = d.method === 'PERCENTAGE' ? pctSum === 100 : sum === d.amount;
    const rounding = M.roundingFor(d.amount, d.method, shares.length);

    const body = `
      <div class="total-row"><span>Total</span><span class="money">${M.fmt(d.amount, sp.currency)}</span></div>
      <div class="seg">
        ${[['EQUAL','Equally'],['EXACT','Exact'],['PERCENTAGE','Percent']].map(([k, l]) =>
          `<button aria-pressed="${d.method === k}" data-act="split-method" data-arg="${k}"
            ${sp.members.length < 2 ? 'disabled' : ''}>${l}</button>`).join('')}
      </div>
      ${sp.members.map(m => {
        const on = !!d.splitValues.included[m.userId];
        const sh = shares.find(x => x.userId === m.userId);
        const amt = sh ? sh.amountMinor : 0;
        const isPayer = m.userId === d.payerUserId;
        let sub = '';
        if (d.method === 'EQUAL') sub = `1 of ${shares.length}` +
          (isPayer && rounding ? ` · +${M.fmt(rounding, sp.currency)} rounding` : '');
        else if (d.method === 'PERCENTAGE') sub = M.fmt(amt, sp.currency);
        else sub = 'Exact amount';
        let control;
        if (!on) control = '<span class="money muted">—</span>';
        else if (d.method === 'EXACT') control =
          `<input class="minp" type="number" value="${(d.splitValues.exact[m.userId] || 0) / Math.pow(10, M.cur(sp.currency).decimals)}"
             data-live="split-exact" data-arg="${m.userId}" step="any">`;
        else if (d.method === 'PERCENTAGE') control =
          `<input class="minp" style="width:72px" type="number" value="${d.splitValues.percent[m.userId] || 0}"
             data-live="split-pct" data-arg="${m.userId}">`;
        else control = `<span class="money" style="font-weight:600">${M.fmt(amt, sp.currency)}</span>`;
        return `<div class="mrow ${on ? '' : 'is-off'}">
          <button class="cbx ${on ? 'is-on' : ''}" data-act="split-toggle" data-arg="${m.userId}"
            aria-label="Include ${esc(M.userName(m.userId))}">${on ? U.icon('check','pk-icon--xs') : ''}</button>
          ${U.avatar(m.userId, 32)}
          <span class="row-body"><span class="row-title" style="font-size:14px">${esc(M.userName(m.userId))}
            ${isPayer ? U.pill('paid', 'shared') : ''}</span>
            <span class="row-sub">${sub}</span></span>
          ${control}</div>`;
      }).join('')}
      <div style="padding:14px 16px;display:flex;gap:8px;flex-wrap:wrap">
        ${sp.defaultSplit.method !== 'NONE' ? U.btn('Reset to ' + esc(sp.name) + ' default', 'ghost', 'split-reset', { block: false, cls: 'btn--sm' }) : ''}
        ${U.btn('Just mine', 'ghost', 'split-mine', { block: false, cls: 'btn--sm' })}
      </div>`;

    const remainderText = balanced
      ? U.icon('check', 'pk-icon--xs') + ' ' + (d.method === 'PERCENTAGE' ? '100% assigned' : M.fmt(d.amount, sp.currency) + ' assigned')
      : d.method === 'PERCENTAGE'
        ? (pctSum < 100 ? (100 - pctSum) + '% left to assign' : (pctSum - 100) + '% over')
        : (sum < d.amount ? M.fmt(d.amount - sum, sp.currency) + ' left to assign' : M.fmt(sum - d.amount, sp.currency) + ' over');

    const segs = balanced && d.amount ? U.shareRuleSegmented(shares, d.amount)
      : `<span class="track"><span class="fill fill--over" style="width:${Math.min(100, sum / (d.amount || 1) * 100)}%"></span></span>`;

    return U.sheet({
      title: 'Split', leftLabel: 'Cancel', rightLabel: 'Done', rightAct: 'split-done',
      rightDisabled: !balanced, size: 'tall', body,
      footer: `<div class="remainder ${balanced ? 'is-ok' : 'is-bad'}" style="border:0;padding:0">
        <div class="remainder-t"><span>${remainderText}</span>
          ${!balanced && d.method === 'EXACT' && sum < d.amount
            ? '<button class="link" data-act="split-rest">Split the rest</button>' : ''}</div>
        ${segs}</div>`
    });
  };

  /* ══ PICK-001..007 · reusable pickers ══════════════════ */
  S['PICK-001'] = function (st) {   /* account */
    const p = st.picker;
    const list = M.activeAccounts().filter(a => !p.exclude || a.id !== p.exclude);
    return U.sheet({ title: 'Select account', leftLabel: 'Cancel', size: 'mid',
      body: U.pickerList(list.map(a => ({
        lead: U.mark(a.icon, a.colorIdx), title: esc(a.name),
        sub: esc(a.type[0] + a.type.slice(1).toLowerCase()) + ' · ' + a.currency,
        value: U.money(M.balance(a.id), a.currency),
        selected: p.value === a.id, act: 'pick', arg: a.id
      })))
      + (p.allowUntracked ? U.row({
          lead: U.mark('cash', 10), title: "Cash — don't track",
          sub: 'Splits the expense without changing any account balance',
          act: 'pick', arg: 'UNTRACKED'
        }) : '')
      + U.row({ lead: U.mark('plus', 2), title: 'New account', act: 'open-sheet:ACC-003' })
    });
  };
  S['PICK-002'] = function (st) {   /* category */
    const p = st.picker;
    const type = p.categoryType || 'EXPENSE';
    const list = M.D.CATEGORIES.filter(c => c.type === type);
    return U.sheet({ title: 'Select category', leftLabel: 'Cancel', size: 'mid',
      body: U.pickerList(list.map(c => ({
        lead: U.mark(c.icon, c.colorIdx), title: esc(c.name),
        sub: c.system ? '' : 'Custom',
        selected: p.value === c.id, act: 'pick', arg: c.id
      })))
      + (p.clearable ? U.row({ lead: U.mark('close', 10), title: 'No category',
          sub: "Won't count toward a budget", act: 'pick', arg: '' }) : '')
      + U.row({ lead: U.mark('plus', 2), title: 'New category', act: 'open-sheet:CAT-002' })
    });
  };
  S['PICK-003'] = function (st) {   /* date */
    const p = st.picker;
    const days = [];
    for (let i = 0; i < 14; i++) {
      const dt = new Date(M.TODAY); dt.setDate(dt.getDate() - i);
      days.push(dt.toISOString().slice(0, 10));
    }
    return U.sheet({ title: 'Select date', leftLabel: 'Cancel', size: 'mid',
      body: U.pickerList(days.map(d => ({
        lead: U.mark('calendar', 3), title: M.dateLabel(d), sub: M.dateLong(d),
        selected: p.value === d, act: 'pick', arg: d
      })))
      + `<div style="padding:12px 16px 22px;font-size:11.5px;color:var(--pk-text-tertiary)">
          Future dates aren't available — a future-dated expense would make your balance disagree with your bank.</div>`
    });
  };
  S['PICK-004'] = function (st) {   /* space */
    const p = st.picker;
    return U.sheet({ title: 'Select space', leftLabel: 'Cancel', size: 'mid',
      body: U.pickerList(M.activeSpaces().map(s => ({
        lead: U.mark(s.icon, s.colorIdx), title: esc(s.name),
        sub: s.members.length + ' members · ' + s.currency,
        selected: p.value === s.id, act: 'pick', arg: s.id
      })))
    });
  };
  S['PICK-005'] = function (st) {   /* member */
    const p = st.picker;
    const sp = M.space(p.spaceId);
    const list = sp.members.filter(m => !p.exclude || m.userId !== p.exclude);
    return U.sheet({ title: p.title || 'Who paid?', leftLabel: 'Cancel', size: 'auto',
      body: U.pickerList(list.map(m => ({
        lead: U.avatar(m.userId, 40), title: esc(M.userName(m.userId)),
        sub: m.role[0] + m.role.slice(1).toLowerCase(),
        selected: p.value === m.userId, act: 'pick', arg: m.userId
      })))
    });
  };
  S['PICK-006'] = function (st) {   /* currency */
    const p = st.picker;
    return U.sheet({ title: 'Select currency', leftLabel: 'Cancel', size: 'mid',
      body: U.pickerList(Object.values(M.D.CURRENCIES).map(c => ({
        lead: U.mark('currency', 3), title: c.code, sub: esc(c.name),
        value: '<span style="font-size:17px">' + c.symbol + '</span>',
        selected: p.value === c.code, act: 'pick', arg: c.code
      })))
    });
  };
  S['PICK-007'] = function (st) {   /* icon & colour */
    const p = st.picker;
    const icons = ['cart','restaurant','transit','housing','utilities','health','shopping',
      'entertainment','travel','education','gift','income','card','bank','cash','savings','receipt','person'];
    return U.sheet({ title: 'Icon & colour', leftLabel: 'Cancel', rightLabel: 'Done',
      rightAct: 'pick-appearance-done', size: 'mid',
      body: `<div style="display:grid;place-items:center;padding:18px">
          ${U.mark(p.icon || 'cart', p.colorIdx || 1, 64)}</div>
        <div class="sec"><div class="stat-l">Colour</div>
          <div style="display:grid;grid-template-columns:repeat(6,1fr);gap:8px">
            ${Array.from({ length: 12 }, (_, i) => i + 1).map(i =>
              `<button data-act="pick-color" data-arg="${i}" aria-label="Colour ${i}"
                style="height:40px;border-radius:10px;border:${p.colorIdx === i ? '2px solid var(--pk-text-primary)' : '1px solid var(--pk-border-subtle)'};
                background:${U.catColor(i)};cursor:pointer"></button>`).join('')}
          </div></div>
        <div class="sec" style="margin-bottom:28px"><div class="stat-l">Icon</div>
          <div style="display:grid;grid-template-columns:repeat(6,1fr);gap:8px">
            ${icons.map(n => `<button data-act="pick-icon" data-arg="${n}" aria-label="${n}"
              style="height:44px;border-radius:10px;cursor:pointer;display:grid;place-items:center;
              border:${p.icon === n ? '2px solid var(--pk-brand-primary)' : '1px solid var(--pk-border-subtle)'};
              background:var(--pk-bg-surface);color:${p.icon === n ? U.catColor(p.colorIdx || 1) : 'var(--pk-text-secondary)'}">
              ${U.icon(n, 'pk-icon--sm')}</button>`).join('')}
          </div></div>`
    });
  };

  /* ══ ACC-003 / ACC-004 · add & edit account ════════════ */
  S['ACC-003'] = function (st) {
    const d = st.accDraft;
    const editing = !!d.id;
    const types = ['CASH','BANK','CARD','SAVINGS','DIGITAL','OTHER'];
    const hasTxns = editing && M.ledger({ accountId: d.id }).length > 0;
    let body = `<div class="chips" style="padding-top:14px">${types.map(t =>
      `<button class="chip" aria-pressed="${d.type === t}" data-act="acc-type" data-arg="${t}">
        ${t[0] + t.slice(1).toLowerCase()}</button>`).join('')}</div>`;
    body += `<div class="inp-wrap"><label class="inp-label">Account name</label>
      <input class="inp ${d.errName ? 'is-error' : ''}" value="${esc(d.name)}" data-live="acc-name" placeholder="e.g. Revolut">
      ${d.errName ? `<div class="inp-err">${esc(d.errName)}</div>` : ''}</div>`;
    if (!editing) body += `<div class="inp-wrap"><label class="inp-label">Current balance</label>
      <input class="inp" type="number" step="any" value="${d.opening / Math.pow(10, M.cur(d.currency).decimals)}"
        data-live="acc-opening">
      <div class="inp-hint">How much is in it right now. Pokito tracks changes from here.</div></div>`;
    else body += `<div class="inp-wrap"><label class="inp-label">Current balance</label>
      <div class="inp" style="background:var(--pk-bg-sunken);color:var(--pk-text-tertiary)">
        ${M.fmt(M.balance(d.id), d.currency)}</div>
      <div class="inp-hint">Balance is calculated from your transactions. To correct it, add an income or expense.</div></div>`;
    body += U.card(
      U.field({ icon: 'currency', label: 'Currency',
        value: d.currency + ' · ' + esc(M.cur(d.currency).name),
        act: hasTxns ? 'locked-currency' : 'open-picker:currency' }) +
      U.field({ icon: d.icon, label: 'Icon & colour',
        value: '<span style="display:inline-flex;vertical-align:middle">' + U.mark(d.icon, d.colorIdx, 28) + '</span>',
        act: 'open-picker:appearance' }) +
      U.toggleRow({ icon: 'check', label: 'Set as default', on: !!d.isDefault, act: 'acc-default',
        hint: 'New transactions will use this account by default' }), 'card--flush');
    if (editing) body += `<div class="sec" style="margin-top:26px">
      ${U.btn(d.archived ? 'Restore account' : 'Archive account', 'ghost', d.archived ? 'restore-account' : 'dlg:DLG-004', { arg: d.id })}
      <div style="height:8px"></div>
      ${hasTxns ? '' : U.btn('Delete account', 'danger-text', 'dlg:DLG-005', { arg: d.id })}
      <div class="inp-hint" style="text-align:center;margin-top:6px">
        ${hasTxns ? 'Accounts with transactions can be archived, not deleted.' : 'This account has no transactions.'}</div></div>`;

    return U.sheet({
      title: editing ? 'Edit account' : 'New account',
      rightLabel: 'Save', rightAct: editing ? 'acc-save-edit' : 'acc-save',
      rightDisabled: !d.name.trim(), body, size: 'form'
    });
  };
  S['ACC-004'] = S['ACC-003'];

})();
