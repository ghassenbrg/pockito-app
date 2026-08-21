/* ============================================================
   Screens — shared finance
   SPACE-001..014 · SETL-001..007
   ============================================================ */
(function () {
  const M = window.Domain, U = window.UI, S = window.Screens;
  const esc = U.esc;

  /* ══ SPACE-001 · spaces ════════════════════════════════ */
  S['SPACE-001'] = function (st) {
    const spaces = M.activeSpaces();
    const arch = M.archivedSpaces();
    const shared = M.sharedSummary();
    const invite = M.D.INCOMING_INVITE;

    let out = U.header({ title: 'Spaces', actions: spaces.length
      ? [{ icon: 'plus', label: 'Create space', onClick: 'open-sheet:SPACE-005' }] : [] });

    if (invite && invite.status === 'PENDING') out += U.banner({
      tone: 'info', icon: 'person-add', act: 'go:SPACE-009',
      text: `<b>${esc(invite.invitedByName)}</b> invited you to ${esc(invite.spaceName)}`,
      cta: 'Review'
    });

    if (!spaces.length) {
      out += U.empty({
        icon: 'spaces', title: 'Share expenses with someone',
        body: 'Create a space for a partner, flatmate, or a trip. Record who paid, and Pockito works out who owes whom.',
        ctaLabel: 'Create a space', ctaVariant: 'primary', ctaAct: 'open-sheet:SPACE-005',
        secondary: '<p style="font-size:11.5px;margin-top:16px">Got an invite link? Open it to join.</p>'
      });
      return out;
    }

    const settledAll = !shared.owed && !shared.owe;
    out += `<div class="sec">${U.card(settledAll
      ? `<div style="padding:18px;text-align:center">
          <span style="color:var(--pk-balance-owed)">${U.icon('check','pk-icon--lg')}</span>
          <div style="font-size:16px;font-weight:600;margin-top:6px">Everything's settled</div></div>`
      : `<div class="grid2">
          <div><div class="stat-l">You're owed</div>
            <div class="stat-v money ${shared.owed ? 'pos' : 'muted'}">${M.fmt(shared.owed, shared.currency)}</div></div>
          <div><div class="stat-l">You owe</div>
            <div class="stat-v money ${shared.owe ? 'owe' : 'muted'}">${M.fmt(shared.owe, shared.currency)}</div></div>
        </div>`)}</div>`;

    spaces.forEach(s => {
      const n = M.myBalance(s.id);
      const splits = M.spaceSplits(s.id);
      const total = splits.reduce((a, x) => a + x.totalMinor, 0);
      const solo = s.members.length < 2;
      const pending = M.D.SETTLEMENTS.find(x => x.spaceId === s.id && x.status === 'PROPOSED' && x.toUserId === M.ME);
      out += `<div class="sec">
        <div class="card">
          <button style="display:block;width:100%;text-align:left;background:none;border:0;padding:16px;
              cursor:pointer;font-family:var(--pk-font-sans);color:var(--pk-text-primary)"
              data-act="go:SPACE-002" data-arg="${s.id}">
            <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:14px">
              <div style="display:flex;gap:11px;align-items:center">
                ${U.mark(s.icon, s.colorIdx, 44)}
                <div><div style="font-size:16px;font-weight:700">${esc(s.name)}</div>
                  <div style="font-size:12px;color:var(--pk-text-tertiary);margin-top:2px">
                    ${s.type[0] + s.type.slice(1).toLowerCase()} · ${s.currency}</div></div>
              </div>
              ${U.avatarStack(s.members.map(m => m.userId), 28)}
            </div>
            ${solo ? `<div style="font-size:13px;color:var(--pk-text-tertiary)">Just you — invite someone to start splitting</div>`
              : `<div class="stat-l">${n > 0 ? "You're owed" : n < 0 ? 'You owe' : 'All settled'}</div>
                 <div class="stat-v money ${n > 0 ? 'pos' : n < 0 ? 'owe' : 'muted'}" style="font-size:26px">
                   ${n ? M.fmt(Math.abs(n), s.currency) : '✓'}</div>`}
            <div style="font-size:11.5px;color:var(--pk-text-tertiary);margin-top:10px" class="money">
              ${splits.length} expenses · ${M.fmt(total, s.currency)} total</div>
          </button>
          ${solo ? U.btn('Invite someone', 'secondary', 'open-sheet:SPACE-008', { arg: s.id, cls: 'btn--sm', block: false }) : ''}
          ${pending ? `<div class="banner banner--shared" style="margin:0;border-radius:0;border:0;border-top:1px solid var(--pk-shared-border)"
              data-act="open-sheet:SETL-006" data-arg="${pending.id}">
            <span class="banner-ico">${U.icon('settle','pk-icon--sm')}</span>
            <span class="banner-txt">${esc(M.userName(pending.fromUserId))} says she paid you
              ${M.fmt(pending.amountMinor, pending.currency)}</span>
            <span class="banner-cta">Review</span></div>` : ''}
        </div></div>`;
    });

    if (arch.length) out += `<div class="sec">${U.card(U.row({
      title: `Archived (${arch.length})`, act: 'go:SPACE-013', chevron: true }))}</div>`;
    return out;
  };

  /* ══ SPACE-013 · archived spaces ═══════════════════════ */
  S['SPACE-013'] = function () {
    return U.header({ title: 'Archived spaces', back: 'back' })
      + `<div class="strip" style="padding-top:0">Archived spaces are read-only. Their expenses and balances are kept.</div>`
      + `<div class="sec">${U.card(M.archivedSpaces().map(s => U.row({
          lead: U.mark(s.icon, s.colorIdx, 44), title: esc(s.name),
          sub: s.type[0] + s.type.slice(1).toLowerCase() + ' · ' + U.pill('Archived', 'neutral'),
          extra: U.btn('Restore', 'tertiary', 'restore-space', { block: false, arg: s.id, cls: 'btn--sm' }),
          act: 'go:SPACE-002', arg: s.id
        })).join(''))}</div>`;
  };

  /* ══ SPACE-002 · space detail (+003/004 tabs) ══════════ */
  S['SPACE-002'] = function (st) {
    const s = M.space(st.ctx.id);
    if (!s) return U.errorState('This space is no longer available', 'back');
    const scope = st.balanceScope || 'cycle';
    const n = M.myBalance(s.id, scope);
    const plan = M.settlementPlan(s.id, scope);
    const mine = plan.find(p => p.fromUserId === M.ME || p.toUserId === M.ME);
    const solo = s.members.length < 2;
    const archived = s.status === 'ARCHIVED';
    const budgets = M.D.BUDGETS.filter(b => b.spaceId === s.id);
    const pending = M.D.SETTLEMENTS.find(x => x.spaceId === s.id && x.status === 'PROPOSED');
    const tab = st.spaceTab || 'expenses';

    let out = U.header({
      title: esc(s.name), back: 'back',
      subtitle: s.type[0] + s.type.slice(1).toLowerCase() + ' · ' + s.members.length + ' members · ' + s.currency,
      actions: [
        { html: `<button class="ico-btn" data-act="go:SPACE-007" data-arg="${s.id}" style="width:auto;padding:0 6px"
            aria-label="Members">${U.avatarStack(s.members.map(m => m.userId), 26)}</button>` },
        { icon: 'more', label: 'More', onClick: 'menu:space' }
      ]
    });

    if (archived) out += U.banner({ tone: 'neutral', icon: 'info', text: 'This space is archived. It\'s read-only.' });
    if (pending && pending.toUserId === M.ME) out += U.banner({
      tone: 'warning', icon: 'settle', act: 'open-sheet:SETL-006', arg: pending.id,
      text: `<b>${esc(M.userName(pending.fromUserId))}</b> says she paid you ${M.fmt(pending.amountMinor, pending.currency)}`,
      cta: 'Review' });

    /* balance card — the anchor */
    if (solo) {
      out += `<div class="hero" style="text-align:center">
        <div style="opacity:.9;display:grid;place-items:center;margin-bottom:8px">${U.icon('spaces','pk-icon--lg')}</div>
        <div style="font-size:17px;font-weight:600">You're the only one here</div>
        <div class="hero-sub" style="margin-bottom:16px">Invite someone to start splitting expenses.</div>
        ${U.btn('Invite someone', 'accent', 'open-sheet:SPACE-008', { arg: s.id })}
      </div>`;
    } else {
      const dir = n > 0 ? (mine ? esc(M.userName(mine.fromUserId)) + ' owes you' : "You're owed")
        : n < 0 ? (mine ? 'You owe ' + esc(M.userName(mine.toUserId)) : 'You owe')
        : "Everyone's settled";
      out += `<div class="hero" style="text-align:center">
        <div style="display:flex;justify-content:flex-end;margin-bottom:4px">
          <button class="chip-mini" data-act="toggle-scope">
            ${scope === 'cycle' ? 'Since you last settled' : 'All time'} ${U.icon('chevron-down','pk-icon--xs')}</button></div>
        <div class="hero-label">${dir}</div>
        ${n ? `<div class="hero-amt" style="cursor:${s.members.length > 2 ? 'pointer' : 'default'}"
                 ${s.members.length > 2 ? 'data-act="open-sheet:SPACE-012"' : ''}>${M.fmt(Math.abs(n), s.currency)}</div>`
            : `<div style="display:grid;place-items:center;margin:8px 0">${U.icon('check','pk-icon--lg')}</div>`}
        <div class="hero-sub">${n
          ? (s.members.length > 2 ? 'Across ' + (s.members.length - 1) + ' people · tap for details'
             : 'From ' + M.spaceSplits(s.id).length + ' shared expenses')
          : 'Nothing outstanding'}</div>
        ${n && !archived ? '<div style="margin-top:16px">' + U.btn('Settle up', 'accent', 'go:SETL-001', { arg: s.id }) + '</div>'
          : '<div style="margin-top:12px">' + U.btn('Settlement history', 'tertiary', 'go:SETL-004', { arg: s.id }) + '</div>'}
      </div>`;
    }

    /* budget */
    if (budgets.length) {
      const b = budgets[0], bs = M.budgetStatus(b, st.month);
      out += `<div class="sec">${U.sectionHead('Budget', budgets.length > 1 ? 'See all' : null, 'go:BUD-001')}
        ${U.card(S._budgetBlock(b, bs))}</div>`;
    } else if (!archived) {
      out += `<div class="sec">${U.card(U.row({
        lead: U.mark('budget', 4), title: 'Add a budget for this space',
        sub: 'Track what everyone spends together', act: 'open-sheet:BUD-003', arg: 'space:' + s.id, chevron: true }))}</div>`;
    }

    /* tabs */
    out += U.tabs([{ value: 'expenses', label: 'Expenses' }, { value: 'activity', label: 'Activity' }], tab, 'space-tab');
    out += tab === 'expenses' ? S['SPACE-003'](st, s) : S['SPACE-004'](st, s);
    return out;
  };

  /* ══ SPACE-003 · expenses tab ══════════════════════════ */
  S['SPACE-003'] = function (st, s) {
    s = s || M.space(st.ctx.id);
    const f = st.spaceFilters || {};
    const rows = M.spaceSplits(s.id, f);
    const all = M.spaceSplits(s.id);
    const total = rows.reduce((a, x) => a + x.totalMinor, 0);
    const mineTotal = rows.reduce((a, x) => {
      const mm = x.shares.find(y => y.userId === M.ME); return a + (mm ? mm.amountMinor : 0); }, 0);
    const nF = (f.payers && f.payers.length ? 1 : 0) + (f.categoryIds && f.categoryIds.length ? 1 : 0);

    let out = `<div style="display:flex;align-items:center;gap:8px;padding:0 16px 10px">
      <div class="chips" style="padding:0;flex:1">
        ${[['all','All'],['unsettled','Unsettled'],['settled','Settled']].map(([v, l]) =>
          `<button class="chip" aria-pressed="${(f.status || 'all') === v}" data-act="space-status" data-arg="${v}">${l}</button>`).join('')}
      </div>
      <button class="ico-btn" data-act="open-sheet:SPACE-014" aria-label="Filters" style="position:relative">
        ${U.icon('filter')}${nF ? `<span class="filter-badge">${nF}</span>` : ''}</button></div>`;

    if (!all.length) return out + U.empty({
      icon: 'receipt', title: 'No shared expenses yet',
      body: `Add an expense and choose ${s.name} to split it.`,
      ctaLabel: 'Add expense', ctaAct: 'open-add-space', ctaArg: s.id });

    out += `<div class="strip">${rows.length} expenses · ${M.fmt(total, s.currency)} total ·
      your share ${M.fmt(mineTotal, s.currency)}</div>`;
    out += `<div class="sec">${U.card(rows.length ? rows.map(x => U.splitRow(x)).join('')
      : U.inlineEmpty('No expenses match these filters.', 'Show all', 'space-clear-filters'))}</div>`;
    return out;
  };

  /* ══ SPACE-004 · activity tab ══════════════════════════ */
  S['SPACE-004'] = function (st, s) {
    s = s || M.space(st.ctx.id);
    const evs = M.D.SPACE_ACTIVITY.filter(e => e.spaceId === s.id);
    if (!evs.length) return U.empty({ icon: 'activity', title: 'Nothing yet',
      body: 'Activity in this space will show up here.' });
    const glyph = { EXPENSE_ADDED: ['receipt', 2], SETTLEMENT: ['settle', 1],
      MEMBER_JOINED: ['person-add', 1], MEMBER_LEFT: ['person', 10], BUDGET: ['budget', 4] };
    return `<div class="strip">${evs.length} events</div><div class="sec">${U.card(evs.map(e => {
      const g = glyph[e.type] || ['info', 10];
      return U.row({
        lead: U.mark(g[0], g[1]),
        title: `<b>${esc(M.userName(e.actor))}</b> ${esc(e.text)}` + (e.via
          ? ` <span style="color:var(--pk-text-tertiary);font-weight:400">via ${esc(e.via)}</span>` : ''),
        sub: M.relTime(e.at),
        value: e.amountMinor ? U.money(e.amountMinor, e.currency) : '',
        act: e.target ? (e.target.screen === 'SETL-005' ? 'open-sheet:SETL-005' : 'go:' + e.target.screen) : null,
        arg: e.target ? e.target.id : null
      });
    }).join(''))}</div>`;
  };

  /* ══ SPACE-014 · expense filters ═══════════════════════ */
  S['SPACE-014'] = function (st) {
    const s = M.space(st.ctx.id);
    if (!s) return U.goneSheet('This space');
    const d = st.spaceFilterDraft || {};
    const chip = (l, on, act, arg) =>
      `<button class="chip" aria-pressed="${on}" data-act="${act}" data-arg="${esc(arg)}">${esc(l)}</button>`;
    const cats = [...new Set(M.spaceSplits(s.id).map(x => x.categoryId))].map(M.category).filter(Boolean);
    return U.sheet({ title: 'Filters', leftLabel: 'Cancel', size: 'mid',
      body: `<div class="sec" style="margin-top:14px"><div class="stat-l">Paid by</div>
          <div class="chips" style="padding-left:0;padding-right:0">
            ${chip('Anyone', !(d.payers || []).length, 'sf-payer', '')}
            ${s.members.map(m => chip(M.userName(m.userId), (d.payers || []).includes(m.userId), 'sf-payer', m.userId)).join('')}
          </div></div>
        <div class="sec" style="margin-bottom:24px"><div class="stat-l">Category</div>
          <div class="chips" style="padding-left:0;padding-right:0;flex-wrap:wrap">
            ${chip('All', !(d.categoryIds || []).length, 'sf-cat', '')}
            ${cats.map(c => chip(c.name, (d.categoryIds || []).includes(c.id), 'sf-cat', c.id)).join('')}
          </div></div>`,
      footer: `<div style="display:flex;gap:10px;align-items:center">
        ${U.btn('Clear all', 'tertiary', 'sf-clear', { block: false })}<div style="flex:1"></div>
        ${U.btn('Apply', 'primary', 'sf-apply', { block: false })}</div>` });
  };

  /* ══ SPACE-012 · balance breakdown ═════════════════════ */
  S['SPACE-012'] = function (st) {
    const s = M.space(st.ctx.id);
    if (!s) return U.goneSheet('This space');
    const plan = M.settlementPlan(s.id, st.balanceScope || 'cycle');
    const mineOwed = plan.filter(p => p.toUserId === M.ME);
    const mineOwe = plan.filter(p => p.fromUserId === M.ME);
    const others = plan.filter(p => p.fromUserId !== M.ME && p.toUserId !== M.ME);
    const n = M.myBalance(s.id, st.balanceScope || 'cycle');
    return U.sheet({ title: 'Balances', size: 'mid',
      body: `<div style="padding:16px;text-align:center;border-bottom:1px solid var(--pk-border-subtle)">
          <div class="stat-l">Your net position</div>
          <div class="detail-amt money ${n > 0 ? 'pos' : n < 0 ? 'owe' : 'muted'}" style="font-size:28px">
            ${M.fmt(Math.abs(n), s.currency)}</div>
          <div class="detail-sub">${st.balanceScope === 'lifetime' ? 'All time' : 'Since you last settled'}
            ${M.lastSettlementAt(s.id) ? ' · ' + M.dateLabel(M.lastSettlementAt(s.id)) : ''}</div></div>
        ${mineOwed.length ? `<div class="stat-l" style="padding:14px 16px 6px">You're owed</div>` +
          mineOwed.map(p => U.row({ lead: U.avatar(p.fromUserId, 36), title: esc(M.userName(p.fromUserId)),
            value: `<span class="money pos">${M.fmt(p.amountMinor, s.currency)}</span>` })).join('') : ''}
        ${mineOwe.length ? `<div class="stat-l" style="padding:14px 16px 6px">You owe</div>` +
          mineOwe.map(p => U.row({ lead: U.avatar(p.toUserId, 36), title: esc(M.userName(p.toUserId)),
            value: `<span class="money owe">${M.fmt(p.amountMinor, s.currency)}</span>` })).join('') : ''}
        ${others.length ? `<div class="stat-l" style="padding:14px 16px 6px">Between other members</div>` +
          others.map(p => U.row({ lead: U.avatar(p.fromUserId, 36),
            title: `${esc(M.userName(p.fromUserId))} owes ${esc(M.userName(p.toUserId))}`,
            value: `<span class="money muted">${M.fmt(p.amountMinor, s.currency)}</span>` })).join('') : ''}
        <div style="padding:16px">${U.btn('Settle up', 'primary', 'go:SETL-001', { arg: s.id })}</div>
        <div style="padding:0 16px 20px;font-size:11.5px;color:var(--pk-text-tertiary)">
          Balances are always in ${s.currency}, the space's currency. Payment can come from an account in any currency.</div>` });
  };

  /* ══ SPACE-010 · shared expense detail ═════════════════ */
  S['SPACE-010'] = function (st) {
    const x = M.split(st.ctx.id);
    if (!x || x.deleted) return U.header({ title: 'Shared expense', back: 'back' })
      + U.empty({ icon: 'warning', title: 'This expense is no longer available',
        body: 'It may have been deleted.', ctaLabel: 'Go back', ctaAct: 'back' });
    const s = M.space(x.spaceId), c = M.category(x.categoryId);
    const mine = x.shares.find(y => y.userId === M.ME);
    const others = x.shares.filter(y => y.userId !== M.ME);
    const isMine = x.payerUserId === M.ME;
    const canEdit = x.createdBy === M.ME && x.status !== 'SETTLED';
    const linked = M.D.TRANSACTIONS.find(t => t.splitId === x.id && !t.deleted);
    const rounding = M.roundingFor(x.totalMinor, x.method, x.shares.length);

    let out = U.header({ title: 'Shared expense', back: 'back', actions: [
      ...(canEdit ? [{ html: U.btn('Edit', 'tertiary', 'open-sheet:SPLIT-EDIT', { block: false, arg: x.id }) }] : []),
      { icon: 'more', label: 'More', onClick: 'menu:split' }
    ] });

    out += `<div class="detail-top">
      ${U.mark(c ? c.icon : 'receipt', c ? c.colorIdx : 10, 56)}
      <div class="detail-amt money" style="margin-top:12px">${M.fmt(x.totalMinor, x.currency)}</div>
      <div class="detail-title">${esc(x.title)}</div>
      <div class="detail-sub">${M.dateLong(x.occurredOn)}</div>
      ${x.status === 'SETTLED' ? '<div style="margin-top:8px">' + U.pill('Settled', 'success') + '</div>' : ''}
    </div>`;

    out += `<div class="sec">${U.card([
      ['Space', s ? `<button class="link" data-act="go:SPACE-002" data-arg="${s.id}">${esc(s.name)}</button>`
                  : '<span class="kv-gone">Deleted space</span>'],
      ['Paid by', esc(M.userName(x.payerUserId))],
      ['Category', c ? esc(c.name) : 'Uncategorised'],
      ['Split', S._methodLabel(x)],
      ...(x.source === 'mcp' ? [['Added via', esc(x.client || 'AI')]] : [])
    ].map(([k, v]) => `<div class="kv"><span class="kv-k">${k}</span><span class="kv-v">${v}</span></div>`).join(''))}</div>`;

    out += `<div class="sec">${U.sectionHead('Split', canEdit ? 'Edit split' : null, 'open-sheet:SPLIT-EDIT|' + x.id)}
      ${U.card(x.shares.map(y => U.row({
        lead: U.avatar(y.userId, 32),
        title: esc(M.userName(y.userId)) + (y.userId === x.payerUserId ? ' ' + U.pill('paid', 'shared') : ''),
        sub: x.method === 'PERCENTAGE' ? Math.round(y.amountMinor / x.totalMinor * 100) + '%'
          : (y.userId === x.payerUserId && rounding ? '+' + M.fmt(rounding, x.currency) + ' rounding' : ''),
        value: U.money(y.amountMinor, x.currency)
      })).join('') +
      `<div class="kv" style="border-top:1px solid var(--pk-border-subtle)">
        <span class="kv-k">Total</span><span class="kv-v money">${M.fmt(x.totalMinor, x.currency)}</span></div>`)}
    </div>`;

    const owed = others.reduce((a, y) => a + y.amountMinor, 0);
    out += `<div class="sec">${U.card(`<div style="padding:14px">
      <div style="font-size:14px;font-weight:500" class="${isMine ? 'money pos' : 'money owe'}">
        ${x.status === 'SETTLED' ? 'Settled' : isMine
          ? others.map(y => esc(M.userName(y.userId))).join(' and ') + ' ' + (others.length > 1 ? 'owe' : 'owes') + ' you ' + M.fmt(owed, x.currency)
          : 'You owe ' + esc(M.userName(x.payerUserId)) + ' ' + M.fmt(mine ? mine.amountMinor : 0, x.currency)}</div>
      <div style="font-size:11.5px;color:var(--pk-text-tertiary);margin-top:4px">From this expense</div>
    </div>`)}</div>`;

    if (linked) {
      out += `<div class="sec">${U.card(U.row({
        lead: U.mark('wallet', M.account(linked.fromAccountId).colorIdx),
        title: 'Paid from ' + esc(M.account(linked.fromAccountId).name),
        sub: linked.sourceCurrency
          ? `${M.fmt(linked.sourceAmountMinor, linked.sourceCurrency)} · rate ${(linked.exchangeRate || 0).toFixed(5)}`
          : 'This is the transaction on your account',
        value: `<span class="money">−${M.fmt(linked.amountMinor, linked.currency).replace('−','')}</span>`,
        act: 'go:TXN-002', arg: linked.id, chevron: true }))}</div>`;
      if (linked.sourceCurrency) out += U.note(
        `The debt is ${M.fmt(x.totalMinor, x.currency)} — the space's currency. You paid from a ${linked.currency} account, so ${M.fmt(linked.amountMinor, linked.currency)} left ${esc(M.account(linked.fromAccountId).name)} at the rate captured on ${M.dateLabel(x.occurredOn)}.`);
    } else if (isMine) {
      out += U.note('Paid in cash — no account was affected. The split still counts.', 'plain');
    } else {
      out += U.note(`Only ${esc(M.userName(x.createdBy))} can edit this expense.`, 'plain');
    }

    out += `<div class="meta">Added by ${esc(M.userName(x.createdBy))}${x.source === 'mcp' ? ' via ' + esc(x.client) : ''} · ${M.dateLabel(x.occurredOn)}</div>`;
    return out;
  };

  /* ══ SPACE-005 · create space ══════════════════════════ */
  S['SPACE-005'] = function (st) {
    const d = st.spaceDraft;
    if (d.step === 2) {
      const url = 'pockito.app/i/' + (d.token || 'new');
      return U.sheet({ title: 'Invite someone', leftLabel: '', size: 'auto',
        body: `<div style="padding:22px 20px 8px;text-align:center">
            <div style="color:var(--pk-balance-owed);display:grid;place-items:center;margin-bottom:12px">
              ${U.icon('check','pk-icon--lg')}</div>
            <div style="font-size:19px;font-weight:700">"${esc(d.name)}" is ready</div>
            <p style="font-size:13.5px;color:var(--pk-text-secondary);margin:8px 0 20px">
              Invite the person you share with, or do it later.</p>
            <div class="link-card"><span class="link-url">${esc(url)}</span>
              <button class="ico-btn" data-act="copy-link" data-arg="${esc(url)}" aria-label="Copy"
                style="width:32px;height:32px">${U.icon('link','pk-icon--sm')}</button></div>
            <div style="font-size:11.5px;color:var(--pk-text-tertiary);margin-bottom:18px">Expires in 7 days</div>
            ${U.btn('Share link', 'primary', 'share-link', { arg: url })}
            <div style="height:8px"></div>
            ${U.btn('Copy link', 'secondary', 'copy-link', { arg: url })}
            <div style="height:14px"></div>
            ${U.btn('Skip for now', 'tertiary', 'space-created-done')}
          </div>` });
    }
    const types = [['COUPLE','Couple'],['HOUSEHOLD','Household'],['TRIP','Trip'],['FAMILY','Family'],['OTHER','Other']];
    return U.sheet({
      title: 'New space', rightLabel: 'Create', rightAct: 'space-create',
      rightDisabled: !d.name.trim(), size: 'form',
      body: `<div class="chips" style="padding-top:14px">${types.map(([v, l]) =>
          `<button class="chip" aria-pressed="${d.type === v}" data-act="space-type" data-arg="${v}">${l}</button>`).join('')}</div>
        <div class="inp-wrap"><label class="inp-label">Space name</label>
          <input class="inp" value="${esc(d.name)}" data-live="space-name" placeholder="e.g. Flat"></div>
        ${U.card(
          U.field({ icon: 'currency', label: 'Space currency',
            value: d.currency + ' · ' + esc(M.cur(d.currency).name), act: 'open-picker:space-currency' }) +
          U.field({ icon: d.icon, label: 'Icon & colour',
            value: '<span style="display:inline-flex;vertical-align:middle">' + U.mark(d.icon, d.colorIdx, 28) + '</span>',
            act: 'open-picker:space-appearance' }), 'card--flush')}
        <div class="inp-hint" style="padding:12px 16px">Shared expenses in this space are denominated in this
          currency. Members can pay from an account in any currency — Pockito converts and records the rate.</div>
        <div class="inp-hint" style="padding:0 16px 20px">You can't change it once the space has expenses.</div>`
    });
  };

  /* ══ SPACE-006 · space settings ════════════════════════ */
  S['SPACE-006'] = function (st) {
    const s = M.space(st.ctx.id);
    if (!s) return U.gone('This space');
    const me = M.member(s.id, M.ME);
    const isOwner = !!me && me.role === 'OWNER';
    const hasExpenses = M.spaceSplits(s.id).length > 0;
    const soleOwner = s.members.filter(m => m.role === 'OWNER').length === 1 && isOwner;
    const ds = s.defaultSplit;
    const dsLabel = ds.method === 'NONE' ? 'Not set' : ds.method === 'EQUAL' ? 'Equally'
      : s.members.map(m => (ds.shares || {})[m.userId] || 0).join('/');

    let out = U.header({ title: 'Space settings', back: 'back' });
    if (!isOwner) out += U.banner({ tone: 'neutral', icon: 'info',
      text: 'Only the space owner can change these settings.' });

    out += `<div class="sec"><div class="stat-l">Details</div>${U.card(
      `<div class="inp-wrap"><label class="inp-label">Space name</label>
        <input class="inp" value="${esc(s.name)}" data-live="space-rename" ${isOwner ? '' : 'disabled'}></div>` +
      U.field({ icon: s.icon, label: 'Icon & colour',
        value: '<span style="display:inline-flex;vertical-align:middle">' + U.mark(s.icon, s.colorIdx, 28) + '</span>',
        act: isOwner ? 'open-picker:space-appearance-edit' : null }) +
      U.field({ icon: 'currency', label: 'Currency', value: s.currency + (hasExpenses ? ' · locked' : ''),
        act: hasExpenses ? 'locked-space-currency' : 'open-picker:space-currency-edit',
        trailing: hasExpenses ? U.icon('shield', 'pk-icon--sm chev') : undefined }))}
      ${hasExpenses ? '<div class="inp-hint" style="padding:8px 16px 0">Currency can\'t change once a space has expenses.</div>' : ''}
    </div>`;

    out += `<div class="sec"><div class="stat-l">Splitting</div>${U.card(
      U.field({ icon: 'transfer', label: 'Default split', value: dsLabel,
        act: isOwner ? 'open-sheet:SPACE-011' : null }))}
      <div class="inp-hint" style="padding:8px 16px 0">Used automatically for new shared expenses.</div></div>`;

    out += `<div class="sec"><div class="stat-l">People</div>${U.card(
      U.field({ icon: 'spaces', label: 'Members', value: s.members.length + ' members',
        act: 'go:SPACE-007', arg: s.id }))}</div>`;

    out += `<div class="sec"><div class="stat-l">Notifications</div>${U.card(
      U.toggleRow({ label: 'New expenses', on: s.notifications.expenses, act: 'space-notif', arg: 'expenses' }) +
      U.toggleRow({ label: 'Settlements', on: s.notifications.settlements, act: 'space-notif', arg: 'settlements' }) +
      U.toggleRow({ label: 'Space activity', on: s.notifications.activity, act: 'space-notif', arg: 'activity' }))}
      <div class="inp-hint" style="padding:8px 16px 0">These only affect this space.
        <button class="link" data-act="go:SET-004" style="font-size:11.5px">All notifications</button></div></div>`;

    out += `<div class="sec" style="margin-top:28px"><div class="stat-l" style="color:var(--pk-danger)">Danger zone</div>
      ${isOwner ? U.btn(s.status === 'ARCHIVED' ? 'Restore space' : 'Archive space', 'ghost',
        s.status === 'ARCHIVED' ? 'restore-space' : 'dlg:DLG-006', { arg: s.id }) : ''}
      <div style="height:8px"></div>
      ${isOwner ? U.btn('Delete space', 'danger-text', 'dlg:DLG-007', { arg: s.id }) : ''}
      ${!soleOwner ? U.btn('Leave space', 'danger-text', 'dlg:DLG-008', { arg: s.id }) : ''}
      ${soleOwner ? '<div class="inp-hint" style="text-align:center;margin-top:8px">You\'re the only owner. Delete or archive the space to leave it.</div>' : ''}
    </div>`;
    return out;
  };

  /* ══ SPACE-011 · default split ═════════════════════════ */
  S['SPACE-011'] = function (st) {
    const s = M.space(st.ctx.id);
    if (!s || !st.dsDraft) return U.goneSheet('This space');
    const d = st.dsDraft;
    const pctSum = s.members.reduce((a, m) => a + (+d.shares[m.userId] || 0), 0);
    const ok = d.method !== 'PERCENTAGE' || pctSum === 100;
    return U.sheet({ title: 'Default split', leftLabel: 'Cancel', rightLabel: 'Save',
      rightAct: 'ds-save', rightDisabled: !ok, size: 'auto',
      body: `<div class="inp-hint" style="padding:14px 16px">New shared expenses will use this automatically.
          You can still change any expense individually.</div>
        <div class="chips" style="padding-left:16px">
          ${[['NONE','Not set'],['EQUAL','Equally'],['PERCENTAGE','Percentage']].map(([v, l]) =>
            `<button class="chip" aria-pressed="${d.method === v}" data-act="ds-method" data-arg="${v}"
              ${v === 'PERCENTAGE' && s.members.length < 2 ? 'disabled' : ''}>${l}</button>`).join('')}
        </div>
        ${d.method === 'NONE' ? '<div class="inp-hint" style="padding:12px 16px 20px">Each new expense starts split equally.</div>' : ''}
        ${d.method === 'EQUAL' ? s.members.map(m => U.row({ lead: U.avatar(m.userId, 32),
            title: esc(M.userName(m.userId)),
            value: '<span class="money">' + Math.round(100 / s.members.length) + '%</span>' })).join('')
          + '<div class="inp-hint" style="padding:12px 16px 20px">Updates automatically when members join or leave.</div>' : ''}
        ${d.method === 'PERCENTAGE' ? s.members.map(m => `<div class="mrow">
            ${U.avatar(m.userId, 32)}
            <span class="row-body"><span class="row-title" style="font-size:14px">${esc(M.userName(m.userId))}</span></span>
            <input class="minp" style="width:72px" type="number" value="${d.shares[m.userId] || 0}"
              data-live="ds-pct" data-arg="${m.userId}"></div>`).join('')
          + `<div style="padding:12px 16px 20px;font-size:12.5px;font-weight:500;color:${ok ? 'var(--pk-balance-owed)' : 'var(--pk-danger)'}">
              ${ok ? '100% assigned' : (pctSum < 100 ? (100 - pctSum) + '% left to assign' : (pctSum - 100) + '% over')}</div>` : ''}`
    });
  };

  /* ══ SPACE-007 · members & invites ═════════════════════ */
  S['SPACE-007'] = function (st) {
    const s = M.space(st.ctx.id);
    if (!s) return U.gone('This space');
    const me = M.member(s.id, M.ME);
    const isOwner = !!me && me.role === 'OWNER';
    const soleOwner = s.members.filter(m => m.role === 'OWNER').length === 1 && isOwner;
    const invites = M.D.INVITES.filter(i => i.spaceId === s.id && i.status === 'PENDING');
    const net = M.memberBalances(s.id);

    let out = U.header({ title: 'Members', back: 'back', actions: isOwner
      ? [{ icon: 'person-add', label: 'Invite', onClick: 'open-sheet:SPACE-008' }] : [] });

    out += `<div class="sec"><div class="stat-l">Members (${s.members.length})</div>
      ${U.card(s.members.map(m => {
        const n = net[m.userId] || 0;
        const isMe = m.userId === M.ME;
        return U.row({
          lead: U.avatar(m.userId, 44),
          title: esc(M.userName(m.userId)),
          sub: m.role[0] + m.role.slice(1).toLowerCase() + ' · joined ' + M.dateLabel(m.joinedAt),
          value: isMe ? '' : (n < 0 ? `<span class="money pos">${M.fmt(-n, s.currency)}</span>`
            : n > 0 ? `<span class="money owe">${M.fmt(n, s.currency)}</span>`
            : '<span class="money muted">Settled</span>'),
          note: isMe ? '' : (n < 0 ? 'Owes you' : n > 0 ? 'You owe' : ''),
          act: 'open-sheet:MEMBER', arg: m.userId
        });
      }).join(''))}</div>`;

    if (invites.length) out += `<div class="sec"><div class="stat-l">Pending invites (${invites.length})</div>
      ${U.card(invites.map(i => U.row({
        lead: U.mark('person-add', 10),
        title: 'Invite link',
        sub: 'Sent ' + M.dateLabel(i.sentAt) + ' · expires ' + M.dateLabel(i.expiresAt),
        extra: isOwner ? U.btn('Revoke', 'danger-text', 'dlg:DLG-010', { block: false, arg: i.id, cls: 'btn--sm' }) : ''
      })).join(''))}</div>`;

    if (s.members.length < 2) out += U.empty({ icon: 'spaces', title: "It's just you in here",
      body: 'Invite someone to start splitting.', ctaLabel: 'Invite someone',
      ctaVariant: 'primary', ctaAct: 'open-sheet:SPACE-008' });

    if (!soleOwner) out += `<div class="sec">${U.btn('Leave space', 'danger-text', 'dlg:DLG-008', { arg: s.id })}</div>`;
    else out += `<div class="inp-hint" style="padding:8px 16px 20px;text-align:center">
      You're the only owner. Delete or archive the space to leave it.</div>`;
    return out;
  };

  /* ══ member sheet ══════════════════════════════════════ */
  S['MEMBER'] = function (st) {
    const s = M.space(st.ctx.id);
    const uid = st.sheetCtx && st.sheetCtx.id;
    const m = s && uid && M.member(s.id, uid);
    if (!m) return U.goneSheet('This member');
    const net = M.memberBalances(s.id)[uid] || 0;
    const isMe = uid === M.ME;
    const isOwner = M.member(s.id, M.ME).role === 'OWNER';
    const paid = M.spaceSplits(s.id).filter(x => x.payerUserId === uid);
    return U.sheet({ title: esc(M.userName(uid)), size: 'auto',
      body: `<div style="padding:20px;text-align:center">
          ${U.avatar(uid, 64)}
          <div style="font-size:18px;font-weight:700;margin-top:10px">${esc(M.userName(uid))}</div>
          <div style="margin-top:4px">${U.pill(m.role, 'neutral')}</div>
        </div>
        ${U.card([
          ['Joined', M.dateLong(m.joinedAt)],
          ...(isMe ? [] : [['Balance', net < 0
            ? `<span class="money pos">Owes you ${M.fmt(-net, s.currency)}</span>`
            : net > 0 ? `<span class="money owe">You owe ${M.fmt(net, s.currency)}</span>`
            : '<span class="money muted">Settled</span>']]),
          ['Expenses paid', paid.length + ' · ' + M.fmt(paid.reduce((a, x) => a + x.totalMinor, 0), s.currency)]
        ].map(([k, v]) => `<div class="kv"><span class="kv-k">${k}</span><span class="kv-v">${v}</span></div>`).join(''))}
        ${isOwner && !isMe ? `<div style="padding:16px">
          ${U.btn('Remove from space', 'danger-text', 'dlg:DLG-009', { arg: uid })}</div>` : '<div style="height:16px"></div>'}` });
  };

  /* ══ SPACE-008 · invite ════════════════════════════════ */
  S['SPACE-008'] = function (st) {
    const s = M.space((st.sheetCtx && st.sheetCtx.id) || st.ctx.id) || M.activeSpaces()[0];
    if (!s) return U.sheet({ title: 'Invite', size: 'auto',
      body: U.empty({ icon: 'spaces', title: 'No space to invite to',
        body: 'Create a space first.', ctaLabel: 'Close', ctaAct: 'close-sheet' }) });
    const url = 'pockito.app/i/' + s.id.slice(2) + 'K9z';
    return U.sheet({ title: 'Invite to ' + esc(s.name), size: 'auto',
      body: `<div style="padding:20px">
        <div style="display:grid;place-items:center;color:var(--pk-brand-primary);margin-bottom:12px">
          ${U.icon('link','pk-icon--lg')}</div>
        <p style="font-size:13.5px;color:var(--pk-text-secondary);text-align:center;margin:0 0 18px">
          Anyone with this link can join ${esc(s.name)} and see its shared expenses and balances.</p>
        <div class="link-card"><span class="link-url">${esc(url)}</span>
          <button class="ico-btn" data-act="copy-link" data-arg="${esc(url)}" aria-label="Copy"
            style="width:32px;height:32px">${U.icon('link','pk-icon--sm')}</button></div>
        <div style="font-size:11.5px;color:var(--pk-text-tertiary);text-align:center;margin-bottom:18px">Expires in 7 days</div>
        ${U.btn('Share link', 'primary', 'share-link', { arg: url })}
        <div style="height:8px"></div>
        ${U.btn('Copy link', 'secondary', 'copy-link', { arg: url })}
        <div style="height:12px"></div>
        ${U.btn('Done', 'tertiary', 'close-sheet')}
      </div>` });
  };

  /* ══ SPACE-009 · invite review ═════════════════════════ */
  S['SPACE-009'] = function (st) {
    const i = M.D.INCOMING_INVITE;
    if (i.status !== 'PENDING') return U.header({ title: '', back: 'back' })
      + U.empty({ icon: 'check', title: i.status === 'ACCEPTED' ? "You've joined" : 'Invite declined',
        body: 'Nothing more to do here.', ctaLabel: 'Go back', ctaAct: 'back' });
    return `<div class="onb">
      <div style="padding-top:12px"><button class="ico-btn" data-act="back" aria-label="Close">${U.icon('close')}</button></div>
      <div class="onb-body" style="text-align:center;padding-top:20px">
        ${U.mark('spaces', 6, 72)}
        <h1 class="onb-title" style="margin-top:16px">Join ${esc(i.spaceName)}</h1>
        <p class="onb-sub"><b>${esc(i.invitedByName)}</b> invited you to share expenses.</p>
        ${U.card([
          ['Type', i.spaceType[0] + i.spaceType.slice(1).toLowerCase()],
          ['Members', i.memberCount + ' people'],
          ['Currency', i.spaceCurrency],
          ['Created', M.dateLong(i.createdAt)]
        ].map(([k, v]) => `<div class="kv"><span class="kv-k">${k}</span><span class="kv-v">${v}</span></div>`).join(''))}
        <div style="text-align:left;margin-top:24px">
          ${[['activity', "You'll see all shared expenses and balances in this space"],
             ['spaces', 'Other members will see expenses you add here'],
             ['shield', 'Your personal accounts and transactions stay private']].map(([ic, t]) =>
            `<div style="display:flex;gap:11px;align-items:flex-start;margin-bottom:12px">
              <span style="color:var(--pk-brand-primary);flex:none">${U.icon(ic,'pk-icon--sm')}</span>
              <span style="font-size:13.5px;color:var(--pk-text-secondary);line-height:1.5">${t}</span></div>`).join('')}
        </div>
      </div>
      <div class="onb-foot">
        ${U.btn('Join space', 'primary', 'accept-invite')}
        <div style="height:8px"></div>
        ${U.btn('Decline', 'tertiary', 'decline-invite')}
      </div></div>`;
  };

  /* ══ SETL-001 · settle up ══════════════════════════════ */
  S['SETL-001'] = function (st) {
    const s = M.space(st.ctx.id);
    if (!s || !st.settleDraft) return U.gone('This space');
    const scope = st.balanceScope || 'cycle';
    const plan = M.settlementPlan(s.id, scope);
    const mine = plan.filter(p => p.fromUserId === M.ME || p.toUserId === M.ME);
    const others = plan.filter(p => p.fromUserId !== M.ME && p.toUserId !== M.ME);

    let out = U.header({ title: 'Settle up', back: 'back', subtitle: esc(s.name),
      actions: [{ icon: 'receipt', label: 'History', onClick: 'go:SETL-004' }] });

    if (!mine.length) return out + U.empty({ icon: 'check', title: "Everyone's settled",
      body: `Nothing to settle in ${s.name} right now.`,
      ctaLabel: 'Settlement history', ctaAct: 'go:SETL-004', ctaArg: s.id });

    const d = st.settleDraft;
    const iPay = d.fromUserId === M.ME;
    const outstanding = M.outstandingBetween(s.id, d.fromUserId, d.toUserId);
    const over = d.amount > outstanding;
    const acc = d.accountId ? M.account(d.accountId) : null;
    const crossCur = acc && acc.currency !== s.currency;

    out += `<div class="sec" style="margin-bottom:10px"><div class="stat-l">Suggested</div></div>`;
    mine.forEach(p => {
      const sel = p.fromUserId === d.fromUserId && p.toUserId === d.toUserId;
      out += `<div class="sec" style="margin-bottom:10px">
        <button class="card" style="width:100%;text-align:left;padding:15px;cursor:pointer;
            border-color:${sel ? 'var(--pk-brand-primary)' : 'var(--pk-border-subtle)'};
            border-width:${sel ? '1.5px' : '1px'};background:var(--pk-bg-surface);font-family:var(--pk-font-sans)"
            data-act="settle-pick" data-arg="${p.fromUserId}|${p.toUserId}|${p.amountMinor}">
          <div style="display:flex;align-items:center;justify-content:space-between">
            <div style="display:flex;align-items:center;gap:8px">
              ${U.avatar(p.fromUserId, 34)}<span style="color:var(--pk-text-tertiary)">${U.icon('chevron-right','pk-icon--sm')}</span>
              ${U.avatar(p.toUserId, 34)}</div>
            <span class="money" style="font-size:21px;font-weight:700">${M.fmt(p.amountMinor, s.currency)}</span>
          </div>
          <div style="font-size:12px;color:var(--pk-text-tertiary);margin-top:10px">
            ${esc(M.userName(p.fromUserId))} pay${p.fromUserId === M.ME ? '' : 's'} ${esc(M.userName(p.toUserId))}</div>
        </button></div>`;
    });
    if (others.length) out += `<div class="sec"><div class="stat-l">Between other members</div>
      ${U.card(others.map(p => U.row({ lead: U.avatar(p.fromUserId, 32),
        title: `${esc(M.userName(p.fromUserId))} → ${esc(M.userName(p.toUserId))}`,
        value: `<span class="money muted">${M.fmt(p.amountMinor, s.currency)}</span>` })).join(''))}
      <div class="inp-hint" style="padding:8px 16px 0">You can only record a payment you were part of.</div></div>`;

    out += `<div class="sec">${U.card(
      U.field({ icon: 'person', label: 'From', value: esc(M.userName(d.fromUserId)), act: 'open-picker:settle-from' }) +
      U.field({ icon: 'person', label: 'To', value: esc(M.userName(d.toUserId)), act: 'open-picker:settle-to' }) +
      `<div class="inp-wrap" style="border-top:1px solid var(--pk-border-subtle)">
        <label class="inp-label">Amount (${s.currency})</label>
        <input class="inp ${over ? 'is-error' : ''}" type="number" step="any"
          value="${d.amount / Math.pow(10, M.cur(s.currency).decimals)}" data-live="settle-amount">
        ${over ? `<div class="inp-err">That's more than ${esc(M.userName(d.fromUserId))} owes.
          Enter ${M.fmt(outstanding, s.currency)} or less.</div>` : ''}</div>` +
      U.field({ icon: 'wallet', label: iPay ? 'Paid from' : 'Received into',
        value: acc ? esc(acc.name) : 'Not recorded on an account', placeholder: !acc,
        act: 'open-picker:settle-account' }))}
      <div class="inp-hint" style="padding:8px 16px 0">${acc
        ? (crossCur
          ? `${M.fmt(d.amount, s.currency)} · about <b>${M.fmt(M.convert(d.amount, s.currency, acc.currency), acc.currency)}</b> will ${iPay ? 'leave' : 'be added to'} ${esc(acc.name)}. It won't count as spending.`
          : `${M.fmt(d.amount, s.currency)} will ${iPay ? 'leave' : 'be added to'} ${esc(acc.name)}. It won't count as spending — your share was counted when the expense was recorded.`)
        : 'Optional. Choose an account to record this on your balance too.'}</div></div>`;

    out += `<div class="sec" style="margin-top:20px">
      ${U.btn(iPay ? 'I paid this' : 'They paid me', 'primary', 'open-sheet:SETL-002', { disabled: over || !d.amount })}
      <div style="height:9px"></div>
      ${U.btn('Ask them to confirm', 'secondary', 'settle-request', { disabled: over || !d.amount })}
      ${mine.length + others.length > 1 ? '<div style="height:14px"></div>' +
        U.btn('Mark everything settled', 'tertiary', 'dlg:DLG-017', { arg: s.id }) : ''}
    </div>`;
    return out;
  };

  /* ══ SETL-002 · review settlement ══════════════════════ */
  S['SETL-002'] = function (st) {
    const s = M.space(st.ctx.id);
    if (!s || !st.settleDraft) return U.goneSheet('This space');
    const d = st.settleDraft;
    const iPay = d.fromUserId === M.ME;
    const acc = d.accountId ? M.account(d.accountId) : null;
    const before = M.myBalance(s.id, st.balanceScope || 'cycle');
    const after = before + (iPay ? d.amount : -d.amount);
    const req = st.settleMode === 'request';
    return U.sheet({ title: 'Review', leftLabel: 'Back', leftAct: 'close-sheet', size: 'auto',
      body: `<div style="padding:22px 20px 8px">
          <div style="display:flex;align-items:center;justify-content:center;gap:14px;margin-bottom:14px">
            ${U.avatar(d.fromUserId, 48)}<span style="color:var(--pk-text-tertiary)">${U.icon('chevron-right')}</span>
            ${U.avatar(d.toUserId, 48)}</div>
          <div class="detail-amt" style="text-align:center;font-size:30px">${M.fmt(d.amount, s.currency)}</div>
        </div>
        ${U.card([
          ['Space', s ? esc(s.name) : '<span class="kv-gone">Deleted space</span>'],
          ['Amount', `<span class="money">${M.fmt(d.amount, s.currency)}</span>`],
          [iPay ? 'Paid from' : 'Received into', acc
            ? esc(acc.name) + (acc.currency !== s.currency
              ? ` <span class="money">(${M.fmt(M.convert(d.amount, s.currency, acc.currency), acc.currency)})</span>` : '')
            : '<span style="color:var(--pk-text-tertiary)">Not recorded on an account</span>'],
          ['Status after saving', req ? 'Waiting for ' + esc(M.userName(iPay ? d.toUserId : d.fromUserId)) + ' to confirm'
            : 'Confirmed — balances update now']
        ].map(([k, v]) => `<div class="kv"><span class="kv-k">${k}</span><span class="kv-v">${v}</span></div>`).join(''))}
        <div class="note note--info" style="margin-top:14px">
          ${req ? "Balances won't change until they confirm."
            : `Your balance in ${esc(s.name)} goes from <b>${before > 0 ? "you're owed " + M.fmt(before, s.currency)
              : before < 0 ? 'you owe ' + M.fmt(-before, s.currency) : 'settled'}</b> to
              <b>${after > 0 ? "you're owed " + M.fmt(after, s.currency)
              : after < 0 ? 'you owe ' + M.fmt(-after, s.currency) : 'settled'}</b>.`}
          ${acc && !req ? `<br>${esc(acc.name)} goes from ${M.fmt(M.balance(acc.id), acc.currency)} to
            ${M.fmt(M.balance(acc.id) + (iPay ? -1 : 1) * (M.convert(d.amount, s.currency, acc.currency) || 0), acc.currency)}.` : ''}
        </div>
        <div style="padding:16px">${U.btn(req ? 'Send request' : 'Confirm payment', 'primary', 'settle-confirm')}</div>` });
  };

  /* ══ SETL-003 · settlement success ═════════════════════ */
  S['SETL-003'] = function (st) {
    const r = st.settleResult || {};
    const s = M.space(r.spaceId);
    const remaining = s ? M.myBalance(s.id) : 0;
    return `<div class="onb" style="text-align:center;justify-content:center">
      <div class="onb-body" style="display:grid;place-items:center;align-content:center">
        <div style="width:80px;height:80px;border-radius:50%;display:grid;place-items:center;
          background:${r.proposed ? 'var(--pk-warning-surface)' : 'var(--pk-success-surface)'};
          color:${r.proposed ? 'var(--pk-shared-strong)' : 'var(--pk-success)'};margin-bottom:20px">
          ${U.icon(r.proposed ? 'settle' : 'check', 'pk-icon--lg')}</div>
        <h1 class="onb-title">${r.proposed ? 'Request sent' : 'Settled up'}</h1>
        <p class="onb-sub" style="max-width:30ch">${r.proposed
          ? esc(r.otherName) + ' will get a notification to confirm ' + M.fmt(r.amount, r.currency) + '.'
          : (remaining ? M.fmt(Math.abs(remaining), s.currency) + ' still outstanding in ' + esc(s.name) + '.'
             : 'You and ' + esc(r.otherName) + ' are all square in ' + esc(s.name) + '.')}</p>
        <div class="card" style="padding:14px 18px;max-width:280px;width:100%">
          <div class="money" style="font-weight:600">${esc(r.fromName)} → ${esc(r.toName)} · ${M.fmt(r.amount, r.currency)}</div>
          ${r.accountName ? `<div style="font-size:12px;color:var(--pk-text-tertiary);margin-top:4px">Recorded on ${esc(r.accountName)}</div>` : ''}
          <div style="font-size:12px;color:var(--pk-text-tertiary);margin-top:4px">${M.dateLong(M.TODAY)}</div>
          ${r.proposed ? '<div style="margin-top:8px">' + U.pill('Awaiting confirmation', 'warning') + '</div>' : ''}
        </div>
      </div>
      <div class="onb-foot">
        ${U.btn('Done', 'primary', 'settle-done', { arg: r.spaceId })}
        <div style="height:8px"></div>
        ${U.btn('View history', 'tertiary', 'go:SETL-004', { arg: r.spaceId })}
      </div></div>`;
  };

  /* ══ SETL-004 · settlement history ═════════════════════ */
  S['SETL-004'] = function (st) {
    const s = M.space(st.ctx.id);
    if (!s) return U.gone('This space');
    const rows = M.D.SETTLEMENTS.filter(x => x.spaceId === s.id)
      .sort((a, b) => (b.settledAt || b.createdAt || '').localeCompare(a.settledAt || a.createdAt || ''));
    const pending = rows.filter(r => r.status === 'PROPOSED');
    const done = rows.filter(r => r.status !== 'PROPOSED');
    const total = done.filter(r => r.status === 'CONFIRMED').reduce((a, r) => a + r.amountMinor, 0);

    let out = U.header({ title: 'Settlement history', back: 'back', subtitle: esc(s.name) });
    if (!rows.length) return out + U.empty({ icon: 'settle', title: 'No settlements yet',
      body: 'When someone pays another back, it\'ll be recorded here.',
      ctaLabel: 'Settle up', ctaAct: 'go:SETL-001', ctaArg: s.id });

    out += `<div class="strip">${done.length} settlements · ${M.fmt(total, s.currency)} total</div>`;
    const rowFor = r => U.row({
      lead: U.mark('settle', r.status === 'CONFIRMED' ? 1 : r.status === 'PROPOSED' ? 4 : 10),
      title: `${esc(M.userName(r.fromUserId))} paid ${esc(M.userName(r.toUserId))}`,
      sub: M.dateLabel(r.settledAt || r.createdAt) + (r.note ? ' · ' + esc(r.note) : '')
        + (r.status !== 'CONFIRMED' ? ' ' + U.pill(r.status === 'PROPOSED' ? 'Awaiting confirmation' : 'Cancelled',
          r.status === 'PROPOSED' ? 'warning' : 'neutral') : ''),
      value: U.money(r.amountMinor, r.currency),
      act: 'open-sheet:SETL-005', arg: r.id });

    if (pending.length) out += `<div class="sec"><div class="stat-l">Pending</div>
      ${U.card(pending.map(rowFor).join(''))}</div>`;
    if (done.length) out += `<div class="sec">${U.card(done.map(rowFor).join(''))}</div>`;
    if (M.lastSettlementAt(s.id)) out += `<div class="inp-hint" style="padding:0 16px 12px;text-align:center">
      — Cycle closed ${M.dateLabel(M.lastSettlementAt(s.id))} —</div>`;
    out += `<div class="sec">${U.btn('New settlement', 'secondary', 'go:SETL-001', { arg: s.id })}</div>`;
    return out;
  };

  /* ══ SETL-005 · settlement detail ══════════════════════ */
  S['SETL-005'] = function (st) {
    const r = M.settlement(st.sheetCtx.id);
    if (!r) return U.sheet({ title: 'Settlement', body: U.empty({ icon: 'warning',
      title: 'Not found', body: 'This settlement no longer exists.' }) });
    const s = M.space(r.spaceId);
    const linked = M.D.TRANSACTIONS.find(t => t.settlementId === r.id && !t.deleted);
    const canCancel = r.status === 'PROPOSED';
    const needsMe = r.status === 'PROPOSED' && r.toUserId === M.ME;
    return U.sheet({ title: 'Settlement', size: 'auto',
      body: `<div style="padding:20px 20px 8px">
          <div style="display:flex;align-items:center;justify-content:center;gap:14px;margin-bottom:12px">
            ${U.avatar(r.fromUserId, 48)}<span style="color:var(--pk-text-tertiary)">${U.icon('chevron-right')}</span>
            ${U.avatar(r.toUserId, 48)}</div>
          <div class="detail-amt" style="text-align:center;font-size:28px">${M.fmt(r.amountMinor, r.currency)}</div>
          <div style="text-align:center;margin-top:8px">${U.pill(
            r.status === 'CONFIRMED' ? 'Confirmed' : r.status === 'PROPOSED' ? 'Awaiting confirmation' : 'Cancelled',
            r.status === 'CONFIRMED' ? 'success' : r.status === 'PROPOSED' ? 'warning' : 'neutral')}</div>
        </div>
        ${U.card([
          ['Space', s ? esc(s.name) : '<span class="kv-gone">Deleted space</span>'],
          ['Amount', `<span class="money">${M.fmt(r.amountMinor, r.currency)}</span>`],
          ['Recorded on', linked
            ? `<button class="link" data-act="go:ACC-002" data-arg="${linked.fromAccountId || linked.toAccountId}">
                ${esc(M.account(linked.fromAccountId || linked.toAccountId).name)}</button>`
            : '<span style="color:var(--pk-text-tertiary)">Not recorded on an account</span>'],
          ...(r.note ? [['Note', esc(r.note)]] : []),
          ['Recorded by', esc(M.userName(r.createdBy)) + ' · ' + M.dateLabel(r.settledAt || r.createdAt)],
          ...(r.confirmedBy ? [['Confirmed by', esc(M.userName(r.confirmedBy))]] : [])
        ].map(([k, v]) => `<div class="kv"><span class="kv-k">${k}</span><span class="kv-v">${v}</span></div>`).join(''))}
        ${needsMe ? `<div style="padding:16px">${U.btn('Review request', 'primary', 'open-sheet:SETL-006', { arg: r.id })}</div>`
          : canCancel ? `<div style="padding:16px">${U.btn('Cancel settlement', 'danger-text', 'dlg:DLG-011', { arg: r.id })}</div>`
          : '<div style="height:16px"></div>'}
        ${r.status === 'CONFIRMED' ? U.note('Settlements move money between people. They don\'t count as spending.') : ''}` });
  };

  /* ══ SETL-006 · confirm settlement request ═════════════ */
  S['SETL-006'] = function (st) {
    const r = M.settlement(st.sheetCtx && st.sheetCtx.id);
    if (!r || r.status !== 'PROPOSED') return U.sheet({ title: 'Confirm payment', size: 'auto',
      body: U.empty({ icon: 'check', title: 'Already handled',
        body: 'This request was already confirmed or cancelled.',
        ctaLabel: 'Close', ctaAct: 'close-sheet' }) });
    const s = M.space(r.spaceId);
    if (!s) return U.goneSheet('This space');
    const before = M.myBalance(s.id);
    const acc = st.confirmAccountId ? M.account(st.confirmAccountId) : null;
    return U.sheet({ title: 'Confirm payment', size: 'auto',
      body: `<div style="padding:20px 20px 6px;text-align:center">
          ${U.avatar(r.fromUserId, 52)}
          <div style="font-size:18px;font-weight:700;margin-top:12px">
            ${esc(M.userName(r.fromUserId))} says she paid you ${M.fmt(r.amountMinor, r.currency)}</div>
          <p style="font-size:13.5px;color:var(--pk-text-secondary);margin:8px 0 0">
            Confirm if you received it. This will clear your balance in ${esc(s.name)}.</p>
        </div>
        ${U.card([
          ['Space', s ? esc(s.name) : '<span class="kv-gone">Deleted space</span>'],
          ['Amount', `<span class="money">${M.fmt(r.amountMinor, r.currency)}</span>`],
          ...(r.note ? [['Note', esc(r.note)]] : []),
          ['Requested', M.relTime(r.createdAt || r.settledAt || M.TODAY + 'T12:00')]
        ].map(([k, v]) => `<div class="kv"><span class="kv-k">${k}</span><span class="kv-v">${v}</span></div>`).join(''))}
        <div class="note note--info">Your balance in ${esc(s.name)} goes from
          <b>${before > 0 ? M.userName(r.fromUserId) + ' owes you ' + M.fmt(before, s.currency) : 'settled'}</b> to
          <b>${before - r.amountMinor > 0 ? M.userName(r.fromUserId) + ' owes you ' + M.fmt(before - r.amountMinor, s.currency) : 'settled'}</b>.</div>
        ${U.card(U.field({ icon: 'wallet', label: 'Received into',
          value: acc ? esc(acc.name) : 'Optional — record it on an account', placeholder: !acc,
          act: 'open-picker:confirm-account' }), 'card--flush')}
        <div style="padding:16px">
          ${U.btn('Yes, I got it', 'primary', 'settle-accept', { arg: r.id })}
          <div style="height:8px"></div>
          ${U.btn("I didn't receive this", 'danger-text', 'settle-reject', { arg: r.id })}
        </div>` });
  };

})();
