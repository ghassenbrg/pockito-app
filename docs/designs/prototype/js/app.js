/* ============================================================
   Pockito prototype — router, state and actions
   Navigation is centralised here. Screens are pure renderers;
   every mutation goes through Domain.
   ============================================================ */
(function () {
  const M = window.Domain, U = window.UI, S = window.Screens, D = window.DB;

  /* ── dialog catalogue (DLG-001..022) ──────────────────── */
  const DIALOGS = {
    'DLG-001': a => ({ title: 'Discard changes?', body: "Your changes won't be saved.",
      cancel: 'Keep editing', confirm: 'Discard', danger: true, act: 'discard-confirm' }),
    'DLG-002': a => { const t = M.txn(a); return { title: 'Delete this transaction?',
      body: `${M.fmt(t.amountMinor, t.currency)} at ${M.txnTitle(t)} on ${M.dateLabel(t.occurredOn)}. Your ${M.txnAccount(t).name} balance will go back to ${M.fmt(M.balance(M.txnAccount(t).id) + t.amountMinor, t.currency)}.`,
      cancel: 'Cancel', confirm: 'Delete', danger: true, act: 'txn-delete', arg: a }; },
    'DLG-003': a => { const t = M.txn(a) || {}; const x = M.split(a) || (t.splitId && M.split(t.splitId));
      const sp = x && M.space(x.spaceId);
      const others = x ? x.shares.filter(y => y.userId !== M.ME) : [];
      return { title: 'Delete this shared expense?',
      body: x ? `${M.fmt(x.totalMinor, x.currency)} ${x.title} in ${sp.name}. ${others.map(o =>
        M.userName(o.userId) + "'s balance changes by " + M.fmt(o.amountMinor, x.currency)).join('; ')}. They will be notified.`
        : 'This will change other people\'s balances.',
      cancel: 'Cancel', confirm: 'Delete for everyone', danger: true, act: 'split-delete', arg: a }; },
    'DLG-004': a => { const ac = M.account(a); return { title: 'Archive this account?',
      body: `${ac.name} will be hidden from lists and totals. Its ${M.ledger({ accountId: a }).length} transactions are kept.`,
      cancel: 'Cancel', confirm: 'Archive', act: 'acc-archive', arg: a }; },
    'DLG-005': a => { const ac = M.account(a); return { title: 'Delete this account?',
      body: `${ac.name} will be permanently removed. It has no transactions, so nothing else changes.`,
      cancel: 'Cancel', confirm: 'Delete', danger: true, act: 'acc-delete', arg: a }; },
    'DLG-006': a => { const sp = M.space(a); return { title: 'Archive this space?',
      body: `${sp.name} becomes read-only for all ${sp.members.length} members. Expenses, balances and history are kept.`,
      cancel: 'Cancel', confirm: 'Archive space', act: 'space-archive', arg: a }; },
    'DLG-007': a => { const sp = M.space(a); const bal = M.myBalance(a);
      return { title: 'Delete this space?',
      body: `${sp.name} and all ${M.spaceSplits(a).length} shared expenses will be permanently deleted for all ${sp.members.length} members.${bal ? ' Outstanding balances of ' + M.fmt(Math.abs(bal), sp.currency) + ' will be lost.' : ''} This can't be undone.`,
      cancel: 'Cancel', confirm: 'Delete space', danger: true, act: 'space-delete', arg: a,
      typeToConfirm: bal ? sp.name : null }; },
    'DLG-008': a => { const sp = M.space(a); const bal = M.myBalance(a);
      return { title: 'Leave this space?',
      body: bal ? `You still ${bal < 0 ? 'owe' : 'are owed'} ${M.fmt(Math.abs(bal), sp.currency)} in ${sp.name}. Leaving won't clear it, and you'll lose access to the history.`
        : `You'll lose access to ${sp.name}'s expenses and history. Your past expenses stay for the other members.`,
      cancel: 'Cancel', confirm: 'Leave space', danger: true, act: 'space-leave', arg: a }; },
    'DLG-009': a => { const sp = M.space(state.ctx.id); const bal = M.memberBalances(sp.id)[a] || 0;
      return { title: `Remove ${M.userName(a)} from ${sp.name}?`,
      body: `${M.userName(a)} loses access straight away. Their expenses${bal ? ' and the ' + M.fmt(Math.abs(bal), sp.currency) + ' balance' : ''} are kept. They won't be able to add anything new.`,
      cancel: 'Cancel', confirm: 'Remove ' + M.userName(a), danger: true, act: 'member-remove', arg: a }; },
    'DLG-010': a => ({ title: 'Revoke this invite?',
      body: "The link stops working. Anyone who hasn't joined yet won't be able to.",
      cancel: 'Cancel', confirm: 'Revoke', danger: true, act: 'invite-revoke', arg: a }),
    'DLG-011': a => { const r = M.settlement(a); const sp = M.space(r.spaceId);
      return { title: 'Cancel this settlement?',
      body: `The ${M.fmt(r.amountMinor, r.currency)} payment will be removed and balances go back. ${M.userName(r.fromUserId === M.ME ? r.toUserId : r.fromUserId)} will be notified.`,
      cancel: 'Keep it', confirm: 'Cancel settlement', danger: true, act: 'settle-cancel', arg: a }; },
    'DLG-012': a => { const b = M.budget(a); return { title: 'Delete this budget?',
      body: `The ${b.name} budget will be removed. Your transactions aren't affected.`,
      cancel: 'Cancel', confirm: 'Delete', danger: true, act: 'bud-delete', arg: a }; },
    'DLG-013': a => { const s = M.sub(a);
      const n = M.liveTxns().filter(t => t.subscriptionId === a).length;
      return { title: 'Delete this subscription?',
      body: `${s.name} will be removed and no future payments will be due. The ${n} payment${n === 1 ? '' : 's'} already recorded stay in your history.`,
      cancel: 'Cancel', confirm: 'Delete', danger: true, act: 'sub-delete', arg: a }; },
    'DLG-014': a => { const c = M.category(a);
      const n = M.liveTxns().filter(t => t.categoryId === a).length + M.liveSplits().filter(s => s.categoryId === a).length;
      return { title: 'This category is in use',
      body: `${c.name} is used in ${n} records. Move them to another category before deleting it.`,
      cancel: 'Cancel', confirm: 'Move and delete', act: 'open-reassign', arg: a }; },
    'DLG-015': () => ({ title: 'Sign out?', body: "You'll need to sign in again to see your accounts and spaces.",
      cancel: 'Cancel', confirm: 'Sign out', act: 'sign-out' }),
    'DLG-016': a => ({ title: 'This expense is settled',
      body: "It was settled, so it can't be changed. Add a correcting expense instead if the amount was wrong.",
      cancel: 'Close', confirm: 'Add a correcting expense', act: 'open-add' }),
    'DLG-017': a => { const sp = M.space(a); const n = M.settlementPlan(a).length;
      return { title: 'Mark everything as settled?',
      body: `All ${n} outstanding balance${n === 1 ? '' : 's'} in ${sp.name} will be cleared without recording individual payments. Everyone will be notified.`,
      cancel: 'Cancel', confirm: 'Settle everything', danger: true, act: 'settle-all', arg: a }; },
    'DLG-018': a => { const s = M.sub(a); return { title: 'Skip this payment?',
      body: `No transaction will be created. ${s.name}'s next payment moves to ${M.dateLong(M.nextDueAfter(s))}.`,
      cancel: 'Cancel', confirm: 'Skip', act: 'sub-skip', arg: a }; },
    'DLG-019': a => { const c = M.conn(a); return { title: `Disconnect ${c.clientName}?`,
      body: `${c.clientName} loses access to Pockito immediately. The ${c.writeCount} changes it made stay in your records. You can reconnect any time.`,
      cancel: 'Cancel', confirm: 'Disconnect', danger: true, act: 'ai-disconnect', arg: a }; },
    'DLG-020': () => { const n = M.D.AI_CONNECTIONS.filter(c => c.status !== 'REVOKED').length;
      return { title: 'Disconnect all AI apps?',
      body: `All ${n} connected apps lose access to Pockito immediately. Nothing they added is removed.`,
      cancel: 'Cancel', confirm: 'Disconnect all', danger: true, act: 'ai-disconnect-all' }; },
    'DLG-021': () => ({ title: "Don't connect?",
      body: "This app won't get access to Pockito. You can start again from the app any time.",
      cancel: 'Keep reviewing', confirm: "Don't connect", act: 'consent-deny' }),
    'DLG-022': a => { const ap = M.D.AI_APPROVALS.find(x => x.id === a);
      return { title: 'Reject this action?',
      body: `${ap.client} asked to: ${ap.summary}. Nothing will change, and ${ap.client} will be told you declined.`,
      cancel: 'Cancel', confirm: 'Reject', danger: true, act: 'approval-reject', arg: a }; }
  };

  /* Every dialog above is about one specific record, and every one of them
     quantifies the consequence of confirming. If the record has gone — deleted
     from another screen while this button sat waiting — there is no consequence
     left to state, so there is no dialog to show. Returning null tells the
     caller to say that plainly instead of opening an empty confirmation. */
  function dialogCfg(id, arg) {
    const fn = DIALOGS[id];
    if (!fn) return null;
    try { return fn(arg); }
    catch (err) { console.debug('[pockito] ' + id + ' has no record to describe:', err.message); return null; }
  }

  /* ── state ────────────────────────────────────────────── */
  const state = window.state = {
    booted: false, screen: 'AUTH-001', ctx: {}, tab: 'home',
    stacks: { home: [], accounts: [], spaces: [], activity: [] },
    month: M.CURRENT_MONTH, filters: {}, filterDraft: {},
    search: null, recentSearches: [],
    sheet: null, sheetCtx: {}, sheet2: null, dialog: null, dialogArg: null,
    picker: null, dirty: false, pendingNav: null,
    balanceScope: 'cycle', spaceTab: 'expenses', spaceFilters: {}, spaceFilterDraft: {},
    budgetScope: 'all', subSort: 'due', catTab: 'EXPENSE', reorder: false,
    draft: null, accDraft: null, spaceDraft: null, budgetDraft: null, subDraft: null,
    catDraft: null, dsDraft: null, settleDraft: null, payDraft: null,
    onb: null, consent: null, permDraft: null, settleResult: null,
    settleMode: 'record', confirmAccountId: null, reassignTo: null
  };

  const NOTE_MAX = 120;
  const TAB_ROOT = { home: 'HOME-001', accounts: 'ACC-001', spaces: 'SPACE-001', activity: 'TXN-001' };
  const FULLSCREEN = ['AUTH-001','AUTH-002','AUTH-003','ONB-001','ONB-002','ONB-003','ONB-004','ONB-005','ONB-006',
    'SETL-001','SETL-002','SETL-003','SPACE-009','AI-003'];
  const NO_FAB = ['SUB-001','SUB-002','BUD-001','BUD-002','CAT-001','SET-001','SET-004','SET-007','NOTIF-001',
    'AI-001','AI-002','AI-004','AI-005','AI-006','AI-007','SETL-004','ACC-006','SPACE-013','TXN-002','SPACE-010',
    'SPACE-006','SPACE-007'];

  /* ── render ───────────────────────────────────────────── */
  /* A screen or overlay must never be able to take the app down. Anything that
     throws is reported and replaced with a recoverable state, so the user keeps
     a way out instead of a blank viewport. */
  function safe(fn, fallback, label) {
    try { return fn(); }
    catch (err) {
      console.error('[pockito] ' + label + ' failed to render:', err);
      return fallback(err);
    }
  }

  function render() {
    const el = document.getElementById('screen');
    const fn = S[state.screen];
    /* A re-render of the same screen keeps its scroll — a toggle far down a
       settings list must not throw the user back to the top. */
    const sameScreen = el.dataset.screen === state.screen;
    const keepScroll = sameScreen ? el.scrollTop : 0;
    el.className = 'screen' + (FULLSCREEN.includes(state.screen) ? ' no-nav' : '');
    el.innerHTML = safe(
      () => fn ? fn(state) : U.errorState('Screen not implemented: ' + state.screen, 'back'),
      () => U.errorState('This screen ran into a problem', 'back',
        'Nothing was lost. Go back and try again.'),
      state.screen);
    el.dataset.screen = state.screen;
    if (keepScroll) el.scrollTop = keepScroll;

    const nav = document.getElementById('nav');
    const hideNav = FULLSCREEN.includes(state.screen);
    nav.classList.toggle('is-hidden', hideNav);
    if (!hideNav) {
      const cur = ({ 'SPACE-002': 'spaces', 'TXN-002': state.tab }) [state.screen] || state.tab;
      nav.innerHTML =
        navBtn('home', 'home', 'Home', cur) + navBtn('accounts', 'wallet', 'Accounts', cur) +
        `<div class="fab-slot"><button class="fab ${NO_FAB.includes(state.screen) ? 'is-hidden' : ''}"
           data-act="open-add" aria-label="Add money event">${U.icon('plus')}</button></div>` +
        navBtn('spaces', 'spaces', 'Spaces', cur) + navBtn('activity', 'activity', 'Activity', cur);
    }

    /* overlays — a sheet re-rendered in place keeps its scroll, so typing an
       amount or flipping a toggle doesn't yank the form back to the top. */
    const sheetEl = document.getElementById('sheet');
    const sheet2El = document.getElementById('sheet2');
    const scrim = document.getElementById('scrim');
    paintSheet(sheetEl, state.sheet);
    paintSheet(sheet2El, state.sheet2);
    scrim.classList.toggle('is-on', !!(state.sheet || state.sheet2));

    const dlg = document.getElementById('dialog');
    if (state.dialog && DIALOGS[state.dialog]) {
      const c = dialogCfg(state.dialog, state.dialogArg);
      if (!c) {
        /* The record this dialog was about is gone. Say so rather than
           opening an empty dialog or silently swallowing the tap. */
        state.dialog = null; dlg.classList.remove('is-on'); dlg.innerHTML = '';
        U.toast("That record isn't available any more.");
      }
      else {
        dlg.innerHTML = `<div class="dialog" role="alertdialog" aria-modal="true"
          aria-labelledby="dlgTitle" aria-describedby="dlgBody">
          <h4 id="dlgTitle">${U.esc(c.title)}</h4><p id="dlgBody">${c.body}</p>
          ${c.typeToConfirm ? `<input class="inp" id="confirmInput" data-live="type-confirm"
            aria-label="Type ${U.esc(c.typeToConfirm)} to confirm"
            placeholder="Type ${U.esc(c.typeToConfirm)} to confirm">` : ''}
          <div class="dialog-acts">
            <button class="btn ${c.danger ? 'btn--destructive' : 'btn--primary'} btn--block"
              data-act="dlg-confirm" ${c.typeToConfirm && state.typeConfirm !== c.typeToConfirm ? 'disabled' : ''}>
              ${U.esc(c.confirm)}</button>
            <button class="btn btn--tertiary btn--block" data-act="dlg-cancel">${U.esc(c.cancel)}</button>
          </div></div>`;
        dlg.classList.add('is-on');
      }
    } else { dlg.classList.remove('is-on'); dlg.innerHTML = ''; }

    /* Everything under an open overlay is inert to the screen reader and to
       Tab, so focus can't wander behind the sheet. */
    const covered = !!(state.sheet || state.sheet2 || state.dialog);
    setAttr(el, 'aria-hidden', covered ? 'true' : 'false');
    setAttr(nav, 'aria-hidden', covered ? 'true' : 'false');
    setInert(el, covered); setInert(nav, covered);
    setInert(sheetEl, !!state.sheet2 || !!state.dialog);
    setInert(sheet2El, !!state.dialog);

    if (state.search != null) {
      const inp = document.getElementById('searchInput');
      if (inp) { inp.focus(); inp.setSelectionRange(inp.value.length, inp.value.length); }
    }
    focusOverlay(covered);
    persist();
  }
  /* Writing `inert` makes the browser recompute focusability for the whole
     subtree, so only touch it when the value actually changes. */
  function setInert(el, on) {
    if (el.hasAttribute('inert') === !!on) return;
    if (on) el.setAttribute('inert', ''); else el.removeAttribute('inert');
  }
  function setAttr(el, name, value) {
    if (el.getAttribute(name) !== value) el.setAttribute(name, value);
  }

  function paintSheet(host, id) {
    const same = host.dataset.sheet === (id || '');
    const prev = same ? (host.querySelector('.sheet-body') || {}).scrollTop || 0 : 0;
    host.innerHTML = id && S[id]
      ? safe(() => S[id](state), () => U.goneSheet('This'), id) : '';
    host.dataset.sheet = id || '';
    host.classList.toggle('is-on', !!id);
    if (prev) { const b = host.querySelector('.sheet-body'); if (b) b.scrollTop = prev; }
  }

  /* Move focus into a newly opened overlay, and hand it back to whatever
     opened it once the overlay closes. The opener element itself does not
     survive — the screen is re-rendered from scratch — so remember how to find
     it again rather than holding the node. */
  /* join() renders null as an empty string, so the key uses an explicit
     placeholder — otherwise "no overlay" and "a sheet with no id" collide. */
  const NO_OVERLAY = '-|-|-';
  const overlayKey = () => [state.sheet || '-', state.sheet2 || '-', state.dialog || '-'].join('|');
  let lastOverlayKey = NO_OVERLAY, focusReturn = null, lastClickSelector = null;
  /* Values sit inside a quoted attribute selector, so only the quote and the
     backslash need escaping — CSS.escape is for identifiers and would mangle
     the colons that action names are full of. */
  const attrLit = v => String(v).replace(/[\\"]/g, '\\$&');
  function openerSelector(el) {
    if (!el || !el.getAttribute) return null;
    const act = el.getAttribute('data-act');
    if (!act) return null;
    const arg = el.getAttribute('data-arg');
    return `[data-act="${attrLit(act)}"]` + (arg ? `[data-arg="${attrLit(arg)}"]` : '');
  }
  function focusOverlay(covered) {
    const key = overlayKey();
    if (key === lastOverlayKey) return;
    const wasCovered = lastOverlayKey !== NO_OVERLAY;
    if (covered) {
      /* The control that opened this is already gone from the DOM by now —
         the screen was re-rendered — so use the one noted at click time. */
      if (!wasCovered) focusReturn = lastClickSelector || openerSelector(document.activeElement);
      const top = document.getElementById(state.dialog ? 'dialog' : state.sheet2 ? 'sheet2' : 'sheet');
      const target = top && (top.querySelector('input:not([type=hidden]), textarea, [autofocus]')
        || top.querySelector('button:not([disabled])'));
      if (target && document.activeElement !== target) target.focus({ preventScroll: true });
    } else if (wasCovered) {
      const back = focusReturn &&
        document.querySelector('#screen ' + focusReturn + ', #nav ' + focusReturn);
      if (back) back.focus({ preventScroll: true });
      focusReturn = null;
    }
    lastOverlayKey = key;
  }
  function navBtn(tab, icon, label, cur) {
    return `<button class="nv" ${cur === tab ? 'aria-current="page"' : ''} data-act="tab:${tab}">
      ${U.icon(icon, cur === tab ? 'pk-icon--sm pk-icon--active' : 'pk-icon--sm')}<span>${label}</span></button>`;
  }

  /* ── navigation ───────────────────────────────────────── */
  /* Overlays belong to the screen that opened them. Leaving that screen has to
     take them with it — otherwise a sheet keeps rendering against a context
     that has moved on underneath it. */
  function dismissOverlays() {
    state.sheet = null; state.sheet2 = null; state.picker = null;
    state.sheetCtx = {}; state.dialog = null; state.dialogArg = null;
    state.typeConfirm = '';
    state.menu = null;
    const m = document.getElementById('menu');
    if (m) m.classList.remove('is-on');
  }
  const scrollEl = () => document.getElementById('screen');
  function captureScroll() { const el = scrollEl(); return el ? el.scrollTop : 0; }
  function applyScroll(top) {
    const el = scrollEl();
    if (el) requestAnimationFrame(() => { el.scrollTop = top || 0; });
  }

  function go(screen, ctx, opts) {
    opts = opts || {};
    const stack = state.stacks[state.tab];
    if (!opts.replace && state.screen !== screen)
      stack.push({ screen: state.screen, ctx: state.ctx, scroll: captureScroll() });
    dismissOverlays();
    state.screen = screen; state.ctx = ctx || {};
    if (screen === 'SPACE-002') { state.spaceTab = 'expenses'; state.spaceFilters = {}; }
    pushHistory();
    render(); applyScroll(0);
  }
  function back() {
    /* An open overlay is the top of the back stack — dismiss it first. */
    if (state.dialog) { state.dialog = null; state.typeConfirm = ''; return render(); }
    if (state.sheet2) { state.sheet2 = null; state.picker = null; return render(); }
    if (state.sheet) { return closeSheet(); }
    if (state.search != null) { state.search = null; return render(); }
    const stack = state.stacks[state.tab];
    let scroll = 0;
    if (stack.length) { const p = stack.pop(); state.screen = p.screen; state.ctx = p.ctx; scroll = p.scroll; }
    else { state.screen = TAB_ROOT[state.tab]; state.ctx = {}; }
    dismissOverlays();
    render(); applyScroll(scroll);
  }
  function switchTab(tab) {
    dismissOverlays();
    let scroll = 0;
    if (state.tab === tab) {
      if (state.screen !== TAB_ROOT[tab]) { state.stacks[tab] = []; state.screen = TAB_ROOT[tab]; state.ctx = {}; }
      else { state.search = null; render();
        scrollEl().scrollTo({ top: 0, behavior: 'smooth' }); return; }
    } else {
      state.tabScroll = state.tabScroll || {};
      state.tabScroll[state.tab] = captureScroll();
      state.tab = tab; state.screen = TAB_ROOT[tab]; state.ctx = {};
      scroll = (state.tabScroll || {})[tab] || 0;
    }
    state.search = null;
    pushHistory();
    render(); applyScroll(scroll);
  }
  function closeSheet() {
    state.sheet = null; state.sheet2 = null; state.picker = null; state.sheetCtx = {};
    render();
  }

  /* ── system back ──────────────────────────────────────── */
  /* The browser's Back button and Android's back gesture both arrive as
     popstate. They mean the same thing the in-app back arrow means. */
  /* Opaque origins (a data: snapshot, some sandboxed webviews) reject
     pushState outright. Back-button integration is a bonus, never a
     precondition for the app running — so it disables itself on refusal. */
  let historyReady = false, ignorePop = false;
  function pushHistory() {
    if (!historyReady) return;
    try { history.pushState({ pk: state.screen }, '', location.href); }
    catch (err) { historyReady = false; }
  }
  window.addEventListener('popstate', () => {
    if (ignorePop) { ignorePop = false; return; }
    const atRoot = !state.dialog && !state.sheet && !state.sheet2 && state.search == null
      && !state.stacks[state.tab].length && state.screen === TAB_ROOT[state.tab];
    if (atRoot) {
      /* Nothing left to pop — stay put rather than leaving the app. */
      ignorePop = true; history.forward();
      return;
    }
    back();
  });

  /* ── persistence ──────────────────────────────────────── */
  /* A prototype that forgets everything on refresh can't be lived with for
     more than a minute. The seeded dataset is the fallback, not the ceiling. */
  const STORE_KEY = 'pockito.session.v1';
  const PERSIST_KEYS = ['ACCOUNTS','CATEGORIES','SPACES','SPLITS','TRANSACTIONS','SETTLEMENTS',
    'BUDGETS','SUBSCRIPTIONS','INVITES','NOTIFICATIONS','SPACE_ACTIVITY','AI_CONNECTIONS',
    'AI_ACTIVITY','AI_APPROVALS','PROFILE','seq'];
  let persistTimer = null, persistOn = true;
  function persist() {
    if (!persistOn) return;
    clearTimeout(persistTimer);
    persistTimer = setTimeout(() => {
      try {
        const snap = {};
        PERSIST_KEYS.forEach(k => { if (D[k] !== undefined) snap[k] = D[k]; });
        snap.__ui = { tab: state.tab, screen: state.screen, ctx: state.ctx,
          stacks: state.stacks, month: state.month, theme: M.D.PROFILE.theme };
        localStorage.setItem(STORE_KEY, JSON.stringify(snap));
      } catch (err) { persistOn = false; /* quota or private mode — carry on in memory */ }
    }, 250);
  }
  function restore() {
    let snap;
    try { snap = JSON.parse(localStorage.getItem(STORE_KEY) || 'null'); }
    catch (err) { return false; }
    if (!snap) return false;
    try {
      PERSIST_KEYS.forEach(k => { if (snap[k] !== undefined) D[k] = snap[k]; });
      const ui = snap.__ui || {};
      if (ui.tab && TAB_ROOT[ui.tab]) state.tab = ui.tab;
      if (ui.stacks) state.stacks = Object.assign(state.stacks, ui.stacks);
      if (ui.month) state.month = ui.month;
      /* Only restore a screen that still exists and still has its record. */
      if (ui.screen && S[ui.screen] && !FULLSCREEN.includes(ui.screen)) {
        state.screen = ui.screen; state.ctx = ui.ctx || {};
      }
      return true;
    } catch (err) { return false; }
  }
  function clearStore() { try { localStorage.removeItem(STORE_KEY); } catch (err) {} }

  /* ── keyboard ─────────────────────────────────────────── */
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape') {
      if (document.getElementById('menu').classList.contains('is-on')) {
        document.getElementById('menu').classList.remove('is-on'); state.menu = null; return;
      }
      if (state.dialog) { e.preventDefault(); return A['dlg-cancel'](); }
      if (state.sheet2) { e.preventDefault(); state.sheet2 = null; state.picker = null; return render(); }
      if (state.sheet) { e.preventDefault(); return closeSheet(); }
      if (state.search != null) { e.preventDefault(); state.search = null; return render(); }
      U.hideToast();
      return;
    }
    /* Keep Tab inside the topmost overlay. */
    if (e.key === 'Tab') {
      const top = state.dialog ? 'dialog' : state.sheet2 ? 'sheet2' : state.sheet ? 'sheet' : null;
      if (!top) return;
      const root = document.getElementById(top);
      const f = [...root.querySelectorAll('button:not([disabled]), input:not([disabled]), [tabindex]:not([tabindex="-1"])')]
        .filter(el => el.offsetParent !== null);
      if (!f.length) return;
      const first = f[0], last = f[f.length - 1];
      if (e.shiftKey && document.activeElement === first) { e.preventDefault(); last.focus(); }
      else if (!e.shiftKey && document.activeElement === last) { e.preventDefault(); first.focus(); }
      else if (!root.contains(document.activeElement)) { e.preventDefault(); first.focus(); }
      return;
    }
    /* Enter/Space on the switch rows, which are divs playing a button. */
    if ((e.key === 'Enter' || e.key === ' ') && document.activeElement
        && document.activeElement.matches('[role="button"][data-act]')) {
      e.preventDefault(); document.activeElement.click();
    }
  });

  /* A space budget is denominated in its space's currency — unless the
     space has gone, in which case the reporting currency is all there is. */
  function budgetCurrency() {
    const d = state.budgetDraft;
    const sp = d && d.scope === 'SPACE' ? M.space(d.spaceId) : null;
    return sp ? sp.currency : M.D.PROFILE.reportingCurrency;
  }

  /* ── draft builders ───────────────────────────────────── */
  function newDraft(opts) {
    opts = opts || {};
    const def = M.activeAccounts().find(a => a.isDefault) || M.activeAccounts()[0];
    const sp = opts.spaceId ? M.space(opts.spaceId) : M.activeSpaces()[0];
    const d = {
      type: 'EXPENSE', amount: 0,
      fromAccountId: opts.accountId || (def && def.id),
      toAccountId: (M.activeAccounts().find(a => a.id !== (opts.accountId || (def && def.id))) || {}).id,
      categoryId: 'c_gro', occurredOn: M.TODAY, merchant: '',
      share: !!opts.share, spaceId: sp ? sp.id : null, payerUserId: M.ME,
      method: 'EQUAL', splitValues: { included: {}, percent: {}, exact: {} }, editId: null
    };
    if (d.spaceId) applySpaceDefault(d);
    return d;
  }
  function applySpaceDefault(d) {
    const sp = M.space(d.spaceId);
    if (!sp) return;
    const ds = sp.defaultSplit;
    d.method = ds.method === 'PERCENTAGE' ? 'PERCENTAGE' : 'EQUAL';
    d.splitValues = { included: {}, percent: {}, exact: {} };
    sp.members.forEach(m => {
      d.splitValues.included[m.userId] = true;
      d.splitValues.percent[m.userId] = ds.method === 'PERCENTAGE'
        ? (ds.shares[m.userId] || 0) : Math.round(100 / sp.members.length);
      d.splitValues.exact[m.userId] = 0;
    });
  }
  function draftFromTxn(t) {
    const d = newDraft();
    d.type = t.type; d.amount = t.sourceAmountMinor || t.amountMinor;
    d.fromAccountId = t.fromAccountId; d.toAccountId = t.toAccountId;
    d.categoryId = t.categoryId; d.occurredOn = t.occurredOn; d.merchant = t.merchant || '';
    d.editId = t.id;
    const x = t.splitId && M.split(t.splitId);
    const sp = x && M.space(x.spaceId);
    /* Only reopen the sharing side if the split AND its space are both still
       there. Otherwise this edits as the plain transaction it now is. */
    if (x && sp) {
      d.share = true; d.spaceId = x.spaceId; d.payerUserId = x.payerUserId; d.method = x.method;
      d.splitValues = { included: {}, percent: {}, exact: {} };
      sp.members.forEach(m => {
        const sh = x.shares.find(y => y.userId === m.userId);
        d.splitValues.included[m.userId] = !!sh;
        d.splitValues.exact[m.userId] = sh ? sh.amountMinor : 0;
        d.splitValues.percent[m.userId] = sh && x.totalMinor
          ? Math.round(sh.amountMinor / x.totalMinor * 100) : 0;
      });
    } else {
      d.share = false; d.spaceId = null;
    }
    return d;
  }

  /* ── actions ──────────────────────────────────────────── */
  const A = {};

  A['back'] = back;
  A['noop-external'] = () => U.toast('This would open in a browser.');
  A['retry'] = () => render();
  A['close-sheet'] = closeSheet;
  A['dismiss-toast'] = () => U.hideToast();
  A['dlg-cancel'] = () => { state.dialog = null; state.typeConfirm = ''; render(); };
  A['dlg-confirm'] = () => {
    const c = dialogCfg(state.dialog, state.dialogArg);
    state.dialog = null; state.typeConfirm = '';
    if (!c) { render(); return U.toast("That record isn't available any more."); }
    if (A[c.act]) A[c.act](c.arg != null ? c.arg : state.dialogArg);
    else render();
  };
  A['explain-lens'] = () => U.toast('<b>Spent</b> is your share of what was consumed — including your part of shared expenses, and not the part others owe you back.');

  /* tabs & simple state */
  A['set-month'] = m => { state.month = m; closeSheet(); };
  A['toggle-scope'] = () => { state.balanceScope = state.balanceScope === 'cycle' ? 'lifetime' : 'cycle'; render(); };
  A['space-tab'] = t => { state.spaceTab = t; render(); };
  A['space-status'] = v => { state.spaceFilters.status = v; render(); };
  A['budget-scope'] = v => { state.budgetScope = v; render(); };
  A['cat-tab'] = v => { state.catTab = v; render(); };
  A['ai-filter'] = v => { state.ctx = { id: v }; render(); };
  A['sub-sort'] = () => { state.subSort = state.subSort === 'due' ? 'amount' : state.subSort === 'amount' ? 'name' : 'due'; render(); };

  /* search */
  A['open-search'] = () => { state.search = ''; render(); };
  A['close-search'] = () => { state.search = null; render(); };
  A['run-search'] = q => { state.search = q; render(); };

  /* filters */
  A['clear-filters'] = () => { state.filters = {}; render(); };
  A['drop-filter'] = k => {
    const [key, val] = k.split(':');
    if (val === undefined) delete state.filters[key];
    else state.filters[key] = (state.filters[key] || []).filter(v => v !== val);
    render();
  };
  A['filters-clear'] = () => { state.filterDraft = {}; render(); };
  A['filters-apply'] = () => { state.filters = Object.assign({}, state.filterDraft); closeSheet(); };
  A['f-type'] = v => togglePush(state.filterDraft, 'types', v);
  A['f-cat'] = v => togglePush(state.filterDraft, 'categoryIds', v);
  A['f-space'] = v => togglePush(state.filterDraft, 'spaceIds', v);
  A['f-src'] = v => togglePush(state.filterDraft, 'sources', v);
  A['f-month'] = v => { if (v) state.filterDraft.month = v; else delete state.filterDraft.month; render(); };
  A['f-acc'] = v => { if (v) state.filterDraft.accountId = v; else delete state.filterDraft.accountId; render(); };
  function togglePush(obj, key, v) {
    if (!v) { delete obj[key]; render(); return; }
    obj[key] = obj[key] || [];
    obj[key] = obj[key].includes(v) ? obj[key].filter(x => x !== v) : obj[key].concat(v);
    if (!obj[key].length) delete obj[key];
    render();
  }
  A['sf-payer'] = v => togglePush(state.spaceFilterDraft, 'payers', v);
  A['sf-cat'] = v => togglePush(state.spaceFilterDraft, 'categoryIds', v);
  A['sf-clear'] = () => { state.spaceFilterDraft = {}; render(); };
  A['sf-apply'] = () => { state.spaceFilters = Object.assign({ status: state.spaceFilters.status },
    state.spaceFilterDraft); closeSheet(); };
  A['space-clear-filters'] = () => { state.spaceFilters = {}; state.spaceFilterDraft = {}; render(); };
  A['filter-category'] = c => { state.filters = { categoryIds: [c] }; switchTab('activity'); };
  A['budget-view-all'] = id => { const b = M.budget(id);
    state.filters = { categoryIds: [b.categoryId], month: state.month }; switchTab('activity'); };
  A['view-all-account'] = id => { state.filters = { accountId: id }; switchTab('activity'); };

  /* add / edit money event */
  A['open-add'] = accountId => {
    state.draft = newDraft(accountId && M.account(accountId) ? { accountId } : {});
    state.sheet = 'TXN-003'; render();
  };
  A['open-add-space'] = id => { state.draft = newDraft({ spaceId: id, share: true }); state.sheet = 'TXN-003'; render(); };
  A['draft-type'] = t => { state.draft.type = t; if (t !== 'EXPENSE') state.draft.share = false;
    state.draft.categoryId = t === 'INCOME' ? 'c_sal' : 'c_gro'; render(); };
  A['draft-cat'] = c => { state.draft.categoryId = c; render(); };
  A['draft-space'] = id => { state.draft.spaceId = id; state.draft.payerUserId = M.ME;
    applySpaceDefault(state.draft); render(); };
  A['toggle-share'] = () => {
    if (!M.activeSpaces().length) { U.toast('Create a space first to split expenses.'); return; }
    state.draft.share = !state.draft.share;
    if (state.draft.share) applySpaceDefault(state.draft);
    render();
  };
  /* Minor-unit entry: each digit shifts the amount left. Capped so a stuck key
     can't run the figure past what the display can hold. */
  const AMOUNT_MAX = Math.pow(10, 11);
  A['key'] = k => {
    const d = state.draft;
    const before = d.amount;
    if (k === '⌫') d.amount = Math.floor(d.amount / 10);
    else {
      const digits = String(k);
      for (let i = 0; i < digits.length; i++) d.amount = d.amount * 10 + (+digits[i]);
      if (d.amount > AMOUNT_MAX) { d.amount = before; U.toast("That's as large as an amount can get."); return; }
    }
    render();
  };
  /* The note is edited in a sheet, not a native prompt(): prompt() is blocked
     in embedded and sandboxed webviews, and it can't be styled or validated. */
  A['edit-note'] = () => { state.noteDraft = state.draft.merchant || ''; state.sheet2 = 'NOTE-EDIT'; render(); };
  A['note-clear'] = () => { state.noteDraft = ''; render(); };
  A['note-save'] = () => {
    state.draft.merchant = (state.noteDraft || '').trim().slice(0, NOTE_MAX);
    state.sheet2 = null; state.noteDraft = null; render();
  };
  A['note-cancel'] = () => { state.sheet2 = null; state.noteDraft = null; render(); };
  A['save-draft'] = () => {
    const d = state.draft;
    /* Last line of defence: the account or space could have been removed from
       another screen after this sheet opened. */
    const target = M.account(d.type === 'INCOME' ? d.toAccountId : d.fromAccountId);
    if (!target) return U.toast('Pick an account for this — the one selected is gone.');
    if (d.share && d.type === 'EXPENSE' && !M.space(d.spaceId))
      return U.toast('That space is no longer available.');
    if (d.share && d.type === 'EXPENSE') {
      const sp = M.space(d.spaceId);
      const shares = M.computeShares(d.amount, d.method, sp.members.map(m => m.userId), d.splitValues, d.payerUserId);
      const r = M.addSharedExpense({
        spaceId: d.spaceId, title: d.merchant || M.category(d.categoryId).name,
        totalMinor: d.amount, occurredOn: d.occurredOn, categoryId: d.categoryId,
        method: d.method, payerUserId: d.payerUserId,
        accountId: d.payerUserId === M.ME ? d.fromAccountId : null, shares
      });
      const others = shares.filter(x => x.userId !== M.ME);
      const owed = others.reduce((a, x) => a + x.amountMinor, 0);
      const mine = (shares.find(x => x.userId === M.ME) || {}).amountMinor || 0;
      closeSheet();
      go('SPACE-002', { id: d.spaceId });
      U.toast(d.payerUserId === M.ME
        ? `<b>Added.</b> ${others.map(x => M.userName(x.userId)).join(' and ')} ${others.length > 1 ? 'owe' : 'owes'} you ${M.fmt(owed, sp.currency)}.`
        : `<b>Added.</b> You owe ${M.userName(d.payerUserId)} ${M.fmt(mine, sp.currency)}.`, 'Undo', 'undo-last');
    } else {
      const acc = M.account(d.type === 'INCOME' ? d.toAccountId : d.fromAccountId);
      const t = M.addTransaction({
        type: d.type, amountMinor: d.amount, currency: acc.currency,
        fromAccountId: d.type !== 'INCOME' ? d.fromAccountId : undefined,
        toAccountId: d.type !== 'EXPENSE' ? d.toAccountId : undefined,
        categoryId: d.type !== 'TRANSFER' ? d.categoryId : undefined,
        occurredOn: d.occurredOn,
        merchant: d.merchant || (d.type === 'TRANSFER' ? 'Transfer' : M.category(d.categoryId).name)
      });
      state.lastAdded = t.id;
      closeSheet(); render();
      U.toast(`<b>${d.type[0] + d.type.slice(1).toLowerCase()} added.</b> ${M.fmt(d.amount, acc.currency)}`,
        'Undo', 'undo-last');
    }
  };
  A['save-edit'] = () => {
    const d = state.draft, t = M.txn(d.editId);
    const acc = M.account(d.type === 'INCOME' ? d.toAccountId : d.fromAccountId);
    if (t.splitId) {
      const sp = M.space(d.spaceId);
      const shares = M.computeShares(d.amount, d.method, sp.members.map(m => m.userId), d.splitValues, d.payerUserId);
      M.updateSharedExpense(t.splitId, { totalMinor: d.amount, title: d.merchant || t.merchant,
        categoryId: d.categoryId, method: d.method, shares, occurredOn: d.occurredOn });
    } else {
      Object.assign(t, { amountMinor: d.amount, currency: acc.currency, categoryId: d.categoryId,
        occurredOn: d.occurredOn, merchant: d.merchant || t.merchant,
        fromAccountId: d.type !== 'INCOME' ? d.fromAccountId : undefined,
        toAccountId: d.type !== 'EXPENSE' ? d.toAccountId : undefined });
    }
    closeSheet(); render(); U.toast('<b>Saved.</b>');
  };
  A['undo-last'] = () => {
    const last = D.TRANSACTIONS[D.TRANSACTIONS.length - 1];
    if (last) { M.deleteTransaction(last.id); D.TRANSACTIONS.pop(); }
    const lastSplit = D.SPLITS[D.SPLITS.length - 1];
    if (lastSplit && lastSplit.createdBy === M.ME && lastSplit.id.startsWith('x_1')) D.SPLITS.pop();
    render(); U.toast('Undone.');
  };

  /* split editor */
  A['split-method'] = m => {
    const d = state.draft, sp = M.space(d.spaceId);
    d.method = m;
    const inc = sp.members.filter(x => d.splitValues.included[x.userId]);
    if (m === 'EXACT') {
      const per = Math.floor(d.amount / inc.length);
      inc.forEach((x, i) => d.splitValues.exact[x.userId] = per + (i === 0 ? d.amount - per * inc.length : 0));
    }
    if (m === 'PERCENTAGE' && sp.defaultSplit.method !== 'PERCENTAGE')
      inc.forEach(x => d.splitValues.percent[x.userId] = Math.round(100 / inc.length));
    render();
  };
  A['split-toggle'] = uid => {
    const d = state.draft;
    const on = Object.values(d.splitValues.included).filter(Boolean).length;
    if (d.splitValues.included[uid] && on <= 1) { U.toast('At least one person has to be in the split.'); return; }
    d.splitValues.included[uid] = !d.splitValues.included[uid];
    A['split-method'](d.method);
  };
  A['split-rest'] = () => {
    const d = state.draft, sp = M.space(d.spaceId);
    const inc = sp.members.filter(x => d.splitValues.included[x.userId]);
    const sum = inc.reduce((a, x) => a + (+d.splitValues.exact[x.userId] || 0), 0);
    const diff = d.amount - sum, per = Math.floor(diff / inc.length);
    inc.forEach((x, i) => d.splitValues.exact[x.userId] =
      (+d.splitValues.exact[x.userId] || 0) + per + (i === 0 ? diff - per * inc.length : 0));
    render();
  };
  A['split-reset'] = () => { applySpaceDefault(state.draft); render(); };
  A['split-mine'] = () => {
    const d = state.draft, sp = M.space(d.spaceId);
    d.method = 'EXACT';
    sp.members.forEach(m => {
      d.splitValues.included[m.userId] = m.userId === d.payerUserId;
      d.splitValues.exact[m.userId] = m.userId === d.payerUserId ? d.amount : 0;
    });
    render();
  };
  A['split-done'] = () => { state.sheet2 = null; render(); };
  A['open-sheet:SPLIT-EDIT'] = id => {
    const x = M.split(id);
    const sp = x && M.space(x.spaceId);
    if (!x || !sp) return U.toast('That shared expense is no longer available.');
    const t = D.TRANSACTIONS.find(y => y.splitId === id && !y.deleted);
    state.draft = t ? draftFromTxn(t) : (() => {
      const d = newDraft({ spaceId: x.spaceId, share: true });
      d.amount = x.totalMinor; d.method = x.method; d.payerUserId = x.payerUserId;
      d.categoryId = x.categoryId; d.merchant = x.title; d.editSplitId = x.id;
      sp.members.forEach(m => {
        const sh = x.shares.find(y => y.userId === m.userId);
        d.splitValues.included[m.userId] = !!sh;
        d.splitValues.exact[m.userId] = sh ? sh.amountMinor : 0;
      });
      return d;
    })();
    state.sheet = 'SPLIT-001'; render();
  };

  /* pickers */
  A['open-picker:account'] = field => {
    state.picker = { kind: 'account', target: field, value: state.draft[field],
      exclude: field === 'toAccountId' ? state.draft.fromAccountId : null,
      allowUntracked: state.draft.share };
    state.sheet2 = 'PICK-001'; render();
  };
  A['open-picker:category'] = () => {
    state.picker = { kind: 'category', target: 'categoryId', value: state.draft.categoryId,
      categoryType: state.draft.type === 'INCOME' ? 'INCOME' : 'EXPENSE', clearable: true };
    state.sheet2 = 'PICK-002'; render();
  };
  A['open-picker:date'] = () => {
    state.picker = { kind: 'date', target: 'occurredOn', value: state.draft.occurredOn };
    state.sheet2 = 'PICK-003'; render();
  };
  A['open-picker:payer'] = () => {
    state.picker = { kind: 'payer', target: 'payerUserId', value: state.draft.payerUserId,
      spaceId: state.draft.spaceId, title: 'Who paid?' };
    state.sheet2 = 'PICK-005'; render();
  };
  A['pick'] = v => {
    const p = state.picker;
    if (!p) return;
    if (p.kind === 'account' || p.kind === 'category' || p.kind === 'date' || p.kind === 'payer') {
      state.draft[p.target] = v || null;
      if (p.kind === 'account' && p.target === 'fromAccountId' && state.draft.toAccountId === v)
        state.draft.toAccountId = (M.activeAccounts().find(a => a.id !== v) || {}).id;
    } else if (p.kind === 'acc-currency') { state.accDraft.currency = v; }
    else if (p.kind === 'acc-appearance') { /* handled by pick-appearance-done */ }
    else if (p.kind === 'space-currency') { state.spaceDraft.currency = v; }
    else if (p.kind === 'space-currency-edit') { M.space(state.ctx.id).currency = v; }
    else if (p.kind === 'budget-category') { state.budgetDraft.categoryId = v;
      if (!state.budgetDraft.nameTouched) state.budgetDraft.name = M.category(v).name; }
    else if (p.kind === 'sub-account') { state.subDraft.accountId = v; }
    else if (p.kind === 'sub-category') { state.subDraft.categoryId = v; }
    else if (p.kind === 'sub-start') { state.subDraft.startsOn = v; state.subDraft.nextDueOn = v; }
    else if (p.kind === 'pay-account') { state.payDraft.accountId = v; }
    else if (p.kind === 'pay-date') { state.payDraft.occurredOn = v; }
    else if (p.kind === 'settle-from') { state.settleDraft.fromUserId = v; }
    else if (p.kind === 'settle-to') { state.settleDraft.toUserId = v; }
    else if (p.kind === 'settle-account') { state.settleDraft.accountId = v === 'UNTRACKED' ? null : v; }
    else if (p.kind === 'confirm-account') { state.confirmAccountId = v; }
    else if (p.kind === 'onb-currency') { state.onb.currency = v; }
    else if (p.kind === 'onb-space-currency') { state.onb.spaceCurrency = v; }
    else if (p.kind === 'reporting') { M.D.PROFILE.reportingCurrency = v; }
    state.sheet2 = null; state.picker = null; render();
  };
  function openPicker(kind, sheet, extra) {
    state.picker = Object.assign({ kind }, extra || {});
    state.sheet2 = sheet; render();
  }
  A['open-picker:currency'] = () => openPicker('acc-currency', 'PICK-006', { value: state.accDraft.currency });
  A['open-picker:appearance'] = () => openPicker('acc-appearance', 'PICK-007',
    { icon: state.accDraft.icon, colorIdx: state.accDraft.colorIdx, target: 'accDraft' });
  A['open-picker:space-currency'] = () => openPicker('space-currency', 'PICK-006', { value: state.spaceDraft.currency });
  A['open-picker:space-currency-edit'] = () => openPicker('space-currency-edit', 'PICK-006', { value: M.space(state.ctx.id).currency });
  A['open-picker:space-appearance'] = () => openPicker('space-appearance', 'PICK-007',
    { icon: state.spaceDraft.icon, colorIdx: state.spaceDraft.colorIdx, target: 'spaceDraft' });
  A['open-picker:space-appearance-edit'] = () => openPicker('space-appearance-edit', 'PICK-007',
    { icon: M.space(state.ctx.id).icon, colorIdx: M.space(state.ctx.id).colorIdx, target: 'space' });
  A['open-picker:budget-category'] = () => openPicker('budget-category', 'PICK-002',
    { value: state.budgetDraft.categoryId, categoryType: 'EXPENSE' });
  A['open-picker:sub-account'] = () => openPicker('sub-account', 'PICK-001', { value: state.subDraft.accountId });
  A['open-picker:sub-category'] = () => openPicker('sub-category', 'PICK-002',
    { value: state.subDraft.categoryId, categoryType: 'EXPENSE' });
  A['open-picker:sub-start'] = () => openPicker('sub-start', 'PICK-003', { value: state.subDraft.startsOn });
  A['open-picker:sub-appearance'] = () => openPicker('sub-appearance', 'PICK-007',
    { icon: state.subDraft.icon, colorIdx: state.subDraft.colorIdx, target: 'subDraft' });
  A['open-picker:cat-appearance'] = () => openPicker('cat-appearance', 'PICK-007',
    { icon: state.catDraft.icon, colorIdx: state.catDraft.colorIdx, target: 'catDraft' });
  A['open-picker:pay-account'] = () => openPicker('pay-account', 'PICK-001', { value: state.payDraft.accountId });
  A['open-picker:pay-date'] = () => openPicker('pay-date', 'PICK-003', { value: state.payDraft.occurredOn });
  A['open-picker:settle-from'] = () => openPicker('settle-from', 'PICK-005',
    { value: state.settleDraft.fromUserId, spaceId: state.ctx.id, title: 'From' });
  A['open-picker:settle-to'] = () => openPicker('settle-to', 'PICK-005',
    { value: state.settleDraft.toUserId, spaceId: state.ctx.id, title: 'To', exclude: state.settleDraft.fromUserId });
  A['open-picker:settle-account'] = () => openPicker('settle-account', 'PICK-001',
    { value: state.settleDraft.accountId, allowUntracked: true });
  A['open-picker:confirm-account'] = () => openPicker('confirm-account', 'PICK-001', { value: state.confirmAccountId });
  A['open-picker:onb-currency'] = () => openPicker('onb-currency', 'PICK-006', { value: state.onb.currency });
  A['open-picker:onb-space-currency'] = () => openPicker('onb-space-currency', 'PICK-006', { value: state.onb.spaceCurrency });
  A['pick-color'] = i => { state.picker.colorIdx = +i; render(); };
  A['pick-icon'] = n => { state.picker.icon = n; render(); };
  A['pick-appearance-done'] = () => {
    const p = state.picker;
    const tgt = p.target === 'space' ? M.space(state.ctx.id) : state[p.target];
    if (tgt) { tgt.icon = p.icon; tgt.colorIdx = p.colorIdx; }
    state.sheet2 = null; state.picker = null; render();
  };
  A['locked-currency'] = () => U.toast("Currency can't change once an account has transactions.");
  A['locked-space-currency'] = () => U.toast("Currency can't change once a space has expenses.");
  A['perm-locked'] = () => U.toast("This app didn't ask for this permission. It would need to request it again.");

  /* accounts */
  A['open-sheet:ACC-003'] = () => {
    state.accDraft = { name: 'Bank account', type: 'BANK', opening: 0,
      currency: M.D.PROFILE.reportingCurrency, icon: 'bank', colorIdx: 3,
      isDefault: !M.activeAccounts().length, nameTouched: false };
    state.sheet = 'ACC-003'; render();
  };
  A['acc-type'] = t => {
    const d = state.accDraft;
    d.type = t;
    const icons = { CASH: 'cash', BANK: 'bank', CARD: 'card', SAVINGS: 'savings', DIGITAL: 'wallet', OTHER: 'wallet' };
    d.icon = icons[t];
    if (!d.nameTouched) d.name = t === 'BANK' ? 'Bank account' : t[0] + t.slice(1).toLowerCase();
    render();
  };
  A['acc-default'] = () => { state.accDraft.isDefault = !state.accDraft.isDefault; render(); };
  A['acc-save'] = () => {
    const d = state.accDraft;
    if (M.D.ACCOUNTS.some(a => !a.archived && a.name.toLowerCase() === d.name.trim().toLowerCase())) {
      d.errName = `You already have an account called "${d.name.trim()}".`; render(); return;
    }
    if (d.isDefault) M.D.ACCOUNTS.forEach(a => a.isDefault = false);
    M.D.ACCOUNTS.push({ id: M.nextId('a'), name: d.name.trim(), type: d.type, currency: d.currency,
      opening: d.opening, isDefault: d.isDefault, archived: false, colorIdx: d.colorIdx,
      icon: d.icon, sortOrder: M.D.ACCOUNTS.length });
    closeSheet(); render(); U.toast('<b>Account added.</b>');
  };
  A['open-sheet:ACC-004'] = id => {
    const a = M.account(id);
    if (!a) return U.toast('That account is no longer available.');
    state.accDraft = Object.assign({}, a, { nameTouched: true });
    state.sheet = 'ACC-004'; render();
  };
  A['acc-save-edit'] = () => {
    const d = state.accDraft, a = M.account(d.id);
    if (d.isDefault) M.D.ACCOUNTS.forEach(x => x.isDefault = false);
    Object.assign(a, { name: d.name.trim(), type: d.type, icon: d.icon, colorIdx: d.colorIdx,
      isDefault: d.isDefault, currency: d.currency });
    closeSheet(); render(); U.toast('<b>Account updated.</b>');
  };
  A['acc-archive'] = id => { M.account(id).archived = true; closeSheet();
    if (state.screen === 'ACC-002') back(); else render();
    U.toast('<b>Account archived.</b>', 'Undo', 'acc-unarchive:' + id); };
  A['restore-account'] = id => { M.account(id).archived = false; closeSheet(); render();
    U.toast('<b>Account restored.</b>'); };
  A['acc-delete'] = id => {
    const i = M.D.ACCOUNTS.findIndex(a => a.id === id);
    if (i >= 0) M.D.ACCOUNTS.splice(i, 1);
    closeSheet(); if (state.screen === 'ACC-002') back(); else render();
    U.toast('<b>Account deleted.</b>');
  };
  A['reorder-done'] = () => { state.reorder = false; render(); };
  A['move-acc-up'] = id => moveAcc(id, -1);
  A['move-acc-down'] = id => moveAcc(id, 1);
  function moveAcc(id, dir) {
    const list = M.activeAccounts();
    const i = list.findIndex(a => a.id === id);
    const j = i + dir;
    if (j < 0 || j >= list.length) return;
    const so = list[i].sortOrder; list[i].sortOrder = list[j].sortOrder; list[j].sortOrder = so;
    render();
  }

  /* transactions */
  A['open-txn'] = id => go('TXN-002', { id });
  A['open-split'] = id => go('SPACE-010', { id });
  A['open-settlement'] = id => { state.sheetCtx = { id }; state.sheet = 'SETL-005'; render(); };
  A['open-sheet:TXN-004'] = id => { state.draft = draftFromTxn(M.txn(id)); state.sheet = 'TXN-004'; render(); };
  A['open-sheet:TXN-005'] = () => { state.filterDraft = Object.assign({}, state.filters); state.sheet = 'TXN-005'; render(); };
  A['txn-delete'] = id => {
    M.deleteTransaction(id); closeSheet();
    if (state.screen === 'TXN-002') back(); else render();
    U.toast('<b>Deleted.</b>', 'Undo', 'txn-restore:' + id);
  };
  A['split-delete'] = id => {
    const t = M.txn(id);
    M.deleteSplit(t && t.splitId ? t.splitId : id);
    closeSheet(); if (state.screen === 'TXN-002' || state.screen === 'SPACE-010') back(); else render();
    U.toast('<b>Deleted for everyone.</b> Members have been notified.');
  };

  /* spaces */
  A['open-sheet:SPACE-005'] = () => {
    state.spaceDraft = { step: 1, name: 'Us', type: 'COUPLE', currency: M.D.PROFILE.reportingCurrency,
      icon: 'spaces', colorIdx: 9, nameTouched: false, token: null };
    state.sheet = 'SPACE-005'; render();
  };
  A['space-type'] = t => {
    const d = state.spaceDraft;
    d.type = t;
    const names = { COUPLE: 'Us', HOUSEHOLD: 'Home', TRIP: 'Trip', FAMILY: 'Family', OTHER: '' };
    const icons = { COUPLE: 'spaces', HOUSEHOLD: 'housing', TRIP: 'travel', FAMILY: 'spaces', OTHER: 'spaces' };
    const colors = { COUPLE: 9, HOUSEHOLD: 2, TRIP: 4, FAMILY: 6, OTHER: 10 };
    d.icon = icons[t]; d.colorIdx = colors[t];
    if (!d.nameTouched) d.name = names[t];
    render();
  };
  A['space-create'] = () => {
    const d = state.spaceDraft;
    const id = M.nextId('s');
    M.D.SPACES.push({ id, name: d.name.trim(), type: d.type, currency: d.currency,
      colorIdx: d.colorIdx, icon: d.icon, status: 'ACTIVE', createdAt: M.TODAY,
      members: [{ userId: M.ME, role: 'OWNER', status: 'ACTIVE', joinedAt: M.TODAY }],
      defaultSplit: { method: 'EQUAL' },
      notifications: { expenses: true, settlements: true, activity: false } });
    d.step = 2; d.createdId = id; d.token = id.slice(2) + 'K9z';
    M.D.SPACE_ACTIVITY.unshift({ id: M.nextId('ev'), spaceId: id, at: M.TODAY + 'T12:00',
      actor: M.ME, type: 'MEMBER_JOINED', text: 'created the space' });
    render();
  };
  A['space-created-done'] = () => { const id = state.spaceDraft.createdId; closeSheet();
    state.tab = 'spaces'; state.stacks.spaces = []; go('SPACE-002', { id }, { replace: true });
    U.toast('<b>Space created.</b>'); };
  A['open-sheet:SPACE-008'] = id => { state.sheetCtx = { id: id || state.ctx.id }; state.sheet = 'SPACE-008'; render(); };
  A['copy-link'] = url => U.toast('<b>Link copied.</b> ' + url);
  A['share-link'] = url => U.toast('<b>Share sheet opened.</b> The link would go to your messaging app.');
  A['open-sheet:SPACE-011'] = () => {
    const sp = M.space(state.ctx.id);
    state.dsDraft = { method: sp.defaultSplit.method, shares: Object.assign({}, sp.defaultSplit.shares || {}) };
    sp.members.forEach(m => { if (state.dsDraft.shares[m.userId] == null)
      state.dsDraft.shares[m.userId] = Math.round(100 / sp.members.length); });
    state.sheet = 'SPACE-011'; render();
  };
  A['ds-method'] = m => { state.dsDraft.method = m; render(); };
  A['ds-save'] = () => {
    const sp = M.space(state.ctx.id), d = state.dsDraft;
    sp.defaultSplit = d.method === 'PERCENTAGE' ? { method: 'PERCENTAGE', shares: d.shares } : { method: d.method };
    closeSheet(); render(); U.toast('<b>Default split saved.</b>');
  };
  A['space-notif'] = k => { const sp = M.space(state.ctx.id); sp.notifications[k] = !sp.notifications[k]; render(); };
  A['space-archive'] = id => { M.space(id).status = 'ARCHIVED'; state.stacks.spaces = [];
    go('SPACE-001', {}, { replace: true }); U.toast('<b>Space archived.</b>'); };
  A['restore-space'] = id => { M.space(id).status = 'ACTIVE'; render(); U.toast('<b>Space restored.</b>'); };
  A['space-delete'] = id => {
    const i = M.D.SPACES.findIndex(s => s.id === id);
    if (i >= 0) M.D.SPACES.splice(i, 1);
    M.D.SPLITS.filter(x => x.spaceId === id).forEach(x => x.deleted = true);
    state.stacks.spaces = []; go('SPACE-001', {}, { replace: true }); U.toast('<b>Space deleted.</b>');
  };
  A['space-leave'] = id => {
    const sp = M.space(id);
    sp.members = sp.members.filter(m => m.userId !== M.ME);
    const i = M.D.SPACES.findIndex(s => s.id === id);
    if (i >= 0) M.D.SPACES.splice(i, 1);
    state.stacks.spaces = []; go('SPACE-001', {}, { replace: true }); U.toast('<b>You left the space.</b>');
  };
  A['open-sheet:MEMBER'] = uid => { state.sheetCtx = { id: uid }; state.sheet = 'MEMBER'; render(); };
  A['member-remove'] = uid => {
    const sp = M.space(state.ctx.id);
    sp.members = sp.members.filter(m => m.userId !== uid);
    closeSheet(); render(); U.toast(`<b>${M.userName(uid)} removed.</b> Their history is kept.`);
  };
  A['invite-revoke'] = id => {
    const i = M.D.INVITES.find(x => x.id === id);
    if (i) i.status = 'REVOKED';
    render(); U.toast('<b>Invite revoked.</b>');
  };
  A['accept-invite'] = () => {
    const inv = M.D.INCOMING_INVITE;
    inv.status = 'ACCEPTED';
    const id = M.nextId('s');
    M.D.SPACES.push({ id, name: inv.spaceName, type: 'OTHER', currency: inv.spaceCurrency,
      colorIdx: 6, icon: 'spaces', status: 'ACTIVE', createdAt: inv.createdAt,
      members: [{ userId: 'u_sam', role: 'OWNER', status: 'ACTIVE', joinedAt: inv.createdAt },
                { userId: M.ME, role: 'MEMBER', status: 'ACTIVE', joinedAt: M.TODAY }],
      defaultSplit: { method: 'EQUAL' },
      notifications: { expenses: true, settlements: true, activity: false } });
    state.tab = 'spaces'; state.stacks.spaces = [];
    go('SPACE-002', { id }, { replace: true });
    U.toast('<b>You joined ' + inv.spaceName + '.</b>');
  };
  A['decline-invite'] = () => { M.D.INCOMING_INVITE.status = 'DECLINED'; back(); U.toast('Invite declined.'); };
  A['open-sheet:SPACE-014'] = () => { state.spaceFilterDraft = Object.assign({}, state.spaceFilters);
    state.sheet = 'SPACE-014'; render(); };
  A['open-sheet:SPACE-012'] = () => { state.sheet = 'SPACE-012'; render(); };

  /* settlements */
  A['go:SETL-001'] = id => {
    const sp = M.space(id || state.ctx.id);
    if (!sp) return U.toast('That space is no longer available.');
    /* A space you are the only member of has nobody to settle with. */
    const other = sp.members.find(m => m.userId !== M.ME);
    if (!other) return U.toast(`You're the only member of ${sp.name} — invite someone to settle up.`);
    const plan = M.settlementPlan(sp.id, state.balanceScope);
    const mine = plan.find(p => p.fromUserId === M.ME || p.toUserId === M.ME) || plan[0]
      || { fromUserId: M.ME, toUserId: other.userId, amountMinor: 0 };
    state.settleDraft = { fromUserId: mine.fromUserId, toUserId: mine.toUserId,
      amount: mine.amountMinor, accountId: null };
    go('SETL-001', { id: sp.id });
  };
  A['settle-pick'] = v => {
    const [f, t, a] = v.split('|');
    state.settleDraft.fromUserId = f; state.settleDraft.toUserId = t; state.settleDraft.amount = +a;
    render();
  };
  A['open-sheet:SETL-002'] = () => { state.settleMode = 'record'; state.sheet = 'SETL-002'; render(); };
  A['settle-request'] = () => { state.settleMode = 'request'; state.sheet = 'SETL-002'; render(); };
  A['settle-confirm'] = () => {
    const d = state.settleDraft, sp = M.space(state.ctx.id);
    const other = d.fromUserId === M.ME ? d.toUserId : d.fromUserId;
    if (state.settleMode === 'request') {
      M.D.SETTLEMENTS.push({ id: M.nextId('st'), spaceId: sp.id, fromUserId: d.fromUserId,
        toUserId: d.toUserId, amountMinor: d.amount, currency: sp.currency, status: 'PROPOSED',
        createdBy: M.ME, createdAt: M.TODAY, settledAt: null, source: 'mobile' });
    } else {
      M.confirmSettlement({ spaceId: sp.id, fromUserId: d.fromUserId, toUserId: d.toUserId,
        amountMinor: d.amount, accountId: d.accountId });
    }
    state.settleResult = { spaceId: sp.id, amount: d.amount, currency: sp.currency,
      fromName: M.userName(d.fromUserId), toName: M.userName(d.toUserId), otherName: M.userName(other),
      accountName: d.accountId ? M.account(d.accountId).name : null,
      proposed: state.settleMode === 'request' };
    state.sheet = null;
    state.stacks[state.tab] = state.stacks[state.tab].filter(s => s.screen !== 'SETL-001');
    go('SETL-003', {}, { replace: true });
  };
  A['settle-done'] = id => { state.stacks.spaces = []; state.tab = 'spaces';
    go('SPACE-002', { id }, { replace: true }); };
  A['open-sheet:SETL-005'] = id => { state.sheetCtx = { id }; state.sheet = 'SETL-005'; render(); };
  A['open-sheet:SETL-006'] = id => { state.sheetCtx = { id }; state.confirmAccountId = null;
    state.sheet = 'SETL-006'; render(); };
  A['settle-accept'] = id => {
    const r = M.settlement(id);
    r.status = 'CONFIRMED'; r.confirmedBy = M.ME; r.settledAt = M.TODAY;
    if (state.confirmAccountId) {
      const sp = M.space(r.spaceId), acc = M.account(state.confirmAccountId);
      M.addTransaction({ type: 'SETTLEMENT', amountMinor: M.convert(r.amountMinor, sp.currency, acc.currency),
        currency: acc.currency, toAccountId: acc.id, occurredOn: M.TODAY, settlementId: r.id,
        merchant: 'Settled with ' + M.userName(r.fromUserId),
        sourceAmountMinor: acc.currency !== sp.currency ? r.amountMinor : undefined,
        sourceCurrency: acc.currency !== sp.currency ? sp.currency : undefined });
    }
    const n = M.D.NOTIFICATIONS.find(x => x.type === 'SETTLEMENT_REQUEST'); if (n) n.read = true;
    closeSheet(); render();
    U.toast('<b>Confirmed.</b> Balances updated. This does not count as spending.');
  };
  A['settle-reject'] = id => {
    const r = M.settlement(id); r.status = 'CANCELLED';
    closeSheet(); render(); U.toast('Marked as not received. ' + M.userName(r.fromUserId) + ' will be told.');
  };
  A['settle-cancel'] = id => {
    const r = M.settlement(id); r.status = 'CANCELLED';
    closeSheet(); render(); U.toast('<b>Settlement cancelled.</b> Balances restored.');
  };
  A['settle-all'] = id => {
    M.settlementPlan(id).forEach(p => M.confirmSettlement({ spaceId: id,
      fromUserId: p.fromUserId, toUserId: p.toUserId, amountMinor: p.amountMinor }));
    state.stacks.spaces = []; go('SPACE-002', { id }, { replace: true });
    U.toast('<b>Everything settled.</b> Everyone has been notified.');
  };

  /* budgets */
  A['open-sheet:BUD-003'] = arg => {
    const spaceId = arg && arg.startsWith('space:') ? arg.slice(6) : null;
    state.budgetDraft = { scope: spaceId ? 'SPACE' : 'PERSONAL', spaceId,
      categoryId: null, amount: 0, name: '', alerts: [80, 100], nameTouched: false };
    state.sheet = 'BUD-003'; render();
  };
  A['bud-scope'] = v => {
    const d = state.budgetDraft;
    if (v === 'PERSONAL') { d.scope = 'PERSONAL'; d.spaceId = null; }
    else { d.scope = 'SPACE'; d.spaceId = v.split(':')[1]; }
    render();
  };
  A['bud-alert'] = t => {
    const d = state.budgetDraft, n = +t;
    d.alerts = d.alerts.includes(n) ? d.alerts.filter(x => x !== n) : d.alerts.concat(n).sort((a, b) => a - b);
    render();
  };
  A['bud-save'] = () => {
    const d = state.budgetDraft;
    const budSpace = d.scope === 'SPACE' ? M.space(d.spaceId) : null;
    const cur = budSpace ? budSpace.currency : M.D.PROFILE.reportingCurrency;
    M.D.BUDGETS.push({ id: M.nextId('b'), name: d.name.trim(), scope: d.scope, spaceId: d.spaceId,
      categoryId: d.categoryId, limitMinor: d.amount, currency: cur,
      startsOn: state.month + '-01', alerts: d.alerts });
    closeSheet(); render(); U.toast('<b>Budget created.</b>');
  };
  A['open-sheet:BUD-004'] = id => {
    const b = M.budget(id);
    state.budgetDraft = { id: b.id, scope: b.scope, spaceId: b.spaceId, categoryId: b.categoryId,
      amount: b.limitMinor, name: b.name, alerts: b.alerts.slice(), nameTouched: true };
    state.sheet = 'BUD-004'; render();
  };
  A['bud-save-edit'] = () => {
    const d = state.budgetDraft, b = M.budget(d.id);
    Object.assign(b, { name: d.name.trim(), limitMinor: d.amount, alerts: d.alerts });
    closeSheet(); render(); U.toast('<b>Budget updated.</b>');
  };
  A['bud-delete'] = id => {
    const i = M.D.BUDGETS.findIndex(b => b.id === id);
    if (i >= 0) M.D.BUDGETS.splice(i, 1);
    closeSheet(); if (state.screen === 'BUD-002') back(); else render();
    U.toast('<b>Budget deleted.</b>');
  };

  /* subscriptions */
  A['open-sheet:SUB-003'] = () => {
    const def = M.activeAccounts().find(a => a.isDefault) || M.activeAccounts()[0];
    state.subDraft = { name: '', amount: 0, accountId: def && def.id, categoryId: null,
      icon: 'repeat', colorIdx: 12, cadence: { frequency: 'MONTHLY', interval: 1, dayOfMonth: 1 },
      startsOn: M.TODAY, nextDueOn: M.TODAY, status: 'ACTIVE' };
    state.sheet = 'SUB-003'; render();
  };
  A['open-sheet:SUB-004'] = id => {
    const s = M.sub(id);
    state.subDraft = Object.assign({}, s, { cadence: Object.assign({}, s.cadence) });
    state.sheet = 'SUB-004'; render();
  };
  A['open-sheet:SUB-006'] = () => { state.sheet2 = 'SUB-006'; render(); };
  A['cad-freq'] = f => { state.subDraft.cadence.frequency = f; state.subDraft.cadence.interval = 1; render(); };
  A['cad-interval'] = d => { const c = state.subDraft.cadence;
    c.interval = Math.max(1, Math.min(31, (c.interval || 1) + (+d))); render(); };
  A['cad-dow'] = v => { state.subDraft.cadence.dayOfWeek = +v; render(); };
  A['cad-month'] = v => { state.subDraft.cadence.monthOfYear = +v; render(); };
  A['cadence-done'] = () => { state.sheet2 = null; render(); };
  A['sub-save'] = () => {
    const d = state.subDraft;
    M.D.SUBSCRIPTIONS.push({ id: M.nextId('sb'), name: d.name.trim(), amountMinor: d.amount,
      currency: M.account(d.accountId).currency, accountId: d.accountId, categoryId: d.categoryId,
      icon: d.icon, cadence: d.cadence, startsOn: d.startsOn, nextDueOn: d.nextDueOn || d.startsOn,
      lastPaidOn: null, status: 'ACTIVE' });
    closeSheet(); render(); U.toast('<b>Subscription added.</b>');
  };
  A['sub-save-edit'] = () => {
    const d = state.subDraft, s = M.sub(d.id);
    Object.assign(s, { name: d.name.trim(), amountMinor: d.amount, accountId: d.accountId,
      categoryId: d.categoryId, cadence: d.cadence, icon: d.icon, colorIdx: d.colorIdx });
    closeSheet(); render(); U.toast('<b>Subscription updated.</b>');
  };
  A['sub-toggle-pause'] = id => {
    const s = M.sub(id);
    if (!s) return U.toast('That subscription is no longer available.');
    s.status = s.status === 'PAUSED' ? 'ACTIVE' : 'PAUSED';
    if (s.status === 'ACTIVE' && !s.nextDueOn) s.nextDueOn = M.nextDueAfter(s);
    /* The edit sheet may not be open — this also runs from the list's menu. */
    if (state.subDraft && state.subDraft.id === s.id) state.subDraft.status = s.status;
    render(); U.toast(s.status === 'PAUSED' ? '<b>Paused.</b>' : '<b>Resumed.</b>');
  };
  A['sub-delete'] = id => {
    const i = M.D.SUBSCRIPTIONS.findIndex(s => s.id === id);
    if (i >= 0) M.D.SUBSCRIPTIONS.splice(i, 1);
    closeSheet(); if (state.screen === 'SUB-002') back(); else render();
    U.toast('<b>Subscription deleted.</b> Past payments are kept.');
  };
  A['sub-skip'] = id => { M.skipSubscription(id); closeSheet(); render();
    U.toast('<b>Skipped.</b> No transaction was created.'); };
  A['open-sheet:SUB-005'] = id => {
    const s = M.sub(id);
    state.sheetCtx = { id };
    state.payDraft = { amount: s.amountMinor, accountId: s.accountId, occurredOn: s.nextDueOn || M.TODAY };
    state.sheet = 'SUB-005'; render();
  };
  A['pay-confirm'] = id => {
    const t = M.paySubscription(id, state.payDraft);
    closeSheet(); render();
    U.toast(`<b>${M.sub(id).name} paid · ${M.fmt(t.amountMinor, t.currency)}</b>`, 'View', 'open-txn:' + t.id);
  };

  /* categories */
  A['open-sheet:CAT-002'] = id => {
    const c = id ? M.category(id) : null;
    state.catDraft = c ? Object.assign({}, c) : { name: '', type: state.catTab, icon: 'cart', colorIdx: 1 };
    state.sheet = 'CAT-002'; render();
  };
  A['cat-type'] = t => { state.catDraft.type = t; render(); };
  A['cat-save'] = () => {
    const d = state.catDraft;
    M.D.CATEGORIES.push({ id: M.nextId('c'), name: d.name.trim(), type: d.type,
      icon: d.icon, colorIdx: d.colorIdx, system: false });
    if (state.picker && state.picker.kind === 'category') { /* inline creation */ }
    closeSheet(); render(); U.toast('<b>Category saved.</b>');
  };
  A['cat-save-edit'] = () => {
    const d = state.catDraft, c = M.category(d.id);
    Object.assign(c, { name: d.name.trim(), icon: d.icon, colorIdx: d.colorIdx, type: d.type });
    closeSheet(); render(); U.toast('<b>Category saved.</b>');
  };
  A['cat-delete'] = id => {
    const i = M.D.CATEGORIES.findIndex(c => c.id === id);
    if (i >= 0) M.D.CATEGORIES.splice(i, 1);
    closeSheet(); render(); U.toast('<b>Category deleted.</b>');
  };
  A['cat-hide'] = id => { const c = M.category(id); c.hidden = !c.hidden; closeSheet(); render();
    U.toast(c.hidden ? '<b>Category hidden.</b>' : '<b>Category shown.</b>'); };
  A['open-reassign'] = id => { state.sheetCtx = { id }; state.reassignTo = null; state.sheet = 'CAT-003'; render(); };
  A['reassign-pick'] = id => { state.reassignTo = id; render(); };
  A['reassign-commit'] = fromId => {
    const to = state.reassignTo;
    M.D.TRANSACTIONS.forEach(t => { if (t.categoryId === fromId) t.categoryId = to; });
    M.D.SPLITS.forEach(s => { if (s.categoryId === fromId) s.categoryId = to; });
    M.D.BUDGETS.forEach(b => { if (b.categoryId === fromId) b.categoryId = to; });
    M.D.SUBSCRIPTIONS.forEach(s => { if (s.categoryId === fromId) s.categoryId = to; });
    const i = M.D.CATEGORIES.findIndex(c => c.id === fromId);
    const name = i >= 0 ? M.D.CATEGORIES[i].name : '';
    if (i >= 0) M.D.CATEGORIES.splice(i, 1);
    closeSheet(); render();
    U.toast(`<b>Moved.</b> Everything from ${name} is now in ${M.category(to).name}.`);
  };

  /* settings */
  A['open-sheet:SET-002'] = () => { state.sheet = 'SET-002'; render(); };
  A['open-sheet:SET-003'] = () => { state.sheet = 'SET-003'; render(); };
  A['open-sheet:SET-005'] = () => { state.sheet = 'SET-005'; render(); };
  A['open-sheet:SET-006'] = () => { state.sheet = 'SET-006'; render(); };
  A['profile-save'] = () => { closeSheet(); render(); U.toast('<b>Profile updated.</b>'); };
  A['set-reporting-currency'] = c => {
    M.D.PROFILE.reportingCurrency = c; closeSheet(); render();
    U.toast(`<b>Default currency set to ${c}.</b> Totals now show in ${c}.`);
  };
  A['set-theme'] = t => {
    M.D.PROFILE.theme = t;
    const root = document.documentElement;
    if (t === 'system') root.removeAttribute('data-theme'); else root.setAttribute('data-theme', t);
    closeSheet(); render();
  };
  A['set-language'] = l => { M.D.PROFILE.language = l; closeSheet(); render(); U.toast('<b>Language updated.</b>'); };
  A['notif-toggle'] = k => {
    M.D.PROFILE.notifications = M.D.PROFILE.notifications || {};
    M.D.PROFILE.notifications[k] = M.D.PROFILE.notifications[k] === false ? true : false;
    render();
  };
  A['sign-out'] = () => {
    state.stacks = { home: [], accounts: [], spaces: [], activity: [] };
    state.tab = 'home'; go('AUTH-002', {}, { replace: true });
  };

  /* notifications */
  A['notif-read-all'] = () => { M.D.NOTIFICATIONS.forEach(n => n.read = true); render(); };
  A['notif-open'] = id => {
    const n = M.D.NOTIFICATIONS.find(x => x.id === id);
    if (!n) return;
    n.read = true;
    const t = n.target;
    if (!t) { render(); return; }
    if (t.screen === 'SETL-006') { state.sheetCtx = { id: t.id }; state.sheet = 'SETL-006'; render(); }
    else if (t.screen === 'SETL-005') { state.sheetCtx = { id: t.id }; state.sheet = 'SETL-005'; render(); }
    else if (t.screen === 'SPACE-010') go('SPACE-010', { id: t.id });
    else if (t.screen === 'BUD-002') go('BUD-002', { id: t.id });
    else if (t.screen === 'AI-007') go('AI-007', {});
    else if (t.screen === 'SPACE-009') go('SPACE-009', {});
    else render();
  };
  A['notif-permission-yes'] = () => { closeSheet(); U.toast('<b>Notifications on.</b>'); };

  /* AI */
  A['ai-resume'] = id => { M.conn(id).status = 'ACTIVE'; render(); U.toast('<b>Resumed.</b>'); };
  A['ai-disconnect'] = id => {
    const c = M.conn(id); c.status = 'REVOKED';
    if (state.screen === 'AI-004' || state.screen === 'AI-005') { state.stacks[state.tab] = state.stacks[state.tab]
      .filter(s => s.screen !== 'AI-004' && s.screen !== 'AI-005'); go('AI-001', {}, { replace: true }); }
    else render();
    U.toast(`<b>${c.clientName} disconnected.</b> Its changes stay in your records.`);
  };
  A['ai-disconnect-all'] = () => {
    M.D.AI_CONNECTIONS.forEach(c => c.status = 'REVOKED');
    render(); U.toast('<b>All apps disconnected.</b>');
  };
  A['go:AI-005'] = id => {
    const c = M.conn(id);
    const has = k => ({ A: ['profile:read'], B: ['spaces:read'], C: ['budgets:read'],
      D: ['transactions:write'], E: ['budgets:write'], F: ['settlements:write'] })[k]
      .some(s => c.scopes.includes(s));
    state.permDraft = { groups: { A: has('A'), B: has('B'), C: has('C'), D: has('D'), E: has('E'), F: has('F') },
      perTxn: c.limits.perTxnMinor || 20000, daily: c.limits.dailyTotalMinor || 100000 };
    go('AI-005', { id });
  };
  A['perm-group'] = k => { state.permDraft.groups[k] = !state.permDraft.groups[k]; render(); };
  A['perm-save'] = id => {
    const c = M.conn(id), d = state.permDraft;
    const map = { A: ['profile:read','accounts:read','transactions:read','analytics:read'],
      B: ['spaces:read','balances:read','settlements:read'], C: ['budgets:read','subscriptions:read'],
      D: ['transactions:write','expenses:write','subscriptions:write'], E: ['budgets:write'], F: ['settlements:write'] };
    c.scopes = Object.keys(d.groups).filter(k => d.groups[k]).reduce((a, k) => a.concat(map[k]), []);
    c.limits.perTxnMinor = d.perTxn; c.limits.dailyTotalMinor = d.daily;
    back(); U.toast('<b>Permissions updated.</b>');
  };
  A['approval-approve'] = id => {
    const a = M.D.AI_APPROVALS.find(x => x.id === id);
    if (!a) return;
    a.state = 'APPROVED';
    if (a.payload.kind === 'SETTLEMENT') {
      M.confirmSettlement({ spaceId: a.payload.spaceId, fromUserId: a.payload.fromUserId,
        toUserId: a.payload.toUserId, amountMinor: a.payload.amountMinor,
        accountId: a.payload.accountId, source: 'mcp' });
    }
    M.D.AI_ACTIVITY.unshift({ id: M.nextId('aa'), connectionId: a.connectionId, client: a.client,
      at: M.TODAY + 'T' + new Date().toTimeString().slice(0, 5), gate: 'in_app',
      action: a.summary, context: M.space(a.payload.spaceId).name, outcome: 'SUCCESS',
      target: null });
    const n = M.D.NOTIFICATIONS.find(x => x.type === 'AI_APPROVAL'); if (n) n.read = true;
    render();
    U.toast('<b>Approved and recorded.</b> ' + a.client + ' has been told.');
  };
  A['approval-reject'] = id => {
    const a = M.D.AI_APPROVALS.find(x => x.id === id);
    if (a) a.state = 'REJECTED';
    const n = M.D.NOTIFICATIONS.find(x => x.type === 'AI_APPROVAL'); if (n) n.read = true;
    render(); U.toast('<b>Rejected.</b> Nothing was changed.');
  };
  A['go:AI-003'] = () => {
    state.consent = { clientName: 'Finance Copilot', host: 'copilot.example.com', verified: false,
      groups: { A: true, B: true, C: true, D: false, E: false, F: false },
      perTxn: 20000, daily: 100000 };
    go('AI-003', {});
  };
  A['consent-group'] = k => {
    const c = state.consent;
    c.groups[k] = !c.groups[k];
    if (k === 'D' && c.groups.D && M.activeSpaces().length) c.groups.B = true;
    render();
  };
  A['consent-approve'] = () => {
    const c = state.consent;
    const map = { A: ['profile:read','accounts:read','transactions:read','analytics:read'],
      B: ['spaces:read','balances:read','settlements:read'], C: ['budgets:read','subscriptions:read'],
      D: ['transactions:write','expenses:write','subscriptions:write'], E: ['budgets:write'], F: ['settlements:write'] };
    M.D.AI_CONNECTIONS.push({ id: M.nextId('con'), clientId: 'copilot', clientName: c.clientName,
      verified: c.verified, status: 'ACTIVE',
      scopes: Object.keys(c.groups).filter(k => c.groups[k]).reduce((a, k) => a.concat(map[k]), []),
      limits: { perTxnMinor: c.perTxn, dailyTotalMinor: c.daily, dailyCount: 50,
        usedTodayMinor: 0, usedTodayCount: 0, spaces: 'ALL', accounts: 'ALL' },
      createdAt: M.TODAY, lastUsedAt: null, writeCount: 0, readCount: 0 });
    state.tab = 'home'; state.stacks.home = [];
    go('AI-001', {}, { replace: true });
    U.toast('<b>' + c.clientName + ' connected.</b>');
  };
  A['consent-deny'] = () => { back(); U.toast('Not connected.'); };

  /* onboarding */
  A['auth-signin'] = () => {
    state.onb = { step: 1, countryName: 'Germany', currency: 'EUR',
      accType: 'BANK', accName: 'Bank account', accBalance: 0,
      wantSpace: false, spaceType: 'COUPLE', spaceName: 'Us', spaceCurrency: 'EUR',
      createdSpace: false, token: null };
    go('ONB-001', {}, { replace: true });
  };
  A['auth-retry'] = () => go('AUTH-002', {}, { replace: true });
  A['onb-country'] = () => U.toast('Country picker — Germany is preselected from your device.');
  A['onb-acctype'] = t => {
    state.onb.accType = t;
    state.onb.accName = t === 'BANK' ? 'Bank account' : t[0] + t.slice(1).toLowerCase();
    render();
  };
  A['onb-spacetype'] = t => {
    const names = { COUPLE: 'Us', HOUSEHOLD: 'Home', TRIP: 'Trip', FAMILY: 'Family', OTHER: '' };
    state.onb.spaceType = t; state.onb.spaceName = names[t]; render();
  };
  A['onb-want-space'] = () => { state.onb.wantSpace = true; render(); };
  A['onb-skip-space'] = () => go('ONB-006', {}, { replace: true });
  A['onb-create-space'] = () => {
    state.onb.createdSpace = true; state.onb.token = 'new8fK';
    go('ONB-005', {}, { replace: true });
  };
  A['onb-next'] = () => {
    const order = ['ONB-001','ONB-002','ONB-003','ONB-004','ONB-005','ONB-006'];
    const i = order.indexOf(state.screen);
    go(order[Math.min(i + 1, order.length - 1)], {}, { replace: true });
  };
  A['onb-finish'] = () => {
    /* Onboarding is a demo of the flow — the seeded dataset is what the app runs on. */
    state.tab = 'home'; state.stacks = { home: [], accounts: [], spaces: [], activity: [] };
    go('HOME-001', {}, { replace: true });
    setTimeout(() => U.toast('<b>Welcome.</b> Tap ＋ to add an expense, and turn on "Share this" to split it.'), 400);
  };

  /* menus (overflow) — rendered as dialogs for simplicity */
  const MENUS = {
    accounts: () => [['Reorder accounts', 'start-reorder']],
    account: () => { const a = M.account(state.ctx.id); const has = M.ledger({ accountId: a.id }).length;
      return [['Edit account', 'open-sheet:ACC-004|' + a.id],
        [a.archived ? 'Restore account' : 'Archive account', a.archived ? 'restore-account|' + a.id : 'dlg:DLG-004|' + a.id],
        ...(has ? [] : [['Delete account', 'dlg:DLG-005|' + a.id]])]; },
    txn: () => { const t = M.txn(state.ctx.id);
      return [['Duplicate', 'duplicate-txn|' + t.id],
        ['Delete', (t.splitId ? 'dlg:DLG-003|' : 'dlg:DLG-002|') + t.id]]; },
    split: () => { const x = M.split(state.ctx.id);
      return x.createdBy === M.ME
        ? [['Delete for everyone', 'dlg:DLG-003|' + x.id]]
        : [['Only ' + M.userName(x.createdBy) + ' can change this', 'noop']]; },
    space: () => { const s = M.space(state.ctx.id);
      return [['Members', 'go:SPACE-007|' + s.id], ['Space settings', 'go:SPACE-006|' + s.id],
        ['Settlement history', 'go:SETL-004|' + s.id], ['Leave space', 'dlg:DLG-008|' + s.id]]; },
    budget: () => [['Delete budget', 'dlg:DLG-012|' + state.ctx.id]],
    sub: () => { const s = M.sub(state.ctx.id);
      return [[s.status === 'PAUSED' ? 'Resume' : 'Pause', 'sub-toggle-pause|' + s.id],
        ['Delete subscription', 'dlg:DLG-013|' + s.id]]; },
    ai: () => [['Disconnect all apps', 'dlg:DLG-020']]
  };
  A['start-reorder'] = () => { state.reorder = true; state.menu = null; render(); };
  A['duplicate-txn'] = id => {
    const d = draftFromTxn(M.txn(id)); d.editId = null; d.occurredOn = M.TODAY;
    state.draft = d; state.menu = null; state.sheet = 'TXN-003'; render();
  };
  A['noop'] = () => { state.menu = null; render(); };

  /* ── event delegation ─────────────────────────────────── */
  document.addEventListener('click', e => {
    const el = e.target.closest('[data-act]');
    if (!el || el.disabled) return;
    let act = el.getAttribute('data-act');
    let arg = el.getAttribute('data-arg');
    if (act.includes('|')) { const p = act.split('|'); act = p[0]; arg = p[1]; }
    e.preventDefault();
    /* Note the control now, while it is still in the DOM — if this opens an
       overlay, this is where focus goes back to when the overlay closes. */
    lastClickSelector = (el.closest('#screen') || el.closest('#nav')) ? openerSelector(el) : null;
    /* Every dispatch path runs inside the boundary — a throwing action must
       not leave the app wedged half-way through a transition. */
    safe(() => dispatch(act, arg), () => {
      U.toast("Sorry — that didn't work. Nothing was changed.");
      render();
    }, 'action ' + act);
  });

  function dispatch(act, arg) {
    if (act.startsWith('tab:')) return switchTab(act.slice(4));
    if (act.startsWith('go:')) {
      const target = act.slice(3);
      if (A['go:' + target]) return A['go:' + target](arg);
      return go(target, arg ? { id: arg } : {});
    }
    if (act.startsWith('menu:')) {
      const items = safe(() => MENUS[act.slice(5)](), () => null, act);
      if (!items) return U.toast("That record isn't available any more.");
      state.menu = items; renderMenu(items); return;
    }
    if (act.startsWith('dlg:')) {
      state.dialog = act.slice(4); state.dialogArg = arg; state.typeConfirm = ''; state.menu = null;
      document.getElementById('menu').classList.remove('is-on');
      return render();
    }
    if (act.startsWith('open-sheet:')) {
      const id = act.slice(11);
      if (A['open-sheet:' + id]) return A['open-sheet:' + id](arg);
      state.sheetCtx = arg ? { id: arg } : {};
      state.sheet = id; return render();
    }
    if (act.startsWith('open-picker:')) {
      const fn = A[act]; if (fn) return fn(arg);
    }
    if (act.startsWith('open-txn:')) return A['open-txn'](act.slice(9));
    if (act.startsWith('txn-restore:')) { M.restoreTransaction(act.slice(12)); return render(); }
    if (act.startsWith('acc-unarchive:')) {
      const a = M.account(act.slice(14));
      if (a) a.archived = false;
      return render();
    }
    if (A[act]) return A[act](arg);
    console.warn('Unhandled action:', act);
  }

  /* live inputs */
  document.addEventListener('input', e => {
    const el = e.target.closest('[data-live]');
    if (!el) return;
    const kind = el.getAttribute('data-live');
    const arg = el.getAttribute('data-arg');
    const v = el.value;
    const dec = c => Math.pow(10, M.cur(c).decimals);
    switch (kind) {
      case 'search': state.search = v; renderPartial(); return;
      case 'acc-name': state.accDraft.name = v; state.accDraft.nameTouched = true;
        delete state.accDraft.errName; syncSaveState(); return;
      case 'acc-opening': state.accDraft.opening = Math.round((+v || 0) * dec(state.accDraft.currency)); return;
      case 'space-name': state.spaceDraft.name = v; state.spaceDraft.nameTouched = true; syncSaveState(); return;
      case 'space-rename': M.space(state.ctx.id).name = v; return;
      case 'bud-amount': state.budgetDraft.amount = Math.round((+v || 0) *
        dec(budgetCurrency()));
        syncSaveState(); return;
      case 'bud-name': state.budgetDraft.name = v; state.budgetDraft.nameTouched = true; syncSaveState(); return;
      case 'sub-name': state.subDraft.name = v; syncSaveState(); return;
      case 'sub-amount': state.subDraft.amount = Math.round((+v || 0) *
        dec(M.account(state.subDraft.accountId).currency)); syncSaveState(); return;
      case 'cad-day': state.subDraft.cadence.dayOfMonth = Math.max(1, Math.min(31, +v || 1)); return;
      case 'cat-name': state.catDraft.name = v; syncSaveState(); return;
      case 'pay-amount': state.payDraft.amount = Math.round((+v || 0) * dec(M.sub(state.sheetCtx.id).currency)); return;
      case 'settle-amount': state.settleDraft.amount = Math.round((+v || 0) *
        dec(M.space(state.ctx.id).currency)); renderPartial(); return;
      case 'split-exact': state.draft.splitValues.exact[arg] = Math.round((+v || 0) *
        dec((M.space(state.draft.spaceId) || {}).currency)); renderRemainder(); return;
      case 'split-pct': state.draft.splitValues.percent[arg] = +v || 0; renderRemainder(); return;
      case 'ds-pct': state.dsDraft.shares[arg] = +v || 0; renderPartial(); return;
      case 'profile-name': M.D.PROFILE.displayName = v; return;
      case 'consent-pertxn': state.consent.perTxn = Math.round((+v || 0) * 100); return;
      case 'consent-daily': state.consent.daily = Math.round((+v || 0) * 100); return;
      case 'perm-pertxn': state.permDraft.perTxn = Math.round((+v || 0) * 100); return;
      case 'perm-daily': state.permDraft.daily = Math.round((+v || 0) * 100); return;
      case 'onb-accname': state.onb.accName = v; syncSaveState(); return;
      case 'onb-accbalance': state.onb.accBalance = +v || 0; return;
      case 'onb-spacename': state.onb.spaceName = v; syncSaveState(); return;
      case 'type-confirm': state.typeConfirm = v; syncSaveState(); return;
      /* Updated in place rather than re-rendered — a re-render would take the
         caret with it. */
      case 'note': state.noteDraft = v.slice(0, NOTE_MAX);
        { const c = document.getElementById('noteCount');
          if (c) c.textContent = (NOTE_MAX - state.noteDraft.length) + ' left';
          const clr = document.querySelector('[data-act="note-clear"]');
          if (clr) clr.disabled = !state.noteDraft; }
        return;
    }
  });

  /* Re-render without stealing focus from the field being typed in. */
  function renderPartial() {
    const active = document.activeElement;
    const id = active && active.getAttribute && active.getAttribute('data-live');
    const arg = active && active.getAttribute && active.getAttribute('data-arg');
    const pos = active && active.selectionStart;
    render();
    if (id) {
      const next = document.querySelector(`[data-live="${id}"]${arg ? `[data-arg="${arg}"]` : ''}`);
      if (next) { next.focus(); try { next.setSelectionRange(pos, pos); } catch (err) {} }
    }
  }
  /* Split editor: update only the remainder bar and Done state. */
  function renderRemainder() {
    const d = state.draft, sp = M.space(d.spaceId);
    const ids = sp.members.map(m => m.userId);
    const shares = M.computeShares(d.amount, d.method, ids, d.splitValues, d.payerUserId);
    const sum = shares.reduce((a, x) => a + x.amountMinor, 0);
    const pctSum = ids.filter(i => d.splitValues.included[i])
      .reduce((a, i) => a + (+d.splitValues.percent[i] || 0), 0);
    const balanced = d.method === 'PERCENTAGE' ? pctSum === 100 : sum === d.amount;
    const rem = document.querySelector('#sheet2 .remainder') || document.querySelector('#sheet .remainder');
    if (rem) {
      rem.className = 'remainder ' + (balanced ? 'is-ok' : 'is-bad');
      const txt = balanced
        ? '✓ ' + (d.method === 'PERCENTAGE' ? '100% assigned' : M.fmt(d.amount, sp.currency) + ' assigned')
        : d.method === 'PERCENTAGE'
          ? (pctSum < 100 ? (100 - pctSum) + '% left to assign' : (pctSum - 100) + '% over')
          : (sum < d.amount ? M.fmt(d.amount - sum, sp.currency) + ' left to assign'
             : M.fmt(sum - d.amount, sp.currency) + ' over');
      const span = rem.querySelector('.remainder-t span');
      if (span) span.textContent = txt;
      const bar = rem.querySelector('.sr, .track');
      if (bar) bar.outerHTML = balanced && d.amount ? U.shareRuleSegmented(shares, d.amount)
        : `<span class="track"><span class="fill fill--over" style="width:${Math.min(100, sum / (d.amount || 1) * 100)}%"></span></span>`;
    }
    const done = document.querySelector('#sheet2 .sheet-btn--strong') || document.querySelector('#sheet .sheet-btn--strong');
    if (done) done.disabled = !balanced;
  }
  /* Enable/disable a sheet's save button after a keystroke. */
  function syncSaveState() {
    const el = document.querySelector('#sheet .sheet-btn--strong');
    if (!el) { renderPartial(); return; }
    renderPartial();
  }

  function renderMenu(items) {
    const m = document.getElementById('menu');
    m.innerHTML = `<div class="dialog menu-card" role="menu" aria-label="More actions">
      ${items.map(([label, act]) => `<button class="row" role="menuitem" data-act="${act}" style="border-radius:8px">
        <span class="row-body"><span class="row-title" style="font-size:14px">${U.esc(label)}</span></span></button>`).join('')}
      <button class="btn btn--tertiary btn--block" data-act="close-menu" style="margin-top:4px">Cancel</button>
    </div>`;
    m.classList.add('is-on');
    const first = m.querySelector('button');
    if (first) first.focus({ preventScroll: true });
  }
  A['close-menu'] = () => { document.getElementById('menu').classList.remove('is-on'); };
  document.addEventListener('click', e => {
    const m = document.getElementById('menu');
    if (m.classList.contains('is-on') && e.target === m) m.classList.remove('is-on');
    const inMenu = e.target.closest('#menu .row');
    if (inMenu) setTimeout(() => m.classList.remove('is-on'), 0);
  });
  document.getElementById('scrim').addEventListener('click', closeSheet);

  /* ── stage tools ──────────────────────────────────────── */
  window.PK = {
    theme: () => {
      const r = document.documentElement;
      const cur = r.getAttribute('data-theme') || 'light';
      r.setAttribute('data-theme', cur === 'dark' ? 'light' : 'dark');
    },
    onboarding: () => { state.stacks = { home: [], accounts: [], spaces: [], activity: [] };
      go('AUTH-002', {}, { replace: true }); },
    consent: () => A['go:AI-003'](),
    reset: () => { clearStore(); location.reload(); },
    goto: id => { dismissOverlays(); state.screen = id; render(); },
    /* exposed for the audit in AUDIT.md — lets a test resolve every data-act */
    actions: A, dialogs: DIALOGS, screens: S, state: state, render: render
  };

  /* ── boot ─────────────────────────────────────────────── */
  state.screen = 'HOME-001';
  const resumed = restore();
  /* The saved theme has to be on the root before the first paint. */
  const savedTheme = M.D.PROFILE.theme;
  if (savedTheme && savedTheme !== 'system') document.documentElement.setAttribute('data-theme', savedTheme);
  state.booted = true;
  try {
    history.replaceState({ pk: state.screen }, '', location.href);
    historyReady = true;
  } catch (err) {
    console.info('[pockito] history is unavailable here — the system back button will not map to in-app back');
  }
  render();
  if (resumed) console.info('[pockito] resumed the previous session from localStorage');
})();
