/* ============================================================
   Screens — budgets, subscriptions, categories, settings,
   notifications, AI integrations, onboarding, auth, dialogs
   BUD-001..004 · SUB-001..006 · CAT-001..003 · SET-001..007
   NOTIF-001..002 · AI-001..007 · ONB-001..006 · AUTH-001..003
   ============================================================ */
(function () {
  const M = window.Domain, U = window.UI, S = window.Screens;
  const esc = U.esc;

  /* ══ BUD-001 · budgets ═════════════════════════════════ */
  S['BUD-001'] = function (st) {
    const scope = st.budgetScope || 'all';
    let list = M.D.BUDGETS.slice();
    if (scope === 'personal') list = list.filter(b => b.scope === 'PERSONAL');
    else if (scope !== 'all') list = list.filter(b => b.spaceId === scope);
    const withStatus = list.map(b => ({ b, s: M.budgetStatus(b, st.month) }))
      .sort((a, b) => (b.s.state === 'OVER' ? 1 : 0) - (a.s.state === 'OVER' ? 1 : 0) || b.s.percent - a.s.percent);

    let out = U.header({ title: 'Budgets', back: 'back',
      actions: [{ icon: 'plus', label: 'New budget', onClick: 'open-sheet:BUD-003' }] });
    if (!M.D.BUDGETS.length) return out + U.empty({ icon: 'budget', title: 'No budgets yet',
      body: 'Set a monthly limit for a category and Pockito will track it — for you, or for a space.',
      ctaLabel: 'Create a budget', ctaVariant: 'primary', ctaAct: 'open-sheet:BUD-003' });

    if (M.activeSpaces().length) out += U.chips(
      [{ value: 'all', label: 'All' }, { value: 'personal', label: 'Personal' },
       ...M.activeSpaces().map(s => ({ value: s.id, label: s.name }))], scope, 'budget-scope');

    const used = withStatus.reduce((a, x) => a + (M.toReporting(x.s.used, x.b.currency) || 0), 0);
    const lim = withStatus.reduce((a, x) => a + (M.toReporting(x.s.limit, x.b.currency) || 0), 0);
    out += `<div class="strip">${withStatus.length} budgets · ${M.fmt(used, 'EUR')} of ${M.fmt(lim, 'EUR')} used</div>`;

    if (!withStatus.length) return out + U.inlineEmpty('No budgets for this scope.', 'Create one', 'open-sheet:BUD-003');
    out += `<div class="sec">${U.card(withStatus.map(({ b, s }) => S._budgetBlock(b, s)).join(''))}</div>`;
    return out;
  };

  /* ══ BUD-002 · budget detail ═══════════════════════════ */
  S['BUD-002'] = function (st) {
    const b = M.budget(st.ctx.id);
    if (!b) return U.errorState('This budget no longer exists', 'back');
    const s = M.budgetStatus(b, st.month);
    const sp = b.spaceId ? M.space(b.spaceId) : null;
    const c = M.category(b.categoryId);
    const rows = M.budgetTxns(b, st.month);
    const R = 54, CIRC = 2 * Math.PI * R;
    const pct = Math.min(100, s.percent);
    const color = s.state === 'OVER' ? 'var(--pk-danger)' : s.state === 'NEAR' ? 'var(--pk-shared)'
      : sp ? 'var(--pk-shared)' : 'var(--pk-brand-primary)';

    let out = U.header({ title: esc(b.name), back: 'back',
      actions: [{ html: U.btn('Edit', 'tertiary', 'open-sheet:BUD-004', { block: false, arg: b.id }) },
                { icon: 'more', label: 'More', onClick: 'menu:budget' }] });

    if (s.state === 'OVER') out += U.banner({ tone: 'danger', icon: 'warning',
      text: `You're ${M.fmt(-s.remaining, b.currency)} over.` });
    else if (s.state === 'NEAR') out += U.banner({ tone: 'warning', icon: 'warning',
      text: `You've used ${Math.round(s.percent)}% of this budget.` });

    out += `<div class="ring-wrap">
      <svg class="ring" width="140" height="140" viewBox="0 0 140 140">
        <circle cx="70" cy="70" r="${R}" fill="none" stroke="var(--pk-bg-sunken)" stroke-width="12"/>
        <circle cx="70" cy="70" r="${R}" fill="none" stroke="${color}" stroke-width="12"
          stroke-linecap="round" stroke-dasharray="${CIRC}" stroke-dashoffset="${CIRC * (1 - pct / 100)}"/>
      </svg>
      <div class="ring-txt">
        <div class="ring-val money">${M.fmt(s.used, b.currency)}</div>
        <div class="ring-of money">of ${M.fmt(s.limit, b.currency)}</div>
      </div></div>
    <div style="text-align:center;margin-top:-40px;margin-bottom:16px">
      <div style="font-size:17px;font-weight:600" class="${s.state === 'OVER' ? 'money neg' : 'money'}">
        ${s.state === 'OVER' ? M.fmt(-s.remaining, b.currency) + ' over' : M.fmt(s.remaining, b.currency) + ' left'}</div>
      <div style="margin-top:8px">
        <button class="chip-mini" style="background:var(--pk-bg-sunken);color:var(--pk-text-secondary)"
          data-act="open-sheet:HOME-002">${M.monthLabel(st.month)}</button>
        ${sp ? U.pill(sp.name, 'shared') : U.pill('Personal', 'neutral')}</div>
    </div>`;

    if (s.daysRemaining > 0) out += `<div class="sec">${U.card(`<div class="grid2">
      <div><div class="stat-l">Daily average</div><div class="stat-v money" style="font-size:17px">
        ${M.fmt(s.dailyAvg, b.currency)}</div>
        <div style="font-size:11px;color:var(--pk-text-tertiary);margin-top:3px">over ${s.daysElapsed} days</div></div>
      <div><div class="stat-l">To stay on track</div><div class="stat-v money" style="font-size:17px">
        ${M.fmt(s.allowancePerDay, b.currency)}</div>
        <div style="font-size:11px;color:var(--pk-text-tertiary);margin-top:3px">for ${s.daysRemaining} days left</div></div>
      </div><div style="padding:0 14px 12px;font-size:12.5px;color:${s.projected > s.limit ? 'var(--pk-warning)' : 'var(--pk-balance-owed)'}">
        ${s.projected > s.limit
          ? `At this pace you'll finish about ${M.fmt(s.projected - s.limit, b.currency)} over.`
          : `At this pace you'll finish about ${M.fmt(s.limit - s.projected, b.currency)} under.`}</div>`)}</div>`;

    out += `<div class="sec">${U.sectionHead('Transactions', 'View all', 'budget-view-all|' + b.id)}
      ${U.card(rows.length ? rows.slice(0, 10).map(r => {
        if (r.kind === 'txn') return U.txnRow(r.ref);
        const x = r.ref, cc = M.category(x.categoryId);
        return U.row({ lead: U.mark(cc ? cc.icon : 'receipt', cc ? cc.colorIdx : 10),
          title: esc(x.title), sub: 'Paid by ' + esc(M.userName(x.payerUserId)) + ' · ' + M.dateLabel(x.occurredOn),
          value: U.money(r.amountMinor, r.currency),
          note: r.share ? 'Your share' : '',
          act: 'go:SPACE-010', arg: x.id });
      }).join('') : U.inlineEmpty('Nothing in this budget yet this month.'))}
      <div class="inp-hint" style="padding:10px 4px 0">${b.scope === 'PERSONAL'
        ? 'Shared expenses count your share only.' : "Counts everyone's spending in this space."}</div></div>`;
    return out;
  };

  /* ══ BUD-003 / BUD-004 · create & edit budget ══════════ */
  S['BUD-003'] = function (st) {
    const d = st.budgetDraft;
    const editing = !!d.id;
    const c = d.categoryId ? M.category(d.categoryId) : null;
    const dup = M.D.BUDGETS.some(b => b.id !== d.id && b.categoryId === d.categoryId &&
      b.scope === d.scope && (d.scope === 'PERSONAL' || b.spaceId === d.spaceId));
    const budSpace = d.scope === 'SPACE' && d.spaceId ? M.space(d.spaceId) : null;
    const cur = budSpace ? budSpace.currency : M.D.PROFILE.reportingCurrency;
    const valid = d.categoryId && d.amount > 0 && d.name.trim() && !dup;

    let body = `<div class="chips" style="padding-top:14px">
      <button class="chip" aria-pressed="${d.scope === 'PERSONAL'}" data-act="bud-scope" data-arg="PERSONAL"
        ${editing ? 'disabled' : ''}>Personal</button>
      ${M.activeSpaces().map(s => `<button class="chip" aria-pressed="${d.scope === 'SPACE' && d.spaceId === s.id}"
        data-act="bud-scope" data-arg="SPACE:${s.id}" ${editing ? 'disabled' : ''}>${esc(s.name)}</button>`).join('')}
    </div>`;
    if (editing) body += `<div class="inp-hint" style="padding:0 16px 8px">Create a new budget to change its scope or category.</div>`;
    body += U.card(
      U.field({ icon: c ? c.icon : 'budget', label: 'Category',
        value: c ? esc(c.name) : 'Select a category', placeholder: !c,
        act: editing ? null : 'open-picker:budget-category' }), 'card--flush');
    if (dup) body += `<div class="inp-err" style="padding:8px 16px">You already have a ${esc(c ? c.name : '')} budget for this scope.</div>`;
    body += `<div class="inp-wrap"><label class="inp-label">Monthly limit (${cur})</label>
      <input class="inp" type="number" step="any" value="${d.amount / Math.pow(10, M.cur(cur).decimals) || ''}"
        data-live="bud-amount" placeholder="0"></div>`;
    body += `<div class="inp-wrap"><label class="inp-label">Name</label>
      <input class="inp" value="${esc(d.name)}" data-live="bud-name" placeholder="e.g. Groceries"></div>`;
    body += `<div class="sec"><div class="stat-l">Alert me at</div>
      <div class="chips" style="padding-left:0;padding-right:0">
        ${[50, 80, 100].map(t => `<button class="chip" aria-pressed="${d.alerts.includes(t)}"
          data-act="bud-alert" data-arg="${t}">${t}%</button>`).join('')}</div>
      <div class="inp-hint">You'll get a notification when you cross these.</div></div>`;
    body += `<div class="inp-hint" style="padding:0 16px 20px">Resets on the 1st of each month.
      ${d.scope === 'PERSONAL' ? 'Counts your share of shared expenses.' : "Counts every member's share in this space."}</div>`;
    if (editing) body += `<div class="sec">${U.btn('Delete budget', 'danger-text', 'dlg:DLG-012', { arg: d.id })}</div>`;

    return U.sheet({ title: editing ? 'Edit budget' : 'New budget', rightLabel: 'Save',
      rightAct: editing ? 'bud-save-edit' : 'bud-save', rightDisabled: !valid, body, size: 'form' });
  };
  S['BUD-004'] = S['BUD-003'];

  /* ══ SUB-001 · subscriptions ═══════════════════════════ */
  S['SUB-001'] = function (st) {
    const subs = M.D.SUBSCRIPTIONS;
    const active = subs.filter(s => s.status === 'ACTIVE');
    const due = active.filter(s => s.nextDueOn && M.daysUntil(s.nextDueOn) <= 7)
      .sort((a, b) => a.nextDueOn.localeCompare(b.nextDueOn));
    const total = M.subsMonthlyTotal();
    const sort = st.subSort || 'due';
    const rest = subs.slice().sort((a, b) =>
      sort === 'amount' ? M.monthlyEquivalent(b) - M.monthlyEquivalent(a)
      : sort === 'name' ? a.name.localeCompare(b.name)
      : (a.nextDueOn || '9999').localeCompare(b.nextDueOn || '9999'));

    let out = U.header({ title: 'Subscriptions', back: 'back',
      actions: [{ icon: 'plus', label: 'Add subscription', onClick: 'open-sheet:SUB-003' }] });
    if (!subs.length) return out + U.empty({ icon: 'repeat', title: 'No subscriptions yet',
      body: 'Add the things you pay for regularly — streaming, rent, gym — and Pockito will remind you.',
      ctaLabel: 'Add subscription', ctaVariant: 'primary', ctaAct: 'open-sheet:SUB-003' });

    out += `<div class="hero" style="padding:18px 20px">
      <div class="hero-label">Every month</div>
      <div class="hero-amt" style="font-size:32px;line-height:36px">
        ${total.total != null ? M.fmt(total.total, total.currency) : '—'}</div>
      <div class="hero-sub">Across ${active.length} active subscriptions</div>
      ${Object.keys(total.byCurrency).length > 1 ? `<div class="hero-sub" style="margin-top:6px">
        ${Object.entries(total.byCurrency).map(([c, v]) => M.fmt(v, c)).join(' · ')}</div>` : ''}
    </div>`;

    if (due.length) out += `<div class="sec">${U.sectionHead('Due soon')}
      ${U.card(due.map(s => subRow(s, true)).join(''))}</div>`;

    out += `<div class="sec">
      <div class="sec-head"><h3>All</h3>
        <button class="link" data-act="sub-sort">By ${sort === 'due' ? 'date' : sort} ${U.icon('chevron-down','pk-icon--xs')}</button></div>
      ${U.card(rest.map(s => subRow(s, false)).join(''))}</div>`;
    return out;
  };

  function subRow(s, withActions) {
    const c = M.category(s.categoryId);
    const overdue = s.nextDueOn && M.daysUntil(s.nextDueOn) < 0;
    return U.row({
      lead: U.mark(s.icon, c ? c.colorIdx : 10, withActions ? 44 : 40),
      title: esc(s.name) + (s.status === 'PAUSED' ? ' ' + U.pill('Paused', 'neutral') : ''),
      sub: s.status === 'ACTIVE'
        ? `<span style="${overdue ? 'color:var(--pk-danger)' : ''}">${M.dueLabel(s.nextDueOn)}</span> · ${esc(M.account(s.accountId).name)}`
        : M.cadenceLabel(s.cadence) + ' · ' + esc(M.account(s.accountId).name),
      value: U.money(s.amountMinor, s.currency),
      note: withActions ? '' : (s.nextDueOn ? 'Next ' + M.dateLabel(s.nextDueOn) : ''),
      extra: withActions && s.status === 'ACTIVE' ? `<span style="display:flex;gap:6px;margin-top:5px">
        ${U.btn('Pay', 'secondary', 'open-sheet:SUB-005', { block: false, arg: s.id, cls: 'btn--sm' })}
        ${U.btn('Skip', 'tertiary', 'dlg:DLG-018', { block: false, arg: s.id, cls: 'btn--sm' })}</span>` : '',
      act: 'go:SUB-002', arg: s.id, muted: s.status !== 'ACTIVE'
    });
  }

  /* ══ SUB-002 · subscription detail ═════════════════════ */
  S['SUB-002'] = function (st) {
    const s = M.sub(st.ctx.id);
    if (!s) return U.errorState('This subscription no longer exists', 'back');
    const c = M.category(s.categoryId);
    const history = M.liveTxns().filter(t => t.subscriptionId === s.id)
      .sort((a, b) => b.occurredOn.localeCompare(a.occurredOn));
    const overdue = s.nextDueOn && M.daysUntil(s.nextDueOn) < 0;

    let out = U.header({ title: esc(s.name), back: 'back', actions: [
      { html: U.btn('Edit', 'tertiary', 'open-sheet:SUB-004', { block: false, arg: s.id }) },
      { icon: 'more', label: 'More', onClick: 'menu:sub' }] });

    if (s.status === 'PAUSED') out += U.banner({ tone: 'neutral', icon: 'info',
      text: 'Paused — no payments will be due.' });
    else if (overdue) out += U.banner({ tone: 'danger', icon: 'warning', text: 'This payment is overdue.' });

    out += `<div class="detail-top">
      ${U.mark(s.icon, c ? c.colorIdx : 10, 56)}
      <div class="detail-amt money" style="margin-top:12px">${M.fmt(s.amountMinor, s.currency)}</div>
      <div class="detail-sub">${M.cadenceLabel(s.cadence)}</div>
    </div>`;

    if (s.status === 'ACTIVE') out += `<div class="sec">${U.card(`<div style="padding:14px">
      <div style="display:flex;justify-content:space-between;align-items:center">
        <div><div class="stat-l">Next payment</div>
          <div style="font-size:17px;font-weight:600">${M.dateLong(s.nextDueOn)}</div>
          <div style="font-size:12px;color:${overdue ? 'var(--pk-danger)' : 'var(--pk-text-tertiary)'};margin-top:2px">
            ${M.dueLabel(s.nextDueOn)}</div></div>
        <div class="money" style="font-size:19px;font-weight:700">${M.fmt(s.amountMinor, s.currency)}</div>
      </div>
      <div style="margin-top:14px">${U.btn('Pay now', 'primary', 'open-sheet:SUB-005', { arg: s.id })}</div>
      <div style="height:8px"></div>
      ${U.btn('Skip this one', 'tertiary', 'dlg:DLG-018', { arg: s.id })}
    </div>`)}</div>`;

    out += `<div class="sec">${U.card([
      ['Repeats', M.cadenceLabel(s.cadence)],
      ['Account', `<button class="link" data-act="go:ACC-002" data-arg="${s.accountId}">${esc(M.account(s.accountId).name)}</button>`],
      ['Category', c ? `<button class="link" data-act="filter-category" data-arg="${c.id}">${esc(c.name)}</button>` : '—'],
      ['Started', M.dateLong(s.startsOn)],
      ['Ends', s.endsOn ? M.dateLong(s.endsOn) : 'No end date'],
      ...(s.lastPaidOn ? [['Last paid', M.dateLong(s.lastPaidOn)]] : [])
    ].map(([k, v]) => `<div class="kv"><span class="kv-k">${k}</span><span class="kv-v">${v}</span></div>`).join(''))}</div>`;

    out += `<div class="sec">${U.sectionHead('Payments',
      history.length ? history.length + ' · ' + M.fmt(history.reduce((a, t) => a + t.amountMinor, 0), s.currency) : null)}
      ${U.card(history.length ? history.map(t => U.row({
        lead: U.mark('receipt', c ? c.colorIdx : 10, 32),
        title: M.dateLong(t.occurredOn), sub: esc(M.account(t.fromAccountId).name),
        value: U.money(t.amountMinor, t.currency), act: 'go:TXN-002', arg: t.id
      })).join('') : U.inlineEmpty('No payments recorded yet.'))}</div>`;
    return out;
  };

  /* ══ SUB-003 / SUB-004 · add & edit subscription ═══════ */
  S['SUB-003'] = function (st) {
    const d = st.subDraft;
    const editing = !!d.id;
    const c = d.categoryId ? M.category(d.categoryId) : null;
    const acc = M.account(d.accountId);
    const valid = d.name.trim() && d.amount > 0 && d.categoryId && d.accountId;

    let body = `<div style="display:flex;gap:12px;align-items:center;padding:14px 16px">
        <button class="mark" data-act="open-picker:sub-appearance" style="width:48px;height:48px;
          background:${U.catColor(d.colorIdx)}1F;color:${U.catColor(d.colorIdx)};border:0;cursor:pointer">
          ${U.icon(d.icon)}</button>
        <div style="flex:1"><label class="inp-label">Name</label>
          <input class="inp" value="${esc(d.name)}" data-live="sub-name" placeholder="Netflix, rent, gym…"></div>
      </div>
      <div class="inp-wrap"><label class="inp-label">Amount${acc ? ' (' + acc.currency + ')' : ''}</label>
        <input class="inp" type="number" step="any"
          value="${d.amount / Math.pow(10, M.cur(acc ? acc.currency : 'EUR').decimals) || ''}"
          data-live="sub-amount" placeholder="0"></div>`;
    body += U.card(
      U.field({ icon: 'repeat', label: 'Repeats', value: M.cadenceLabel(d.cadence), act: 'open-sheet:SUB-006' }) +
      U.field({ icon: 'wallet', label: 'Pay from', value: acc ? esc(acc.name) : 'Select account',
        placeholder: !acc, act: 'open-picker:sub-account' }) +
      U.field({ icon: c ? c.icon : 'receipt', label: 'Category',
        value: c ? esc(c.name) : 'Required — pick a category', placeholder: !c,
        act: 'open-picker:sub-category' }) +
      U.field({ icon: 'calendar', label: 'Starts', value: M.dateLabel(d.startsOn), act: 'open-picker:sub-start' }),
      'card--flush');
    body += `<div class="inp-hint" style="padding:12px 16px">Next payment: <b>${M.dateLong(d.nextDueOn || d.startsOn)}</b></div>`;
    body += `<div class="inp-hint" style="padding:0 16px 16px">A category is required here — a subscription
      generates many future transactions, and an uncategorised one would poison every future budget.</div>`;
    if (editing) body += `<div class="sec">
      ${U.btn(d.status === 'PAUSED' ? 'Resume subscription' : 'Pause subscription', 'ghost', 'sub-toggle-pause', { arg: d.id })}
      <div style="height:8px"></div>
      ${U.btn('Delete subscription', 'danger-text', 'dlg:DLG-013', { arg: d.id })}</div>`;

    return U.sheet({ title: editing ? 'Edit subscription' : 'New subscription',
      rightLabel: 'Save', rightAct: editing ? 'sub-save-edit' : 'sub-save',
      rightDisabled: !valid, body, size: 'form' });
  };
  S['SUB-004'] = S['SUB-003'];

  /* ══ SUB-005 · confirm payment ═════════════════════════ */
  S['SUB-005'] = function (st) {
    const s = M.sub(st.sheetCtx.id);
    if (!s) return U.sheet({ title: 'Confirm payment', body: U.errorState('Not found', 'close-sheet') });
    const d = st.payDraft;
    const acc = M.account(d.accountId);
    const c = M.category(s.categoryId);
    const before = M.balance(acc.id);
    return U.sheet({ title: 'Confirm payment', size: 'auto',
      body: `<div style="padding:20px;text-align:center">
          ${U.mark(s.icon, c ? c.colorIdx : 10, 56)}
          <div style="font-size:16px;font-weight:600;margin-top:10px">${esc(s.name)}</div>
          <div class="detail-amt" style="font-size:32px;margin-top:8px">${M.fmt(d.amount, s.currency)}</div>
          <div class="detail-sub">Due ${M.dateLong(s.nextDueOn)}</div>
        </div>
        <div class="inp-wrap"><label class="inp-label">Amount charged (${s.currency})</label>
          <input class="inp" type="number" step="any"
            value="${d.amount / Math.pow(10, M.cur(s.currency).decimals)}" data-live="pay-amount">
          <div class="inp-hint">Edit if the actual charge was different. This changes only this payment.</div></div>
        ${U.card(
          U.field({ icon: 'wallet', label: 'Pay from', value: esc(acc.name), act: 'open-picker:pay-account' }) +
          U.field({ icon: 'calendar', label: 'Date', value: M.dateLabel(d.occurredOn), act: 'open-picker:pay-date' }),
          'card--flush')}
        <div class="inp-hint" style="padding:12px 16px">
          ${esc(acc.name)} goes from ${M.fmt(before, acc.currency)} to ${M.fmt(before - (M.convert(d.amount, s.currency, acc.currency) || 0), acc.currency)}.<br>
          Next payment: ${M.dateLong(M.nextDueAfter(s))}.</div>
        <div style="padding:8px 16px 20px">${U.btn('Confirm payment', 'primary', 'pay-confirm', { arg: s.id })}</div>` });
  };

  /* ══ SUB-006 · cadence picker ══════════════════════════ */
  S['SUB-006'] = function (st) {
    const d = st.subDraft, c = d.cadence;
    const next3 = [];
    let probe = Object.assign({}, d, { nextDueOn: d.nextDueOn || d.startsOn });
    for (let i = 0; i < 3; i++) { probe.nextDueOn = M.nextDueAfter(probe); next3.push(probe.nextDueOn); }
    return U.sheet({ title: 'Repeats', leftLabel: 'Cancel', rightLabel: 'Done', rightAct: 'cadence-done', size: 'auto',
      body: `<div class="chips" style="padding-top:14px">
          ${['DAILY','WEEKLY','MONTHLY','YEARLY'].map(f =>
            `<button class="chip" aria-pressed="${c.frequency === f}" data-act="cad-freq" data-arg="${f}">
              ${f[0] + f.slice(1).toLowerCase()}</button>`).join('')}</div>
        <div class="mrow" style="border-top:1px solid var(--pk-border-subtle)">
          <span class="row-body"><span class="row-title" style="font-size:14px">Every</span></span>
          <button class="ico-btn" data-act="cad-interval" data-arg="-1" ${c.interval <= 1 ? 'disabled' : ''}
            style="width:34px;height:34px;background:var(--pk-bg-sunken)">−</button>
          <span class="money" style="min-width:46px;text-align:center;font-weight:600">${c.interval || 1}</span>
          <button class="ico-btn" data-act="cad-interval" data-arg="1"
            style="width:34px;height:34px;background:var(--pk-bg-sunken)">＋</button>
        </div>
        ${c.frequency === 'MONTHLY' ? `<div class="inp-wrap"><label class="inp-label">Day of month</label>
          <input class="inp" type="number" min="1" max="31" value="${c.dayOfMonth || 1}" data-live="cad-day">
          ${(c.dayOfMonth || 1) > 28 ? '<div class="inp-hint">In shorter months this falls on the last day.</div>' : ''}</div>` : ''}
        ${c.frequency === 'WEEKLY' ? `<div class="chips">
          ${['Mon','Tue','Wed','Thu','Fri','Sat','Sun'].map((dw, i) =>
            `<button class="chip" aria-pressed="${(c.dayOfWeek || 1) === i + 1}" data-act="cad-dow" data-arg="${i + 1}">${dw}</button>`).join('')}</div>` : ''}
        ${c.frequency === 'YEARLY' ? `<div class="chips" style="flex-wrap:wrap">
          ${M.MONTHS.map((mn, i) => `<button class="chip" aria-pressed="${(c.monthOfYear || 1) === i + 1}"
            data-act="cad-month" data-arg="${i + 1}">${mn.slice(0, 3)}</button>`).join('')}</div>` : ''}
        <div class="note note--info" style="margin-top:8px">
          <b>${M.cadenceLabel(c)}</b><br>
          <span style="font-size:11.5px">Next: ${next3.map(d2 => M.dateLabel(d2)).join(' · ')}</span></div>` });
  };

  /* ══ CAT-001 · categories ══════════════════════════════ */
  S['CAT-001'] = function (st) {
    const type = st.catTab || 'EXPENSE';
    const list = M.D.CATEGORIES.filter(c => c.type === type && !c.hidden);
    const custom = list.filter(c => !c.system), system = list.filter(c => c.system);
    const usage = c => M.liveTxns().filter(t => t.categoryId === c.id).length
      + M.liveSplits().filter(s => s.categoryId === c.id).length;

    let out = U.header({ title: 'Categories', back: 'back',
      actions: [{ icon: 'plus', label: 'New category', onClick: 'open-sheet:CAT-002' }] });
    out += U.tabs([{ value: 'EXPENSE', label: 'Expenses' }, { value: 'INCOME', label: 'Income' }], type, 'cat-tab');
    const rowFor = c => U.row({
      lead: U.mark(c.icon, c.colorIdx), title: esc(c.name),
      sub: usage(c) ? `Used in ${usage(c)} ${usage(c) === 1 ? 'record' : 'records'}` : 'Not used yet',
      extra: c.system ? U.pill('Built in', 'neutral') : '',
      act: 'open-sheet:CAT-002', arg: c.id, chevron: true });
    if (custom.length) out += `<div class="sec"><div class="stat-l">Yours</div>${U.card(custom.map(rowFor).join(''))}</div>`;
    out += `<div class="sec"><div class="stat-l">Built in</div>${U.card(system.map(rowFor).join(''))}</div>`;
    return out;
  };

  /* ══ CAT-002 · add / edit category ═════════════════════ */
  S['CAT-002'] = function (st) {
    const d = st.catDraft;
    const editing = !!d.id;
    const src = editing ? M.category(d.id) : null;
    const inUse = editing && (M.liveTxns().some(t => t.categoryId === d.id) ||
      M.liveSplits().some(s => s.categoryId === d.id));
    const dup = M.D.CATEGORIES.some(c => c.id !== d.id && c.type === d.type &&
      c.name.trim().toLowerCase() === d.name.trim().toLowerCase());
    return U.sheet({
      title: editing ? 'Edit category' : 'New category',
      rightLabel: 'Save', rightAct: editing ? 'cat-save-edit' : 'cat-save',
      rightDisabled: !d.name.trim() || dup, size: 'auto',
      body: `<div style="display:grid;place-items:center;padding:20px">
          ${U.mark(d.icon, d.colorIdx, 56)}
          <div style="font-size:15px;font-weight:500;margin-top:10px">${esc(d.name) || 'New category'}</div></div>
        <div class="inp-wrap"><label class="inp-label">Name</label>
          <input class="inp ${dup ? 'is-error' : ''}" value="${esc(d.name)}" data-live="cat-name"
            placeholder="e.g. Coffee" ${src && src.system ? 'disabled' : ''}>
          ${dup ? '<div class="inp-err">You already have a category with this name.</div>' : ''}
          ${src && src.system ? '<div class="inp-hint">Built-in categories can\'t be renamed.</div>' : ''}</div>
        <div class="chips">
          ${['EXPENSE','INCOME'].map(t => `<button class="chip" aria-pressed="${d.type === t}"
            data-act="cat-type" data-arg="${t}" ${inUse ? 'disabled' : ''}>${t[0] + t.slice(1).toLowerCase()}</button>`).join('')}
        </div>
        ${inUse ? '<div class="inp-hint" style="padding:0 16px 8px">Type can\'t change once a category is in use.</div>' : ''}
        ${U.card(U.field({ icon: d.icon, label: 'Icon & colour',
          value: '<span style="display:inline-flex;vertical-align:middle">' + U.mark(d.icon, d.colorIdx, 28) + '</span>',
          act: 'open-picker:cat-appearance' }), 'card--flush')}
        ${editing && !(src && src.system) ? `<div class="sec" style="margin-top:20px">
          ${U.btn('Delete category', 'danger-text', inUse ? 'dlg:DLG-014' : 'cat-delete', { arg: d.id })}</div>`
        : editing ? `<div class="sec" style="margin-top:20px">
          ${U.btn(src.hidden ? 'Show category' : 'Hide category', 'ghost', 'cat-hide', { arg: d.id })}</div>` : ''}
        <div style="height:16px"></div>` });
  };

  /* ══ CAT-003 · reassign category ═══════════════════════ */
  S['CAT-003'] = function (st) {
    const c = M.category(st.sheetCtx && st.sheetCtx.id);
    if (!c) return U.goneSheet('This category');
    const txns = M.liveTxns().filter(t => t.categoryId === c.id).length;
    const splits = M.liveSplits().filter(s => s.categoryId === c.id).length;
    const budgets = M.D.BUDGETS.filter(b => b.categoryId === c.id).length;
    const subs = M.D.SUBSCRIPTIONS.filter(s => s.categoryId === c.id).length;
    const targets = M.D.CATEGORIES.filter(x => x.type === c.type && x.id !== c.id);
    return U.sheet({ title: 'Move transactions', leftLabel: 'Cancel', size: 'mid',
      body: `<div style="padding:16px">
          <p style="font-size:13.5px;color:var(--pk-text-secondary);margin:0 0 10px">
            <b>${esc(c.name)}</b> is in use. Choose where to move everything, then it will be deleted.</p>
          <div style="font-size:12px;color:var(--pk-text-tertiary);font-variant-numeric:tabular-nums">
            ${txns} transactions · ${splits} shared expenses · ${budgets} budgets · ${subs} subscriptions</div>
        </div>
        <div class="stat-l" style="padding:0 16px 8px">Move to</div>
        ${targets.length ? U.pickerList(targets.map(t => ({
          lead: U.mark(t.icon, t.colorIdx), title: esc(t.name),
          selected: st.reassignTo === t.id, act: 'reassign-pick', arg: t.id })))
        : U.inlineEmpty('Create another category first.', 'New category', 'open-sheet:CAT-002')}`,
      footer: targets.length ? U.btn('Move and delete', 'destructive', 'reassign-commit',
        { disabled: !st.reassignTo, arg: c.id }) : '' });
  };

  /* ══ SET-001 · profile & settings ══════════════════════ */
  S['SET-001'] = function () {
    const p = M.D.PROFILE;
    const conns = M.D.AI_CONNECTIONS.filter(c => c.status !== 'REVOKED');
    const pendingApp = M.D.AI_APPROVALS.filter(a => a.state === 'PENDING').length;
    return U.header({ title: 'Settings', back: 'back' })
      + `<div class="sec">${U.card(U.row({
          lead: U.avatar(M.ME, 52), title: esc(p.displayName), sub: esc(p.email),
          act: 'open-sheet:SET-002', chevron: true }))}</div>
      <div class="sec"><div class="stat-l">Money</div>${U.card(
        U.field({ icon: 'currency', label: 'Default currency', value: p.reportingCurrency, act: 'open-sheet:SET-003' }) +
        U.field({ icon: 'cart', label: 'Categories', value: M.D.CATEGORIES.length + ' categories', act: 'go:CAT-001' }) +
        U.field({ icon: 'budget', label: 'Budgets', value: M.D.BUDGETS.length + ' budgets', act: 'go:BUD-001' }) +
        U.field({ icon: 'repeat', label: 'Subscriptions', value: M.D.SUBSCRIPTIONS.length + ' subscriptions', act: 'go:SUB-001' }))}
        <div class="inp-hint" style="padding:8px 16px 0">Net worth, spending and budgets are shown in your default
          currency. Accounts and spaces keep their own — Pockito converts for totals only.</div></div>
      <div class="sec"><div class="stat-l">App</div>${U.card(
        U.field({ icon: 'bell', label: 'Notifications', value: 'On', act: 'go:SET-004' }) +
        U.field({ icon: 'sparkle', label: 'AI & Integrations',
          value: pendingApp ? '<span style="color:var(--pk-warning)">' + pendingApp + ' needs approval</span>'
            : (conns.length ? conns.length + ' connected' : 'None'), act: 'go:AI-001' }) +
        U.field({ icon: 'info', label: 'Appearance', value: p.theme[0].toUpperCase() + p.theme.slice(1), act: 'open-sheet:SET-005' }) +
        U.field({ icon: 'link', label: 'Language', value: esc(p.language), act: 'open-sheet:SET-006' }))}</div>
      <div class="sec"><div class="stat-l">Other</div>${U.card(
        U.field({ icon: 'shield', label: 'About', value: 'v0.1.0', act: 'go:SET-007' }))}</div>
      <div class="sec">${U.btn('Sign out', 'danger-text', 'dlg:DLG-015')}</div>
      <div style="text-align:center;font-size:11.5px;color:var(--pk-text-tertiary);padding-bottom:20px">
        Pockito 0.1.0 · prototype</div>`;
  };

  S['SET-002'] = function () {
    const p = M.D.PROFILE;
    return U.sheet({ title: 'Profile', rightLabel: 'Save', rightAct: 'profile-save', size: 'auto',
      body: `<div style="display:grid;place-items:center;padding:22px">${U.avatar(M.ME, 76)}</div>
        <div class="inp-wrap"><label class="inp-label">Display name</label>
          <input class="inp" value="${esc(p.displayName)}" data-live="profile-name">
          <div class="inp-hint">This is what other members of your spaces see.</div></div>
        <div class="inp-wrap"><label class="inp-label">Email</label>
          <div class="inp" style="background:var(--pk-bg-sunken);color:var(--pk-text-tertiary)">${esc(p.email)}</div>
          <div class="inp-hint">Managed by your sign-in.</div></div><div style="height:16px"></div>` });
  };
  S['SET-003'] = function () {
    const p = M.D.PROFILE;
    const others = [...new Set(M.activeAccounts().map(a => a.currency))].filter(c => c !== p.reportingCurrency);
    return U.sheet({ title: 'Default currency', leftLabel: 'Cancel', size: 'mid',
      body: `<div class="inp-hint" style="padding:14px 16px">Net worth, totals and budgets are shown in this
          currency. Your accounts and spaces keep their own.</div>
        ${others.length ? `<div class="note" style="margin-bottom:0">You have accounts in
          ${others.join(', ')}. Totals will be converted using the latest rates.</div>` : ''}
        ${U.pickerList(Object.values(M.D.CURRENCIES).map(c => ({
          lead: U.mark('currency', 3), title: c.code, sub: esc(c.name),
          value: '<span style="font-size:17px">' + c.symbol + '</span>',
          selected: p.reportingCurrency === c.code, act: 'set-reporting-currency', arg: c.code })))}` });
  };
  S['SET-004'] = function () {
    const n = M.D.PROFILE.notifications || {};
    return U.header({ title: 'Notifications', back: 'back' })
      + `<div class="sec"><div class="stat-l">What you get</div>${U.card(
        [['expenses','New shared expenses','When someone adds an expense to a space you\'re in'],
         ['settleReq','Settlement requests','When someone says they paid you'],
         ['settleOk','Settlement confirmations','When someone confirms a payment'],
         ['invites','Space invitations','When someone invites you to a space'],
         ['budgets','Budget alerts','When you reach 80% or 100% of a budget'],
         ['aiChange','AI recorded a change','When a connected app adds or changes something']
        ].map(([k, l, h]) => U.toggleRow({ label: l, hint: h, on: n[k] !== false, act: 'notif-toggle', arg: k })).join('')
        + `<div class="field" style="opacity:.75">
            <span class="field-ico">${U.icon('shield','pk-icon--sm')}</span>
            <span class="field-body"><span class="field-value">AI approval needed</span>
              <span class="field-hint">Approvals expire, so Pockito always tells you</span></span>
            <span class="switch is-on" style="opacity:.6"></span></div>`)}
        <div class="inp-hint" style="padding:8px 16px 0">The approval alert can't be switched off — approvals
          expire in 30 minutes, and a silent one is a broken feature.</div></div>
      <div class="sec"><div class="stat-l">Per space</div>${U.card(M.activeSpaces().map(s => {
        const on = Object.values(s.notifications).filter(Boolean).length;
        return U.field({ icon: s.icon, label: esc(s.name),
          value: on === 3 ? 'All' : on === 0 ? 'Off' : 'Some', act: 'go:SPACE-006', arg: s.id });
      }).join(''))}</div>
      <div class="sec">${U.card(U.field({ icon: 'sparkle', label: 'Manage connected apps',
        value: M.D.AI_CONNECTIONS.filter(c => c.status !== 'REVOKED').length + ' connected', act: 'go:AI-001' }))}</div>`;
  };
  S['SET-005'] = function () {
    const p = M.D.PROFILE;
    return U.sheet({ title: 'Appearance', size: 'auto',
      body: U.pickerList([['system','System'],['light','Light'],['dark','Dark']].map(([v, l]) => ({
        lead: U.mark(v === 'dark' ? 'shield' : v === 'light' ? 'utilities' : 'info', v === 'dark' ? 2 : 4),
        title: l, selected: p.theme === v, act: 'set-theme', arg: v })))
        + '<div style="height:16px"></div>' });
  };
  S['SET-006'] = function () {
    const p = M.D.PROFILE;
    return U.sheet({ title: 'Language', size: 'mid',
      body: U.pickerList([['English','English'],['Deutsch','German'],['Français','French'],['日本語','Japanese']]
        .map(([native, en]) => ({ lead: U.mark('link', 3), title: native, sub: en,
          selected: p.language === native, act: 'set-language', arg: native })))
        + '<div class="inp-hint" style="padding:12px 16px 20px">Number and date formats follow your device region.</div>' });
  };
  S['SET-007'] = function () {
    return U.header({ title: 'About', back: 'back' })
      + `<div style="text-align:center;padding:30px 20px">
          <div class="hero-blob"></div>
          <div style="font-size:19px;font-weight:700;margin-top:14px">Pockito</div>
          <div style="font-size:13px;color:var(--pk-text-tertiary);margin-top:4px">Version 0.1.0 · prototype</div>
        </div>
        <div class="sec">${U.card(
          ['Terms of service','Privacy policy','Open-source licences','Contact support']
          .map(l => U.row({ title: l, act: 'noop-external', chevron: true })).join(''))}</div>
        <div style="text-align:center;font-size:11.5px;color:var(--pk-text-tertiary)">© 2026 Pockito</div>`;
  };

  /* ══ NOTIF-001 · notifications ═════════════════════════ */
  S['NOTIF-001'] = function () {
    const list = M.D.NOTIFICATIONS;
    const unread = list.filter(n => !n.read).length;
    const glyph = { AI_APPROVAL: ['shield', 4], AI_CHANGE: ['sparkle', 2],
      SETTLEMENT_REQUEST: ['settle', 4], SETTLEMENT_CONFIRMED: ['check', 1],
      EXPENSE_ADDED: ['receipt', 2], BUDGET_ALERT: ['budget', 5], INVITE: ['person-add', 3] };
    let out = U.header({ title: 'Notifications', back: 'back', actions: [
      { html: U.btn('Mark all read', 'tertiary', 'notif-read-all', { block: false, disabled: !unread }) }] });
    if (!list.length) return out + U.empty({ icon: 'bell', title: 'No notifications',
      body: "You'll hear from us when something happens in your spaces." });
    out += `<div class="sec">${U.card(list.map(n => {
      const g = glyph[n.type] || ['info', 10];
      const actionable = n.type === 'AI_APPROVAL' || n.type === 'SETTLEMENT_REQUEST' || n.type === 'INVITE';
      return U.row({
        lead: U.mark(g[0], g[1]),
        title: n.text + (n.read ? '' : ' <span style="display:inline-block;width:7px;height:7px;border-radius:50%;background:var(--pk-brand-primary);vertical-align:2px;margin-left:4px"></span>'),
        sub: M.relTime(n.at) + (actionable ? ' · tap to review' : ''),
        act: 'notif-open', arg: n.id, chevron: true
      });
    }).join(''))}</div>`;
    return out;
  };

  /* ══ NOTIF-002 · enable notifications pre-prompt ═══════ */
  S['NOTIF-002'] = function () {
    return U.sheet({ title: '', leftLabel: '', size: 'auto',
      body: `<div style="padding:8px 22px 22px;text-align:center">
        <div style="display:grid;place-items:center;color:var(--pk-brand-primary);margin-bottom:12px">
          ${U.icon('bell','pk-icon--lg')}</div>
        <div style="font-size:19px;font-weight:700">Stay in the loop</div>
        <p style="font-size:13.5px;color:var(--pk-text-secondary);margin:8px 0 18px">
          Get notified when someone adds a shared expense, pays you back, or a budget needs attention.</p>
        <div style="text-align:left;margin-bottom:20px">
          ${[['receipt','Mira added Weekly shop · €84.00'],
             ['settle','Mira says she paid you €25.00'],
             ['budget',"You've used 80% of your Groceries budget"]].map(([ic, t]) =>
            `<div style="display:flex;gap:10px;align-items:center;margin-bottom:10px">
              <span style="color:var(--pk-text-tertiary)">${U.icon(ic,'pk-icon--sm')}</span>
              <span style="font-size:13px;color:var(--pk-text-secondary)">${t}</span></div>`).join('')}
        </div>
        ${U.btn('Turn on notifications', 'primary', 'notif-permission-yes')}
        <div style="height:8px"></div>
        ${U.btn('Not now', 'tertiary', 'close-sheet')}
      </div>` });
  };

  /* ══ AI-001 · AI & Integrations ════════════════════════ */
  S['AI-001'] = function () {
    const conns = M.D.AI_CONNECTIONS.filter(c => c.status !== 'REVOKED')
      .sort((a, b) => (a.status === 'SUSPENDED' ? -1 : 0) - (b.status === 'SUSPENDED' ? -1 : 0)
        || (b.lastUsedAt || '').localeCompare(a.lastUsedAt || ''));
    const pending = M.D.AI_APPROVALS.filter(a => a.state === 'PENDING');
    let out = U.header({ title: 'AI & Integrations', back: 'back',
      actions: conns.length > 1 ? [{ icon: 'more', label: 'More', onClick: 'menu:ai' }] : [] });

    if (!conns.length) return out + U.empty({
      icon: 'sparkle', title: 'Use Pockito with AI',
      body: 'Connect ChatGPT, Claude or another assistant and ask about your spending, or record expenses just by describing them.',
      ctaLabel: 'Connect an app', ctaVariant: 'primary', ctaAct: 'go:AI-002' });

    if (pending.length) out += U.banner({ tone: 'warning', icon: 'shield', act: 'go:AI-007',
      text: pending.length === 1 ? `<b>${esc(pending[0].client)}</b> is waiting for your approval`
        : pending.length + ' actions need your approval', cta: 'Review' });

    out += `<div class="sec">${U.card(conns.map(c => {
      const writes = c.scopes.some(s => s.includes('write'));
      return U.row({
        lead: `<span class="conn-logo">${esc(c.clientName[0])}</span>`,
        title: esc(c.clientName) + (c.verified ? '<span class="badge badge--ok">Verified</span>'
          : '<span class="badge badge--unv">Unverified</span>'),
        sub: (writes ? 'Read and record' : 'Read only')
          + (c.status === 'SUSPENDED' ? ' · ' + U.pill('Paused', 'warning') : '')
          + `<br>${c.lastUsedAt ? 'Last used ' + M.relTime(c.lastUsedAt) : 'Never used'} · ${c.writeCount} changes`
          + (!c.verified && writes ? '<br><span style="color:var(--pk-warning)">Unverified app with permission to record money</span>' : ''),
        act: 'go:AI-004', arg: c.id, chevron: true });
    }).join(''))}</div>`;

    out += `<div class="sec">${U.card(
      U.field({ icon: 'activity', label: 'AI activity', value: M.D.AI_ACTIVITY.length + ' actions', act: 'go:AI-006' }) +
      U.field({ icon: 'plus', label: 'Connect an app', value: 'Add ChatGPT, Claude or another', act: 'go:AI-002' }))}</div>`;
    out += `<div class="inp-hint" style="padding:0 16px 20px">Connected apps act as you. They can only do what you
      can do, and every change they make appears in AI activity.</div>`;
    return out;
  };

  /* ══ AI-002 · connect an app ═══════════════════════════ */
  S['AI-002'] = function () {
    const url = 'https://mcp.pockito.app/v1';
    return U.header({ title: 'Connect an app', back: 'back' })
      + U.banner({ tone: 'info', icon: 'info',
        text: '<b>Start in your AI app.</b> Connecting begins in ChatGPT, Claude or whichever assistant you use. Add Pockito there, and it will send you back here to approve.' })
      + `<div class="sec">${[
          'Open your AI app and add Pockito as a connector.',
          "Paste Pockito's address when it asks.",
          "You'll come back here to choose what it can see and do."
        ].map((t, i) => `<div style="display:flex;gap:12px;margin-bottom:14px;align-items:flex-start">
          <span style="width:26px;height:26px;border-radius:50%;background:var(--pk-brand-primary-subtle);
            color:var(--pk-brand-primary);display:grid;place-items:center;font-size:12px;font-weight:700;flex:none">${i + 1}</span>
          <span style="font-size:14px;color:var(--pk-text-secondary);line-height:1.5">${t}</span></div>`).join('')}</div>
      <div class="sec">${U.card(`<div style="padding:14px">
          <div class="stat-l">Pockito's address</div>
          <div class="link-url" style="font-size:13px;margin:6px 0 12px">${url}</div>
          ${U.btn('Copy address', 'secondary', 'copy-link', { arg: url })}</div>`)}</div>
      <div class="sec">${U.card(['ChatGPT','Claude','Other apps'].map(n =>
        U.row({ lead: `<span class="conn-logo" style="width:36px;height:36px;font-size:14px">${n[0]}</span>`,
          title: n, act: 'noop-external', chevron: true })).join(''))}</div>
      <div class="inp-hint" style="padding:0 16px 20px;text-align:center">
        Pockito never sees your AI app's account, and your AI app never sees your Pockito password.</div>`;
  };

  /* ══ AI-003 · authorization request (consent) ══════════ */
  S['AI-003'] = function (st) {
    const d = st.consent;
    const groups = [
      { k: 'A', label: 'Your money', desc: 'See your accounts, transactions and spending', write: false },
      { k: 'B', label: 'Shared spaces', desc: 'See your spaces, shared expenses and who owes whom', write: false },
      { k: 'C', label: 'Budgets & subscriptions', desc: 'See your budgets and recurring payments', write: false },
      { k: 'D', label: 'Record money', desc: 'Add and change expenses, income and subscriptions', write: true },
      { k: 'E', label: 'Manage budgets', desc: 'Create and change budget limits', write: true },
      { k: 'F', label: 'Settle balances', desc: 'Record and confirm payments between you and other members', write: true }
    ];
    const anyWrite = groups.some(g => g.write && d.groups[g.k]);
    const anyOn = groups.some(g => d.groups[g.k]);
    return `<div class="screen no-nav" style="position:static">
      <div style="text-align:center;padding:16px 0 8px"><div class="stage-mark" style="margin:0 auto"></div></div>
      <div class="sec">${U.card(`<div style="display:flex;gap:12px;align-items:center;padding:14px">
        <span class="conn-logo">${esc(d.clientName[0])}</span>
        <div style="flex:1;min-width:0">
          <div style="font-size:16px;font-weight:600">${esc(d.clientName.slice(0, 40))}
            ${d.verified ? '<span class="badge badge--ok">Verified</span>' : '<span class="badge badge--unv">Unverified</span>'}</div>
          <div style="font-size:12px;color:var(--pk-text-tertiary);margin-top:2px">${esc(d.host)}</div>
        </div></div>`)}
        <div class="inp-hint" style="padding:8px 4px 0;${d.verified ? '' : 'color:var(--pk-warning)'}">
          ${d.verified ? 'Pockito recognises this app.' : "Pockito can't verify this app. Only continue if you added it yourself."}</div>
      </div>
      <div class="sec"><h2 style="font-size:21px;font-weight:700;letter-spacing:-.02em;margin:0 0 4px">
        Give ${esc(d.clientName.slice(0, 40))} access to Pockito?</h2></div>
      <div class="sec">${U.card(groups.map(g => U.toggleRow({
          label: g.label, hint: g.desc, on: !!d.groups[g.k], act: 'consent-group', arg: g.k })).join(''))}</div>
      ${anyWrite ? `<div class="sec"><div class="stat-l">Limits</div>${U.card(
        `<div class="inp-wrap"><label class="inp-label">Most it can record at once (EUR)</label>
          <input class="inp" type="number" value="${d.perTxn / 100}" data-live="consent-pertxn"></div>
        <div class="inp-wrap" style="border-top:1px solid var(--pk-border-subtle)">
          <label class="inp-label">Most it can record per day (EUR)</label>
          <input class="inp" type="number" value="${d.daily / 100}" data-live="consent-daily"></div>`)}
        <div class="inp-hint" style="padding:8px 4px 0">Anything above these needs your approval in Pockito.
          You can change this later.</div></div>` : ''}
      <div class="sec">${U.card(`<div style="padding:14px">
        <div style="font-size:14px;font-weight:600;margin-bottom:10px">
          ${esc(d.clientName.slice(0, 40))} will never be able to</div>
        ${['Invite people to your spaces or remove them',
           'Create, rename or close accounts and spaces',
           'Cancel a settlement you\'ve already confirmed',
           'Change your profile or your default currency',
           'See or change your other connected apps'].map(t =>
          `<div style="display:flex;gap:9px;align-items:flex-start;margin-bottom:7px">
            <span style="color:var(--pk-text-tertiary);flex:none">${U.icon('close','pk-icon--xs')}</span>
            <span style="font-size:12.5px;color:var(--pk-text-secondary);line-height:1.45">${t}</span></div>`).join('')}
      </div>`)}</div>
      <div class="inp-hint" style="padding:0 16px 12px;text-align:center">
        Every change appears in AI activity, and you can disconnect at any time.</div>
      <div class="sec" style="margin-bottom:32px">
        ${U.btn('Connect', 'primary', 'consent-approve', { disabled: !anyOn })}
        ${!anyOn ? '<div class="inp-hint" style="text-align:center;margin-top:6px">Choose at least one thing it can do.</div>' : ''}
        <div style="height:8px"></div>
        ${U.btn("Don't connect", 'tertiary', 'dlg:DLG-021')}
      </div></div>`;
  };

  /* ══ AI-004 · connection detail ════════════════════════ */
  S['AI-004'] = function (st) {
    const c = M.conn(st.ctx.id);
    if (!c) return U.errorState('This connection no longer exists', 'back');
    const writes = c.scopes.some(s => s.includes('write'));
    const acts = M.D.AI_ACTIVITY.filter(a => a.connectionId === c.id).slice(0, 5);
    let out = U.header({ title: esc(c.clientName), back: 'back' });
    if (c.status === 'SUSPENDED') out += U.banner({ tone: 'warning', icon: 'warning',
      text: `Pockito paused this app. ${esc(c.suspendReason || '')}`, cta: 'Resume', act: 'ai-resume', arg: c.id });
    out += `<div class="detail-top">
      <span class="conn-logo" style="width:68px;height:68px;font-size:24px;margin:0 auto">${esc(c.clientName[0])}</span>
      <div style="font-size:19px;font-weight:700;margin-top:12px">${esc(c.clientName)}
        ${c.verified ? '<span class="badge badge--ok">Verified</span>' : '<span class="badge badge--unv">Unverified</span>'}</div>
      ${!c.verified && writes ? '<div style="font-size:12px;color:var(--pk-warning);margin-top:6px">Pockito can\'t verify this app, and it can record money.</div>' : ''}
    </div>`;
    out += `<div class="sec">${U.card([
      ['Access', writes ? 'Read and record' : 'Read only'],
      ['Connected', M.dateLong(c.createdAt)],
      ['Last used', c.lastUsedAt ? M.relTime(c.lastUsedAt) : 'Never'],
      ['Actions taken', `${c.writeCount} changes · ${c.readCount} reads`]
    ].map(([k, v]) => `<div class="kv"><span class="kv-k">${k}</span><span class="kv-v">${v}</span></div>`).join(''))}</div>`;
    out += `<div class="sec">${U.sectionHead('Permissions', 'Change', 'go:AI-005|' + c.id)}
      ${U.card(`<div style="padding:14px">
        ${c.scopes.map(s => `<div style="display:flex;gap:8px;align-items:center;margin-bottom:6px">
          <span style="color:var(--pk-balance-owed)">${U.icon('check','pk-icon--xs')}</span>
          <span style="font-size:12.5px;font-family:var(--pk-font-mono);color:var(--pk-text-secondary)">${s}</span></div>`).join('')}
        ${writes ? `<div class="inp-hint" style="margin-top:10px">Up to ${M.fmt(c.limits.perTxnMinor, 'EUR')} at a time ·
          ${M.fmt(c.limits.dailyTotalMinor, 'EUR')} a day · ${c.limits.spaces === 'ALL' ? 'All spaces' : 'Some spaces'}</div>` : ''}
      </div>`)}</div>`;
    out += `<div class="sec">${U.sectionHead('Recent activity', 'See all', 'go:AI-006|' + c.id)}
      ${U.card(acts.length ? acts.map(a => aiActRow(a)).join('')
        : U.inlineEmpty(writes ? "This app hasn't changed anything yet."
          : "This app can only read — it hasn't changed anything and can't."))}</div>`;
    out += `<div class="sec" style="margin-top:24px">
      ${U.btn('Disconnect', 'danger-text', 'dlg:DLG-019', { arg: c.id })}
      <div class="inp-hint" style="text-align:center;margin-top:4px">
        Removes access immediately. Nothing it added is deleted.</div></div>`;
    return out;
  };

  function aiActRow(a) {
    return U.row({
      lead: `<span class="conn-logo" style="width:38px;height:38px;font-size:14px">${esc(a.client[0])}</span>`,
      title: esc(a.client),
      sub: esc(a.action) + '<br>' + esc(a.context)
        + (a.outcome === 'BLOCKED' ? ' ' + U.pill('Blocked', 'danger') : ''),
      value: `<span style="font-size:11px;color:var(--pk-text-tertiary)">${a.at.slice(11)}</span>`,
      note: `<span style="color:var(--pk-text-tertiary)">${a.gate === 'two_phase' ? U.icon('check','pk-icon--xs')
        : a.gate ? U.icon('shield','pk-icon--xs') : ''}</span>`,
      act: a.target ? 'go:' + a.target.screen : null, arg: a.target ? a.target.id : null,
      muted: a.outcome === 'BLOCKED'
    });
  }

  /* ══ AI-005 · connection permissions ═══════════════════ */
  S['AI-005'] = function (st) {
    const c = M.conn(st.ctx.id);
    if (!c || !st.permDraft) return U.gone('This connection');
    const d = st.permDraft;
    const groups = [
      { k: 'A', label: 'Your money', scopes: ['profile:read','accounts:read','transactions:read','analytics:read'] },
      { k: 'B', label: 'Shared spaces', scopes: ['spaces:read','balances:read','settlements:read'] },
      { k: 'C', label: 'Budgets & subscriptions', scopes: ['budgets:read','subscriptions:read'] },
      { k: 'D', label: 'Record money', scopes: ['transactions:write','expenses:write','subscriptions:write'] },
      { k: 'E', label: 'Manage budgets', scopes: ['budgets:write'] },
      { k: 'F', label: 'Settle balances', scopes: ['settlements:write'] }
    ];
    const anyWrite = ['D','E','F'].some(k => d.groups[k]);
    const none = !Object.values(d.groups).some(Boolean);
    let out = U.header({ title: 'Permissions', back: 'back', actions: [
      { html: U.btn('Save', 'tertiary', 'perm-save', { block: false, arg: c.id }) }] });
    if (c.status === 'SUSPENDED') out += U.banner({ tone: 'warning', icon: 'warning',
      text: 'Resume this app before changing its permissions.' });
    out += `<div class="sec">${U.card(`<div style="display:flex;gap:10px;align-items:center;padding:12px 14px">
      <span class="conn-logo" style="width:34px;height:34px;font-size:14px">${esc(c.clientName[0])}</span>
      <span style="font-size:15px;font-weight:600">${esc(c.clientName)}</span></div>`)}</div>`;
    out += `<div class="sec">${U.card(groups.map(g => {
      const requested = g.scopes.some(s => c.scopes.includes(s)) || d.groups[g.k];
      return U.toggleRow({ label: g.label,
        hint: requested ? '' : "This app didn't ask for this",
        on: !!d.groups[g.k], act: requested ? 'perm-group' : 'perm-locked', arg: g.k });
    }).join(''))}</div>`;
    if (anyWrite) out += `<div class="sec"><div class="stat-l">Limits</div>${U.card(
      `<div class="inp-wrap"><label class="inp-label">Most it can record at once (EUR)</label>
        <input class="inp" type="number" value="${d.perTxn / 100}" data-live="perm-pertxn"></div>
      <div class="inp-wrap" style="border-top:1px solid var(--pk-border-subtle)">
        <label class="inp-label">Most it can record per day (EUR)</label>
        <input class="inp" type="number" value="${d.daily / 100}" data-live="perm-daily"></div>`)}
      <div class="inp-hint" style="padding:8px 16px 0">Used today: ${M.fmt(c.limits.usedTodayMinor, 'EUR')}
        of ${M.fmt(d.daily, 'EUR')} · resets at midnight</div></div>`;
    if (none) out += U.banner({ tone: 'danger', icon: 'warning',
      text: 'With nothing selected, this app loses all access. Disconnect it instead?',
      cta: 'Disconnect', act: 'dlg:DLG-019', arg: c.id });
    out += `<div class="inp-hint" style="padding:0 16px 24px">Changes apply immediately.
      Permissions can only be narrowed here — widening needs a fresh authorization from the app.</div>`;
    return out;
  };

  /* ══ AI-006 · AI activity ══════════════════════════════ */
  S['AI-006'] = function (st) {
    const filter = st.ctx.id || 'all';
    const conns = M.D.AI_CONNECTIONS.filter(c => c.status !== 'REVOKED');
    let list = M.D.AI_ACTIVITY.slice();
    if (filter !== 'all') list = list.filter(a => a.connectionId === filter);
    list.sort((a, b) => b.at.localeCompare(a.at));
    const blocked = list.filter(a => a.outcome === 'BLOCKED').length;

    let out = U.header({ title: 'AI activity', back: 'back' });
    if (conns.length > 1) out += U.chips(
      [{ value: 'all', label: 'All' }, ...conns.map(c => ({ value: c.id, label: c.clientName }))],
      filter, 'ai-filter');
    if (!list.length) return out + U.empty({ icon: 'sparkle',
      title: filter === 'all' ? 'No AI activity yet' : 'Nothing from this app',
      body: 'When a connected app records or changes something, it will show up here.',
      ctaLabel: filter === 'all' ? null : 'Show all', ctaAct: 'ai-filter', ctaArg: 'all' });

    out += `<div class="strip">${list.length} changes in the last 30 days${blocked ? ' · ' + blocked + ' blocked attempts' : ''}</div>`;
    const groups = {};
    list.forEach(a => { const d = a.at.slice(0, 10); (groups[d] = groups[d] || []).push(a); });
    Object.keys(groups).sort().reverse().forEach(d => {
      out += `<div class="grp-head"><span>${M.dateLabel(d)}</span></div>
        <div class="sec" style="margin-bottom:8px">${U.card(groups[d].map(aiActRow).join(''))}</div>`;
    });
    out += `<div class="inp-hint" style="padding:0 16px 20px;text-align:center">
      Reading your data isn't listed here — only changes.</div>`;
    return out;
  };

  /* ══ AI-007 · pending approvals ════════════════════════ */
  S['AI-007'] = function (st) {
    const list = M.D.AI_APPROVALS.filter(a => a.state === 'PENDING');
    let out = U.header({ title: 'Approvals', back: 'back' });
    if (!list.length) return out + U.empty({ icon: 'check', title: 'Nothing to approve',
      body: 'When a connected app asks to do something that needs your say-so, it will appear here.' });
    out += U.banner({ tone: 'info', icon: 'shield',
      text: 'Some actions need your approval here rather than in chat.' });
    list.forEach(a => {
      out += `<div class="approval">
        <div class="approval-head">
          <span class="conn-logo" style="width:34px;height:34px;font-size:14px">${esc(a.client[0])}</span>
          <span style="font-size:14px;font-weight:600">${esc(a.client)}</span>
          <span class="countdown">Expires in 24 min</span>
        </div>
        <div style="font-size:16px;font-weight:600;margin-bottom:12px">${esc(a.summary)}</div>
        ${a.detail.map(([k, v]) => `<div class="kv" style="padding:9px 0;border-bottom:1px solid var(--pk-border-subtle)">
          <span class="kv-k">${esc(k)}</span><span class="kv-v">${esc(v)}</span></div>`).join('')}
        <div class="note note--info" style="margin:12px 0 0">${a.impact}</div>
        ${a.reason ? `<div style="font-size:12px;color:var(--pk-text-tertiary);margin-top:10px;font-style:italic">
          "${esc(a.reason)}"</div>` : ''}
        <div style="margin-top:14px">
          ${U.btn('Approve', 'primary', 'approval-approve', { arg: a.id })}
          <div style="height:8px"></div>
          ${U.btn('Reject', 'danger-text', 'dlg:DLG-022', { arg: a.id })}
        </div></div>`;
    });
    return out;
  };

  /* ══ ONB-001..006 · onboarding ═════════════════════════ */
  function onbShell(step, body, foot) {
    const dots = step >= 2 && step <= 4
      ? `<div class="onb-dots">${[2,3,4].map(i => `<i class="${i === step ? 'is-on' : ''}"></i>`).join('')}</div>` : '';
    return `<div class="onb">${dots}<div class="onb-body">${body}</div><div class="onb-foot">${foot}</div></div>`;
  }
  S['ONB-001'] = function () {
    return onbShell(1, `<div class="onb-art" style="margin-top:40px"><div class="hero-blob"></div></div>
      <h1 class="onb-title" style="text-align:center">Welcome to Pockito</h1>
      <p class="onb-sub" style="text-align:center">Track your own money, and split what you share —
        without entering anything twice.</p>`,
      U.btn('Get started', 'primary', 'onb-next'));
  };
  S['ONB-002'] = function (st) {
    const d = st.onb;
    return onbShell(2, `<h1 class="onb-title">Where are you?</h1>
      <p class="onb-sub">This sets your default currency. You can add accounts in any currency later.</p>
      ${U.card(
        U.field({ icon: 'currency', label: 'Country', value: esc(d.countryName), act: 'onb-country' }) +
        U.field({ icon: 'currency', label: 'Default currency',
          value: M.cur(d.currency).symbol + ' · ' + d.currency + ' · ' + esc(M.cur(d.currency).name),
          act: 'open-picker:onb-currency' }))}
      <div class="inp-hint" style="padding:10px 4px 0">Net worth, spending and budgets are shown in this currency.
        Your accounts and spaces can each use their own — Pockito converts for totals only.</div>
      <div style="display:flex;gap:10px;align-items:flex-start;margin-top:20px">
        <span style="color:var(--pk-brand-primary);flex:none">${U.icon('currency','pk-icon--sm')}</span>
        <span style="font-size:12.5px;color:var(--pk-text-secondary);line-height:1.5">
          Travelling or paid in more than one currency? You can add accounts in any currency later,
          and share expenses across them.</span></div>`,
      U.btn('Continue', 'primary', 'onb-next'));
  };
  S['ONB-003'] = function (st) {
    const d = st.onb;
    const types = ['CASH','BANK','CARD','SAVINGS','DIGITAL','OTHER'];
    return onbShell(3, `<h1 class="onb-title">Add your first account</h1>
      <p class="onb-sub">This is where your money lives — a bank account, cash, or a card.
        You can add more later.</p>
      <div class="chips" style="padding-left:0;padding-right:0;flex-wrap:wrap">
        ${types.map(t => `<button class="chip" aria-pressed="${d.accType === t}" data-act="onb-acctype"
          data-arg="${t}">${t[0] + t.slice(1).toLowerCase()}</button>`).join('')}</div>
      <div style="margin-top:8px"><label class="inp-label">Account name</label>
        <input class="inp" value="${esc(d.accName)}" data-live="onb-accname"></div>
      <div style="margin-top:14px"><label class="inp-label">Current balance (${d.currency})</label>
        <input class="inp" type="number" step="any" value="${d.accBalance}" data-live="onb-accbalance">
        <div class="inp-hint">How much is in it right now. Pockito tracks changes from here.</div></div>`,
      U.btn('Continue', 'primary', 'onb-next', { disabled: !st.onb.accName.trim() }));
  };
  S['ONB-004'] = function (st) {
    const d = st.onb;
    const types = [['COUPLE','Couple'],['HOUSEHOLD','Household'],['TRIP','Trip'],['FAMILY','Family'],['OTHER','Other']];
    return onbShell(4, `<h1 class="onb-title">Share expenses with someone?</h1>
      <p class="onb-sub">A space is for money you share — with a partner, flatmate, or on a trip.
        Pockito works out who owes whom.</p>
      ${d.wantSpace ? `
        <div class="chips" style="padding-left:0;padding-right:0;flex-wrap:wrap">
          ${types.map(([v, l]) => `<button class="chip" aria-pressed="${d.spaceType === v}"
            data-act="onb-spacetype" data-arg="${v}">${l}</button>`).join('')}</div>
        <div style="margin-top:8px"><label class="inp-label">Space name</label>
          <input class="inp" value="${esc(d.spaceName)}" data-live="onb-spacename"></div>
        <div style="margin-top:14px">${U.card(U.field({ icon: 'currency', label: 'Space currency',
          value: d.spaceCurrency + ' · ' + esc(M.cur(d.spaceCurrency).name), act: 'open-picker:onb-space-currency' }))}</div>
        <div class="inp-hint" style="padding:10px 4px 0">All shared expenses in this space use this currency.
          Members can pay from an account in any currency.</div>`
      : `<div class="onb-art"><div style="display:flex;gap:-8px;align-items:center">
          ${U.avatar('u_me', 56)}<span style="margin-left:-12px">${U.avatar('u_mira', 56)}</span></div></div>`}`,
      d.wantSpace
        ? U.btn('Create space', 'primary', 'onb-create-space', { disabled: !d.spaceName.trim() }) +
          '<div style="height:8px"></div>' + U.btn('Not now', 'tertiary', 'onb-skip-space')
        : U.btn('Create a space', 'primary', 'onb-want-space') +
          '<div style="height:8px"></div>' + U.btn('Not now', 'tertiary', 'onb-skip-space'));
  };
  S['ONB-005'] = function (st) {
    const url = 'pockito.app/i/' + (st.onb.token || 'new8fK');
    return onbShell(5, `<div style="text-align:center;padding-top:24px">
      <div style="color:var(--pk-balance-owed);display:grid;place-items:center;margin-bottom:14px">
        ${U.icon('check','pk-icon--lg')}</div>
      <h1 class="onb-title">"${esc(st.onb.spaceName)}" is ready</h1>
      <p class="onb-sub">Invite the person you share with. They'll see shared expenses and balances.</p>
      <div class="link-card"><span class="link-url">${esc(url)}</span>
        <button class="ico-btn" data-act="copy-link" data-arg="${esc(url)}" style="width:32px;height:32px"
          aria-label="Copy">${U.icon('link','pk-icon--sm')}</button></div>
      <div style="font-size:11.5px;color:var(--pk-text-tertiary)">Expires in 7 days</div></div>`,
      U.btn('Share link', 'primary', 'share-link', { arg: url }) + '<div style="height:8px"></div>' +
      U.btn('Copy link', 'secondary', 'copy-link', { arg: url }) + '<div style="height:12px"></div>' +
      U.btn('Done', 'tertiary', 'onb-next'));
  };
  S['ONB-006'] = function (st) {
    return onbShell(6, `<div style="text-align:center;padding-top:60px">
      <div style="width:84px;height:84px;border-radius:50%;background:var(--pk-success-surface);
        color:var(--pk-success);display:grid;place-items:center;margin:0 auto 20px">
        ${U.icon('check','pk-icon--lg')}</div>
      <h1 class="onb-title">You're all set</h1>
      <p class="onb-sub">${st.onb.createdSpace
        ? `Tap ＋ any time to add an expense. Turn on "Share this" to split it with ${esc(st.onb.spaceName)}.`
        : 'Tap ＋ any time to add an expense, income, or a transfer.'}</p></div>`,
      U.btn('Start using Pockito', 'primary', 'onb-finish'));
  };

  /* ══ AUTH-001..003 ═════════════════════════════════════ */
  S['AUTH-001'] = function () {
    return `<div class="onb" style="background:var(--pk-brand-primary);margin:-52px -0 0;
      position:absolute;inset:-52px 0 0;display:grid;place-items:center">
      <div style="text-align:center"><div class="hero-blob" style="background:rgba(255,255,255,.16)"></div>
        <div style="color:#fff;font-size:22px;font-weight:800;margin-top:16px;letter-spacing:-.02em">Pockito</div></div></div>`;
  };
  S['AUTH-002'] = function () {
    return `<div class="onb">
      <div class="onb-body" style="display:flex;flex-direction:column;justify-content:center">
        <div style="text-align:center;margin-bottom:32px">
          <div class="hero-blob"></div>
          <div style="font-size:26px;font-weight:800;margin-top:14px;letter-spacing:-.025em">Pockito</div>
          <p class="onb-sub" style="margin-top:8px">Your money and our money, in one place.</p>
        </div>
        ${[['wallet','Track accounts, spending and subscriptions'],
           ['spaces','Split expenses with the people you share with'],
           ['check','Enter it once — Pockito does the rest']].map(([ic, t]) =>
          `<div style="display:flex;gap:12px;align-items:center;margin-bottom:16px">
            <span style="color:var(--pk-brand-primary)">${U.icon(ic,'pk-icon--sm')}</span>
            <span style="font-size:14px;color:var(--pk-text-secondary)">${t}</span></div>`).join('')}
      </div>
      <div class="onb-foot">${U.btn('Continue', 'primary', 'auth-signin')}
        <div class="inp-hint" style="text-align:center;margin-top:10px">
          By continuing you agree to our Terms and Privacy Policy.</div></div></div>`;
  };
  S['AUTH-003'] = function () {
    return `<div class="onb"><div class="onb-body" style="display:grid;place-items:center;align-content:center">
      <div style="text-align:center">
        <div style="width:64px;height:64px;border-radius:50%;background:var(--pk-danger-surface);
          color:var(--pk-danger);display:grid;place-items:center;margin:0 auto 16px">${U.icon('warning','pk-icon--lg')}</div>
        <h1 class="onb-title">Couldn't sign you in</h1>
        <p class="onb-sub">Check your connection and try again.</p></div></div>
      <div class="onb-foot">${U.btn('Try again', 'primary', 'auth-retry')}
        <div style="height:8px"></div>${U.btn('Get help', 'tertiary', 'noop-external')}</div></div>`;
  };

})();
