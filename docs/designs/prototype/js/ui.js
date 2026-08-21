/* ============================================================
   Pockito prototype — reusable component layer
   Every repeated pattern is defined once here. Screens compose
   these; they never hand-roll a row, card, sheet or dialog.
   ============================================================ */
window.UI = (function () {
  const M = window.Domain;

  /* ── primitives ───────────────────────────────────────── */
  const esc = s => String(s == null ? '' : s)
    .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');

  const icon = (name, cls) =>
    `<svg class="pk-icon ${cls || ''}" aria-hidden="true"><use href="#i-${name}"/></svg>`;

  const catColor = idx => `var(--pk-cat-${((idx - 1) % 12) + 1})`;

  /* A category / account mark: icon in a tinted circle. */
  function mark(iconName, colorIdx, size, filled) {
    const c = catColor(colorIdx || 10);
    const px = size || 40;
    return `<span class="mark" style="width:${px}px;height:${px}px;background:${c}1F;color:${c}">
      ${icon(iconName, px <= 32 ? 'pk-icon--sm' : '')}</span>`;
  }
  function solidMark(iconName, colorIdx, size) {
    const c = catColor(colorIdx || 10);
    const px = size || 40;
    return `<span class="mark" style="width:${px}px;height:${px}px;background:${c};color:#fff">
      ${icon(iconName, px <= 32 ? 'pk-icon--sm' : '')}</span>`;
  }
  function avatar(userId, size) {
    const u = M.user(userId);
    const px = size || 32;
    const idx = (userId.charCodeAt(userId.length - 1) % 12) + 1;
    return `<span class="avatar" style="width:${px}px;height:${px}px;font-size:${Math.round(px * .38)}px;
      background:var(--pk-cat-${idx})2E;color:var(--pk-cat-${idx});border-color:var(--pk-cat-${idx})55">${u.initials}</span>`;
  }
  function avatarStack(userIds, size) {
    return `<span class="avstack">${userIds.map((u, i) =>
      `<span style="margin-left:${i ? -8 : 0}px">${avatar(u, size || 28)}</span>`).join('')}</span>`;
  }

  /* THE SIGNATURE — share rule.
     A hairline under a shared amount, filled to the share that is yours. */
  function shareRule(mineMinor, totalMinor, width) {
    const p = Math.max(4, Math.min(100, Math.round(mineMinor / totalMinor * 100)));
    return `<span class="sr" style="${width ? 'width:' + width + ';' : ''}">
      <span class="sr-mine" style="width:${p}%"></span></span>`;
  }
  function shareRuleSegmented(shares, totalMinor) {
    return `<span class="sr sr--tall">${shares.map((s, i) =>
      `<span class="sr-seg" style="width:${s.amountMinor / totalMinor * 100}%;background:${catColor(i * 3 + 1)}"></span>`
    ).join('')}</span>`;
  }

  const money = (minor, code, cls) =>
    `<span class="money ${cls || ''}">${M.fmt(minor, code)}</span>`;
  const moneyC = (minor, code, cls) =>
    `<span class="money ${cls || ''}">${M.fmtC(minor, code)}</span>`;

  function pill(text, tone) {
    return `<span class="pill pill--${tone || 'neutral'}">${esc(text)}</span>`;
  }
  function progress(percent, state) {
    const p = Math.min(100, Math.max(0, percent));
    return `<span class="track"><span class="fill fill--${state || 'ok'}" style="width:${p}%"></span></span>`;
  }

  /* ── layout blocks ────────────────────────────────────── */
  function header(cfg) {
    /* cfg: {title, subtitle, back, actions:[{icon,label,onClick}], large} */
    return `<div class="hdr ${cfg.large ? 'hdr--lg' : ''}">
      ${cfg.back ? `<button class="ico-btn" data-act="${cfg.back}" aria-label="Back">${icon('arrow-left')}</button>` : ''}
      <div class="hdr-txt">
        <div class="hdr-title">${esc(cfg.title)}</div>
        ${cfg.subtitle ? `<div class="hdr-sub">${cfg.subtitle}</div>` : ''}
      </div>
      <div class="hdr-acts">${(cfg.actions || []).map(a =>
        a.html ? a.html : `<button class="ico-btn" data-act="${a.onClick}" aria-label="${esc(a.label)}">
          ${icon(a.icon)}${a.badge ? '<span class="dot"></span>' : ''}</button>`).join('')}</div>
    </div>`;
  }
  function sectionHead(title, linkLabel, linkAct) {
    /* Without an action the trailing text is a stat, not a link — never render
       a button that does nothing. */
    const trailing = !linkLabel ? ''
      : linkAct ? `<button class="link" data-act="${linkAct}">${esc(linkLabel)}</button>`
      : `<span class="sec-stat">${esc(linkLabel)}</span>`;
    return `<div class="sec-head"><h3>${esc(title)}</h3>${trailing}</div>`;
  }
  const card = (inner, cls) => `<div class="card ${cls || ''}">${inner}</div>`;

  /* Standard list row — the workhorse. */
  function row(cfg) {
    /* cfg: {lead, title, sub, value, valueCls, note, extra, act, arg, tone, muted} */
    return `<button class="row ${cfg.muted ? 'row--muted' : ''}" ${cfg.act ? `data-act="${cfg.act}"` : 'disabled'}
        ${cfg.arg ? `data-arg="${esc(cfg.arg)}"` : ''}>
      ${cfg.lead || ''}
      <span class="row-body">
        <span class="row-title">${cfg.title}</span>
        ${cfg.sub ? `<span class="row-sub">${cfg.sub}</span>` : ''}
      </span>
      <span class="row-end">
        ${cfg.value ? `<span class="row-value ${cfg.valueCls || ''}">${cfg.value}</span>` : ''}
        ${cfg.note ? `<span class="row-note">${cfg.note}</span>` : ''}
        ${cfg.extra || ''}
        ${cfg.chevron ? icon('chevron-right', 'pk-icon--sm chev') : ''}
      </span>
    </button>`;
  }
  /* Settings-style field row inside a form. */
  function field(cfg) {
    return `<button class="field" ${cfg.act ? `data-act="${cfg.act}"` : 'disabled'}
        ${cfg.arg ? `data-arg="${esc(cfg.arg)}"` : ''}>
      ${cfg.icon ? `<span class="field-ico">${icon(cfg.icon, 'pk-icon--sm')}</span>` : ''}
      <span class="field-body">
        <span class="field-label">${esc(cfg.label)}</span>
        <span class="field-value ${cfg.placeholder ? 'is-placeholder' : ''}">${cfg.value}</span>
      </span>
      ${cfg.trailing || icon('chevron-right', 'pk-icon--sm chev')}
    </button>`;
  }
  function toggleRow(cfg) {
    return `<div class="field field--toggle" data-act="${cfg.act}" ${cfg.arg ? `data-arg="${esc(cfg.arg)}"` : ''}
        role="button" tabindex="0">
      ${cfg.icon ? `<span class="field-ico" style="${cfg.on ? 'color:var(--pk-shared)' : ''}">${icon(cfg.icon, 'pk-icon--sm')}</span>` : ''}
      <span class="field-body"><span class="field-value">${esc(cfg.label)}</span>
        ${cfg.hint ? `<span class="field-hint">${esc(cfg.hint)}</span>` : ''}</span>
      <span class="switch ${cfg.on ? 'is-on' : ''}"></span>
    </div>`;
  }
  function btn(label, variant, act, opts) {
    opts = opts || {};
    return `<button class="btn btn--${variant || 'primary'} ${opts.block === false ? '' : 'btn--block'} ${opts.cls || ''}"
      data-act="${act}" ${opts.arg ? `data-arg="${esc(opts.arg)}"` : ''} ${opts.disabled ? 'disabled' : ''}>
      ${opts.icon ? icon(opts.icon, 'pk-icon--sm') : ''}${esc(label)}</button>`;
  }
  function chips(items, activeVal, act) {
    return `<div class="chips">${items.map(i =>
      `<button class="chip" aria-pressed="${i.value === activeVal}" data-act="${act}" data-arg="${esc(i.value)}">
        ${esc(i.label)}</button>`).join('')}</div>`;
  }
  function tabs(items, active, act) {
    return `<div class="tabs">${items.map(i =>
      `<button aria-selected="${i.value === active}" data-act="${act}" data-arg="${esc(i.value)}">${esc(i.label)}</button>`
    ).join('')}</div>`;
  }
  function empty(cfg) {
    return `<div class="empty">
      <div class="empty-ico">${icon(cfg.icon || 'receipt', 'pk-icon--lg')}</div>
      <h4>${esc(cfg.title)}</h4>
      <p>${esc(cfg.body)}</p>
      ${cfg.ctaLabel ? btn(cfg.ctaLabel, cfg.ctaVariant || 'secondary', cfg.ctaAct, { block: false, arg: cfg.ctaArg }) : ''}
      ${cfg.secondary || ''}
    </div>`;
  }
  function inlineEmpty(text, ctaLabel, ctaAct) {
    return `<div class="empty empty--inline">
      <p>${esc(text)}</p>
      ${ctaLabel ? btn(ctaLabel, 'tertiary', ctaAct, { block: false }) : ''}</div>`;
  }
  function skeleton(kind) {
    if (kind === 'hero') return `<div class="sk sk-hero"></div>`;
    if (kind === 'rows') return Array(5).fill('<div class="sk sk-row"></div>').join('');
    return `<div class="sk sk-card"></div>`;
  }
  function errorState(title, act, body) {
    return `<div class="empty">
      <div class="empty-ico err">${icon('warning', 'pk-icon--lg')}</div>
      <h4>${esc(title)}</h4>
      <p>${esc(body || 'Check your connection, then try again.')}</p>
      ${btn('Try again', 'secondary', act || 'retry', { block: false })}</div>`;
  }
  /* A record the screen needed is gone — deleted, archived or left.
     Screens call this instead of dereferencing a missing entity, so a stale
     row can never take the app down. */
  function gone(what, backAct) {
    return header({ title: '', back: backAct || 'back' }) +
      `<div class="empty">
        <div class="empty-ico">${icon('receipt', 'pk-icon--lg')}</div>
        <h4>${esc(what)} isn't here any more</h4>
        <p>It was deleted or you no longer have access to it.</p>
        ${btn('Go back', 'secondary', backAct || 'back', { block: false })}</div>`;
  }
  /* Same, inside an overlay — the sheet has to be dismissable from here. */
  function goneSheet(what) {
    return sheet({ title: 'Not available', size: 'auto', body: `<div class="empty">
      <div class="empty-ico">${icon('receipt', 'pk-icon--lg')}</div>
      <h4>${esc(what)} isn't here any more</h4>
      <p>It was deleted or you no longer have access to it.</p>
      ${btn('Close', 'secondary', 'close-sheet', { block: false })}</div>` });
  }
  function banner(cfg) {
    return `<div class="banner banner--${cfg.tone || 'shared'}" ${cfg.act ? `data-act="${cfg.act}"` : ''}
        ${cfg.arg ? `data-arg="${esc(cfg.arg)}"` : ''}>
      ${cfg.icon ? `<span class="banner-ico">${icon(cfg.icon, 'pk-icon--sm')}</span>` : ''}
      <span class="banner-txt">${cfg.text}</span>
      ${cfg.cta ? `<span class="banner-cta">${esc(cfg.cta)}</span>` : ''}
    </div>`;
  }
  function note(text, tone) {
    return `<div class="note note--${tone || 'default'}">${text}</div>`;
  }

  /* ── transaction row — used on Home, Activity, Account ── */
  function txnRow(t, opts) {
    opts = opts || {};
    const c = M.category(t.categoryId);
    const acc = M.txnAccount(t);
    const share = M.myShareOf(t);
    const sp = share && M.space(share.split.spaceId);
    let lead;
    if (t.type === 'TRANSFER') lead = mark('transfer', 10);
    else if (t.type === 'SETTLEMENT') lead = mark('settle', 1);
    else lead = mark(c ? c.icon : 'receipt', c ? c.colorIdx : 10);

    const subBits = [];
    if (t.type === 'TRANSFER') {
      subBits.push(esc((M.account(t.fromAccountId) || {}).name + ' → ' + (M.account(t.toAccountId) || {}).name));
    } else if (t.type === 'SETTLEMENT') {
      /* A settlement has no category by design — it is not spending. */
      const st = t.settlementId && M.settlement(t.settlementId);
      const sSp = st && M.space(st.spaceId);
      if (sSp) subBits.push(esc(sSp.name));
      if (acc) subBits.push(esc(acc.name));
    } else {
      subBits.push(esc(c ? c.name : 'Uncategorised'));
      if (acc) subBits.push(esc(acc.name));
    }
    /* Badges lead. The sub-line truncates on a narrow row, and the space badge
       (shared money) and the AI badge are the parts that must survive — the
       account name is the one that can afford to be cut. */
    let sub = subBits.join(' · ');
    const badges = (sp ? pill(sp.name, 'shared') + ' ' : '')
      + (t.source === 'mcp' ? pill(t.client || 'AI', 'ai') + ' ' : '');
    if (badges) sub = badges + sub;
    if (t.subscriptionId) sub = icon('repeat', 'pk-icon--xs inline-ico') + ' ' + sub;

    const cls = t.type === 'INCOME' ? 'pos' : (t.type === 'TRANSFER' || t.type === 'SETTLEMENT') ? 'muted' : '';
    return row({
      lead, title: esc(M.txnTitle(t)), sub,
      value: `<span class="money ${cls}">${M.txnSign(t)}${M.fmt(t.amountMinor, t.currency).replace('−', '')}</span>`,
      note: share
        ? `<span class="money">Your share ${M.fmt(share.amountMinor, share.currency)}</span>`
        : (opts.showDate === false ? '' : M.dateLabel(t.occurredOn)),
      extra: share ? shareRule(share.amountMinor, share.split.totalMinor, '64px') : '',
      act: t.type === 'SETTLEMENT' ? 'open-settlement' : 'open-txn',
      arg: t.type === 'SETTLEMENT' ? t.settlementId : t.id
    });
  }

  /* ── shared-expense row — used inside a space ─────────── */
  function splitRow(s) {
    const c = M.category(s.categoryId);
    const mine = s.shares.find(x => x.userId === M.ME);
    return row({
      lead: mark(c ? c.icon : 'receipt', c ? c.colorIdx : 10),
      title: esc(s.title),
      sub: `Paid by ${esc(M.userName(s.payerUserId))} · ${esc(c ? c.name : 'Uncategorised')}`
        + (s.status === 'SETTLED' ? ' ' + pill('Settled', 'success') : '')
        + (s.source === 'mcp' ? ' ' + pill(s.client || 'AI', 'ai') : ''),
      value: money(s.totalMinor, s.currency),
      note: mine ? `<span class="money">Your share ${M.fmt(mine.amountMinor, s.currency)}</span>` : '',
      extra: mine ? shareRule(mine.amountMinor, s.totalMinor, '64px') : '',
      act: 'open-split', arg: s.id
    });
  }

  /* ── overlays: sheets and dialogs ─────────────────────── */
  function sheet(cfg) {
    /* cfg: {id, title, leftLabel, leftAct, rightLabel, rightAct, rightDisabled, body, footer, size} */
    return `<div class="sheet-inner sheet--${cfg.size || 'form'}" role="dialog" aria-modal="true"
        aria-label="${esc(cfg.title)}">
      <div class="grab"></div>
      <div class="sheet-head">
        <button class="sheet-btn" data-act="${cfg.leftAct || 'close-sheet'}"
          aria-label="${cfg.leftLabel ? esc(cfg.leftLabel) : 'Close'}">
          ${cfg.leftLabel ? esc(cfg.leftLabel) : icon('close', 'pk-icon--sm')}</button>
        <h2 class="sheet-title">${esc(cfg.title)}</h2>
        ${cfg.rightLabel
          ? `<button class="sheet-btn sheet-btn--strong" data-act="${cfg.rightAct}" ${cfg.rightDisabled ? 'disabled' : ''}>${esc(cfg.rightLabel)}</button>`
          : `<span class="sheet-btn sheet-btn--ghost" aria-hidden="true">${icon('close', 'pk-icon--sm')}</span>`}
      </div>
      <div class="sheet-body">${cfg.body}</div>
      ${cfg.footer ? `<div class="sheet-foot">${cfg.footer}</div>` : ''}
    </div>`;
  }
  function pickerList(items) {
    return items.map(i => row({
      lead: i.lead, title: i.title, sub: i.sub, value: i.value,
      extra: i.selected ? `<span class="tick">${icon('check', 'pk-icon--sm')}</span>` : '',
      act: i.act, arg: i.arg
    })).join('');
  }

  /* ── toast ────────────────────────────────────────────── */
  let toastTimer;
  function toast(html, actionLabel, actionAct) {
    const el = document.getElementById('toast');
    el.innerHTML = `<span class="toast-txt">${html}</span>` +
      (actionLabel ? `<button class="toast-act" data-act="${actionAct}">${esc(actionLabel)}</button>` : '') +
      `<button class="toast-x" data-act="dismiss-toast" aria-label="Dismiss">${icon('close', 'pk-icon--xs')}</button>`;
    el.classList.add('is-on');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => el.classList.remove('is-on'), actionLabel ? 6000 : 4000);
  }
  function hideToast() {
    clearTimeout(toastTimer);
    const el = document.getElementById('toast');
    if (el) el.classList.remove('is-on');
  }

  return {
    esc, icon, mark, solidMark, avatar, avatarStack, catColor,
    shareRule, shareRuleSegmented, money, moneyC, pill, progress,
    header, sectionHead, card, row, field, toggleRow, btn, chips, tabs,
    empty, inlineEmpty, skeleton, errorState, gone, goneSheet, banner, note,
    txnRow, splitRow, sheet, pickerList, toast, hideToast
  };
})();
