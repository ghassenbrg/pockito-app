import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/models/financial_models.dart';
import '../design_system/pk_labels.dart';
import '../design_system/pk_tokens.dart';
import 'pk_components.dart';

/// Feedback on selection, success and destruction.
///
/// Every call is a no-op on a platform without haptics, so screens can ask for
/// one without checking first.
abstract final class PkHaptics {
  /// Mirrors the user's preference so a single switch silences the whole app.
  static bool enabled = true;

  static void selection() {
    if (enabled) HapticFeedback.selectionClick();
  }

  static void success() {
    if (enabled) HapticFeedback.lightImpact();
  }

  static void warning() {
    if (enabled) HapticFeedback.mediumImpact();
  }

  static void error() {
    if (enabled) HapticFeedback.heavyImpact();
  }
}

/// The band that sits above a surface nobody can write to.
///
/// Archived Spaces and viewer-role members get the same treatment, because the
/// user's question is the same in both cases: why are the buttons quiet?
class PkReadOnlyRibbon extends StatelessWidget {
  const PkReadOnlyRibbon({
    super.key,
    required this.title,
    required this.reason,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.lock_outline_rounded,
  });

  /// The ribbon for a Space, derived from why it is read-only.
  factory PkReadOnlyRibbon.forSpace({
    required SpacePermissions permissions,
    required bool archived,
    required String spaceName,
    required PkStrings t,
    VoidCallback? onReopen,
  }) {
    if (archived) {
      return PkReadOnlyRibbon(
        title: t.readOnlyArchivedTitle(spaceName),
        reason: t.readOnlyArchivedReason,
        icon: Icons.inventory_2_outlined,
        actionLabel: permissions.canArchive && onReopen != null
            ? t.actionReopen
            : null,
        onAction: onReopen,
      );
    }
    return PkReadOnlyRibbon(
      title: t.readOnlyViewerTitle,
      reason: t.readOnlyViewerReason,
      icon: Icons.visibility_outlined,
    );
  }

  final String title;
  final String reason;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    container: true,
    child: Container(
      padding: const EdgeInsets.all(PkSpacing.x4),
      decoration: BoxDecoration(
        color: context.pk.sunken,
        borderRadius: BorderRadius.circular(PkRadius.large),
        border: Border.all(color: context.pk.borderDefault),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: PkSize.icon, color: context.pk.textSecondary),
          const SizedBox(width: PkSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(reason, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(width: PkSpacing.x2),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    ),
  );
}

/// An inline explanation of why a control is disabled, naming who can help.
///
/// Disabled affordances stay visible rather than disappearing: a control that
/// vanishes teaches nothing, and the user is left wondering what they missed.
class PkDeniedNotice extends StatelessWidget {
  const PkDeniedNotice({
    super.key,
    required this.title,
    required this.reason,
    this.whoCanHelp = const [],
  });

  final String title;
  final String reason;
  final List<String> whoCanHelp;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(PkSpacing.x4),
    decoration: BoxDecoration(
      color: context.pk.sunken,
      borderRadius: BorderRadius.circular(PkRadius.large),
      border: Border.all(color: context.pk.borderSubtle),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.do_not_disturb_on_outlined,
          size: PkSize.icon,
          color: context.pk.textTertiary,
        ),
        const SizedBox(width: PkSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(reason, style: Theme.of(context).textTheme.bodySmall),
              if (whoCanHelp.isNotEmpty) ...[
                const SizedBox(height: PkSpacing.x2),
                Text(
                  whoCanHelp.length == 1
                      ? context.t.canDoThis(whoCanHelp.single)
                      : '${whoCanHelp.take(3).join(', ')} can do this.',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: context.pk.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

/// A control that stays visible when it cannot be used, and says why on tap.
///
/// Hiding a denied action makes the app look different for every role, which
/// is exactly what makes shared-money software hard to reason about.
class PkPermissionGate extends StatelessWidget {
  const PkPermissionGate({
    super.key,
    required this.allowed,
    required this.reason,
    required this.child,
    this.whoCanHelp = const [],
    this.title,
  });

  final bool allowed;
  final String reason;
  final List<String> whoCanHelp;
  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (allowed) return child;
    return Semantics(
      enabled: false,
      hint: reason,
      child: Tooltip(
        message: reason,
        child: Opacity(
          opacity: .45,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              PkHaptics.warning();
              showPkDeniedSheet(
                context,
                title: title ?? context.t.deniedDefaultTitle,
                reason: reason,
                whoCanHelp: whoCanHelp,
              );
            },
            child: IgnorePointer(child: child),
          ),
        ),
      ),
    );
  }
}

Future<void> showPkDeniedSheet(
  BuildContext context, {
  required String title,
  required String reason,
  List<String> whoCanHelp = const [],
}) => showPkSheet<void>(
  context,
  builder: (context) => _Sheet(
    icon: Icons.do_not_disturb_on_outlined,
    tone: context.pk.textSecondary,
    title: title,
    message: reason,
    footnote: whoCanHelp.isEmpty
        ? null
        : whoCanHelp.length == 1
        ? context.t.deniedWhoCanHelpOne(whoCanHelp.single)
        : context.t.deniedWhoCanHelpMany(whoCanHelp.take(3).join(', ')),
    primaryLabel: context.t.actionGotIt,
    onPrimary: () => Navigator.pop(context),
  ),
);

/// The sheet a write hits when there is no connection.
///
/// The copy is action-specific on purpose: "You're offline" tells the user
/// nothing about the thing they were in the middle of.
Future<void> showPkOfflineSheet(
  BuildContext context, {
  required String action,
  VoidCallback? onRetry,
}) => showPkSheet<void>(
  context,
  builder: (context) => _Sheet(
    icon: Icons.cloud_off_outlined,
    tone: context.pk.sharedStrong,
    mascot: KitoAsset.sleeping,
    title: context.t.offlineTitle(action),
    message: context.t.offlineBody,
    primaryLabel: onRetry == null
        ? context.t.actionGotIt
        : context.t.actionRetry,
    onPrimary: () {
      Navigator.pop(context);
      onRetry?.call();
    },
    secondaryLabel: onRetry == null ? null : context.t.offlineNotNow,
    onSecondary: () => Navigator.pop(context),
  ),
);

/// What the user picks when someone else changed the record underneath them.
enum PkConflictChoice { theirs, mine, merge }

/// Resolution for a write that lost a race.
///
/// The prototype has no second device, so `simulateRemoteEdit` is what makes
/// this reachable — but the sheet is the real one, and it exists before the
/// backend can return a 409 rather than after.
Future<PkConflictChoice?> showPkConflictSheet(
  BuildContext context, {
  required ConcurrentEditException conflict,
}) => showPkSheet<PkConflictChoice>(
  context,
  builder: (context) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        PkSpacing.x5,
        PkSpacing.x2,
        PkSpacing.x5,
        PkSpacing.x6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: PkIconTile(
              icon: Icons.merge_type_rounded,
              color: context.pk.warning,
              size: 56,
              iconSize: 26,
            ),
          ),
          const SizedBox(height: PkSpacing.x4),
          Text(
            context.t.conflictTitle(conflict.actorName),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: PkSpacing.x2),
          Text(
            context.t.conflictBody(conflict.entityLabel),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.pk.textSecondary),
          ),
          const SizedBox(height: PkSpacing.x5),
          _ConflictOption(
            key: const ValueKey('conflict_theirs'),
            icon: Icons.download_rounded,
            title: context.t.conflictKeepTheirs(conflict.actorName),
            detail: context.t.conflictKeepTheirsDetail,
            onTap: () => Navigator.pop(context, PkConflictChoice.theirs),
          ),
          _ConflictOption(
            key: const ValueKey('conflict_mine'),
            icon: Icons.upload_rounded,
            title: context.t.conflictKeepMine,
            detail: context.t.conflictKeepMineDetail,
            onTap: () => Navigator.pop(context, PkConflictChoice.mine),
          ),
          _ConflictOption(
            key: const ValueKey('conflict_merge'),
            icon: Icons.merge_rounded,
            title: context.t.conflictCompare,
            detail: context.t.conflictCompareDetail,
            onTap: () => Navigator.pop(context, PkConflictChoice.merge),
          ),
        ],
      ),
    ),
  ),
);

class _ConflictOption extends StatelessWidget {
  const _ConflictOption({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: PkSpacing.x3),
    child: PkCard(
      onTap: onTap,
      child: Row(
        children: [
          PkIconTile(
            icon: icon,
            color: Theme.of(context).colorScheme.primary,
            size: 40,
            iconSize: 19,
          ),
          const SizedBox(width: PkSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(detail, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Asks for a short reason before a consequential change.
///
/// Returns the reason (possibly empty) on confirm, or null if the user backed
/// out — so an empty reason and a cancellation are never confused.
Future<String?> showPkReasonSheet(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  String? hint,
  bool destructive = false,
  bool required = false,
}) {
  final controller = TextEditingController();
  return showPkSheet<String>(
    context,
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            PkSpacing.x5,
            PkSpacing.x2,
            PkSpacing.x5,
            PkSpacing.x6,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: PkSpacing.x2),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.pk.textSecondary,
                  ),
                ),
                const SizedBox(height: PkSpacing.x4),
                TextField(
                  key: const ValueKey('reason_field'),
                  controller: controller,
                  autofocus: true,
                  maxLength: 140,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: hint ?? context.t.reason,
                  ),
                  onChanged: (_) => setSheetState(() {}),
                  onSubmitted: (value) => Navigator.pop(context, value),
                ),
                const SizedBox(height: PkSpacing.x2),
                FilledButton(
                  key: const ValueKey('reason_confirm'),
                  style: destructive
                      ? FilledButton.styleFrom(
                          backgroundColor: context.pk.danger,
                        )
                      : null,
                  onPressed: required && controller.text.trim().isEmpty
                      ? null
                      : () => Navigator.pop(context, controller.text),
                  child: Text(confirmLabel),
                ),
                const SizedBox(height: PkSpacing.x2),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.t.keepItAsItIs),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ).whenComplete(() async {
    // The sheet's result arrives before its exit animation has removed the
    // field, so the controller has to outlive the route.
    await Future<void>.delayed(PkMotion.standard);
    controller.dispose();
  });
}

/// Confirmation for something that genuinely cannot be undone.
///
/// Typing the name is reserved for exactly these: everything reversible gets
/// an Undo instead, because a dialog that appears for every delete is one the
/// user stops reading.
Future<bool> showPkTypedConfirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmationWord,
  String? confirmLabel,
}) async {
  final controller = TextEditingController();
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: PkSpacing.x4),
            Text(
              context.t.typeToContinue(confirmationWord),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: PkSpacing.x2),
            TextField(
              key: const ValueKey('typed_confirm_field'),
              controller: controller,
              autofocus: true,
              autocorrect: false,
              decoration: InputDecoration(hintText: confirmationWord),
              onChanged: (_) => setDialogState(() {}),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.t.cancel),
          ),
          FilledButton(
            key: const ValueKey('typed_confirm_action'),
            style: FilledButton.styleFrom(backgroundColor: context.pk.danger),
            onPressed:
                controller.text.trim().toLowerCase() ==
                    confirmationWord.toLowerCase()
                ? () => Navigator.pop(context, true)
                : null,
            child: Text(confirmLabel ?? context.t.delete),
          ),
        ],
      ),
    ),
  );
  controller.dispose();
  return result ?? false;
}

/// A message with an Undo, shown after a reversible change.
void showPkUndoToast(
  BuildContext context, {
  required String message,
  required Future<void> Function() onUndo,
  Duration duration = const Duration(seconds: 6),
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      key: const ValueKey('undo_toast'),
      duration: duration,
      content: Text(message),
      action: SnackBarAction(
        label: PkStrings.of(context).actionUndo,
        onPressed: () {
          PkHaptics.selection();
          onUndo();
        },
      ),
    ),
  );
}

/// Confirmation with an icon, for a write that succeeded.
void showPkSuccessToast(BuildContext context, String message) {
  PkHaptics.success();
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      key: const ValueKey('success_toast'),
      content: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: PkSize.icon,
            color: context.pk.success,
          ),
          const SizedBox(width: PkSpacing.x3),
          Expanded(child: Text(message)),
        ],
      ),
    ),
  );
}

void showPkErrorToast(BuildContext context, String message) {
  PkHaptics.error();
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      key: const ValueKey('error_toast'),
      content: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: PkSize.icon,
            color: context.pk.danger,
          ),
          const SizedBox(width: PkSpacing.x3),
          Expanded(child: Text(message)),
        ],
      ),
    ),
  );
}

/// Runs a repository write and turns each way it can fail into the state the
/// audit asks for, instead of an exception the screen has to guess at.
///
/// It also guards against double submission: a second call with the same token
/// while the first is still running is dropped, so double-tapping Save cannot
/// create two records.
abstract final class PkGuardedAction {
  static final Set<String> _inFlight = <String>{};

  @visibleForTesting
  static bool isRunning(String token) => _inFlight.contains(token);

  @visibleForTesting
  static void resetForTesting() => _inFlight.clear();

  /// Runs a write that returns nothing, reporting whether it went through.
  ///
  /// `run` returns the write's value, which is `void` for most mutations —
  /// so callers that need to know whether it succeeded use this instead.
  static Future<bool> runVoid(
    BuildContext context,
    Future<void> Function() write, {
    String? token,
    String? successMessage,
    Future<void> Function()? onUndo,
    String? undoMessage,
  }) async {
    var ok = false;
    await run<bool>(
      context,
      () async {
        await write();
        ok = true;
        return true;
      },
      token: token,
      successMessage: successMessage,
      onUndo: onUndo,
      undoMessage: undoMessage,
    );
    return ok;
  }

  /// Returns the write's value, or null when it was refused or dropped.
  static Future<T?> run<T>(
    BuildContext context,
    Future<T> Function() write, {
    String? token,
    String? successMessage,
    Future<void> Function()? onUndo,
    String? undoMessage,
    Future<void> Function(PkConflictChoice choice)? onConflict,
  }) async {
    final key = token ?? '${context.hashCode}';
    if (_inFlight.contains(key)) return null;
    _inFlight.add(key);
    try {
      final value = await write();
      if (!context.mounted) return value;
      if (onUndo != null && undoMessage != null) {
        showPkUndoToast(context, message: undoMessage, onUndo: onUndo);
      } else if (successMessage != null) {
        showPkSuccessToast(context, successMessage);
      }
      return value;
    } on OfflineWriteException catch (error) {
      if (context.mounted) {
        await showPkOfflineSheet(context, action: error.action);
      }
      return null;
    } on PermissionDeniedException catch (error) {
      if (context.mounted) {
        await showPkDeniedSheet(
          context,
          title: context.t.youCanTX0(error.action),
          reason: error.reason,
          whoCanHelp: error.whoCanHelp ?? const [],
        );
      }
      return null;
    } on ConcurrentEditException catch (error) {
      if (!context.mounted) return null;
      final choice = await showPkConflictSheet(context, conflict: error);
      if (choice != null && onConflict != null) await onConflict(choice);
      return null;
    } on StateError catch (error) {
      if (context.mounted) showPkErrorToast(context, error.message);
      return null;
    } on ArgumentError catch (error) {
      if (context.mounted) {
        showPkErrorToast(
          context,
          error.message?.toString() ?? context.t.thatDidnTWork,
        );
      }
      return null;
    } finally {
      _inFlight.remove(key);
    }
  }
}

/// A save button that cannot be pressed twice into the same write.
class PkSubmitButton extends StatefulWidget {
  const PkSubmitButton({
    super.key,
    required this.label,
    required this.onSubmit,
    this.icon,
    this.enabled = true,
    this.disabledReason,
  });

  final String label;
  final Future<void> Function() onSubmit;
  final IconData? icon;
  final bool enabled;

  /// Shown instead of the label when the button is off, so the button always
  /// says what is missing rather than merely being grey.
  final String? disabledReason;

  @override
  State<PkSubmitButton> createState() => _PkSubmitButtonState();
}

class _PkSubmitButtonState extends State<PkSubmitButton> {
  bool _busy = false;

  Future<void> _run() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.onSubmit();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final off = !widget.enabled || _busy;
    return FilledButton.icon(
      onPressed: off ? null : _run,
      icon: _busy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : widget.icon == null
          ? null
          : Icon(widget.icon),
      label: Text(
        _busy
            ? context.t.saving
            : !widget.enabled && widget.disabledReason != null
            ? widget.disabledReason!
            : widget.label,
      ),
    );
  }
}

/// Skeleton, error and empty treatments a list screen can hand its state to.
///
/// Home had skeletons and nothing else did, which made every other screen
/// either flash or show nothing while it settled.
class PkListState extends StatelessWidget {
  const PkListState.loading({super.key, this.rows = 4})
    : _kind = _Kind.loading,
      title = null,
      message = null,
      icon = Icons.hourglass_empty_rounded,
      actionLabel = null,
      onAction = null;

  const PkListState.error({
    super.key,
    this.title,
    this.message,
    this.actionLabel,
    required this.onAction,
  }) : _kind = _Kind.error,
       rows = 0,
       icon = Icons.sync_problem_rounded;

  const PkListState.empty({
    super.key,
    required this.icon,
    required String this.title,
    required String this.message,
    this.actionLabel,
    this.onAction,
  }) : _kind = _Kind.empty,
       rows = 0;

  final _Kind _kind;
  final int rows;
  final IconData icon;

  /// Null on the error state, where the words come from the translations.
  final String? title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => switch (_kind) {
    // Section 6.13 and 9.8: the skeleton's geometry matches the rows it stands
    // in for — one grouped surface, rows at the real row height, separators in
    // the same places — so the swap to content causes no layout shift.
    _Kind.loading => Semantics(
      label: context.t.loading,
      liveRegion: true,
      child: PkGroupedSurface(
        indent: PkSpacing.x4 + PkSize.iconTileDense + PkSpacing.x3,
        children: [
          for (var index = 0; index < rows; index++)
            const SizedBox(
              height: PkSize.rowStandard,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: PkSpacing.x4,
                  vertical: PkSpacing.x3,
                ),
                child: _SkeletonRow(),
              ),
            ),
        ],
      ),
    ),
    _Kind.error => PkEmptyState(
      icon: Icons.sync_problem_rounded,
      title: title ?? context.t.thatDidnTLoad,
      message: message ?? context.t.theListIsStillOn,
      actionLabel: actionLabel ?? context.t.actionRetry,
      onAction: onAction,
    ),
    _Kind.empty => PkEmptyState(
      icon: icon,
      title: title ?? '',
      message: message ?? '',
      actionLabel: actionLabel,
      onAction: onAction,
    ),
  };
}

/// The shape of one ledger row while it is still loading: the icon tile, two
/// lines of text and the trailing amount, in their real positions.
class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) => const Row(
    children: [
      PkSkeleton(
        height: PkSize.iconTileDense,
        width: PkSize.iconTileDense,
        radius: PkRadius.control,
      ),
      SizedBox(width: PkSpacing.x3),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PkSkeleton(height: 12, width: 132, radius: PkRadius.small),
            SizedBox(height: PkSpacing.x1),
            PkSkeleton(height: 10, width: 96, radius: PkRadius.small),
          ],
        ),
      ),
      SizedBox(width: PkSpacing.x2),
      PkSkeleton(height: 12, width: 64, radius: PkRadius.small),
    ],
  );
}

enum _Kind { loading, error, empty }

class _Sheet extends StatelessWidget {
  const _Sheet({
    required this.icon,
    required this.tone,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.footnote,
    this.secondaryLabel,
    this.onSecondary,
    this.mascot,
  });

  final IconData icon;
  final Color tone;
  final String title;
  final String message;
  final String? footnote;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final KitoAsset? mascot;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        PkSpacing.x5,
        PkSpacing.x2,
        PkSpacing.x5,
        PkSpacing.x6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: mascot == null
                ? PkIconTile(icon: icon, color: tone, size: 56, iconSize: 26)
                : KitoImage.sized(asset: mascot!, size: KitoSize.state),
          ),
          const SizedBox(height: PkSpacing.x4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: PkSpacing.x2),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.pk.textSecondary),
          ),
          if (footnote != null) ...[
            const SizedBox(height: PkSpacing.x3),
            Text(
              footnote!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: context.pk.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: PkSpacing.x5),
          FilledButton(onPressed: onPrimary, child: Text(primaryLabel)),
          if (secondaryLabel != null) ...[
            const SizedBox(height: PkSpacing.x2),
            TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
          ],
        ],
      ),
    ),
  );
}
