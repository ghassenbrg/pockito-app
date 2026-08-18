import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/pockito_app_view_model.dart';
import '../../../core/components/pk_components.dart';
import '../../../core/design_system/pk_format.dart';
import '../../../core/design_system/pk_labels.dart';
import '../../../core/design_system/pk_tokens.dart';

/// One place to look for anything.
///
/// The magnifying glass on Home used to route to Activity, which searches
/// transactions and nothing else — so an account, a Space or a budget could
/// not be found by name at all.
class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  late String _query = widget.initialQuery;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PockitoAppViewModel>();
    final hits = viewModel.search(_query, context.t);
    // Grouped by kind so a name that exists in three places is not three
    // indistinguishable rows.
    final grouped = <String, List<PkSearchHit>>{};
    for (final hit in hits) {
      grouped.putIfAbsent(hit.kind, () => []).add(hit);
    }
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.searchTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: PkSize.contentMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(PkSpacing.screen),
                  child: PkSearchField(
                    value: _query,
                    autofocus: true,
                    hintText: context.t.searchHintGlobal,
                    resultCount: _query.trim().length < 2 ? null : hits.length,
                    onChanged: (value) => setState(() => _query = value),
                  ),
                ),
                Expanded(
                  child: _query.trim().length < 2
                      ? PkEmptyState(
                          icon: Icons.search_rounded,
                          title: context.t.searchEmptyTitle,
                          message: context.t.searchEmptyBody,
                        )
                      : hits.isEmpty
                      ? PkEmptyState(
                          icon: Icons.search_off_rounded,
                          title: context.t.searchNoMatchTitle(_query.trim()),
                          message: context.t.searchNoMatchBody,
                        )
                      : ListView(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            PkSpacing.screen,
                            0,
                            PkSpacing.screen,
                            PkSpacing.x8,
                          ),
                          children: [
                            for (final entry in grouped.entries) ...[
                              PkSectionHeader(
                                title: entry.key,
                                trailing: Text(
                                  '${entry.value.length}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              // C-11: results are objects in a list, so they
                              // wear the same row as every other list in the
                              // app — one announcement each, the row height
                              // contract, and the on-contract icon tile.
                              PkGroupedSurface(
                                indent:
                                    PkSpacing.x4 +
                                    PkSize.iconTileDense +
                                    PkSpacing.x3,
                                children: [
                                  for (final hit in entry.value)
                                    PkLedgerRow(
                                      key: ValueKey('hit_${hit.id}'),
                                      semanticIdentifier: 'hit_${hit.id}',
                                      semanticLabel: [
                                        hit.title,
                                        if (hit.subtitle.isNotEmpty)
                                          hit.subtitle,
                                        if (hit.amountMinor != null &&
                                            hit.currency != null)
                                          PkFormat.money(
                                            hit.amountMinor!,
                                            hit.currency!,
                                          ),
                                      ].join(', '),
                                      leading: PkIconTile(
                                        icon: hit.icon,
                                        accent: PkPalette.categoryAt(
                                          hit.colorIndex,
                                        ),
                                      ),
                                      title: hit.title,
                                      subtitle: hit.subtitle.isEmpty
                                          ? null
                                          : hit.subtitle,
                                      trailing:
                                          hit.amountMinor == null ||
                                              hit.currency == null
                                          ? null
                                          : PkAmountText(
                                              amountMinor: hit.amountMinor!,
                                              currency: hit.currency!,
                                            ),
                                      showChevron:
                                          hit.amountMinor == null ||
                                          hit.currency == null,
                                      onTap: () => context.push(hit.route),
                                    ),
                                ],
                              ),
                              const SizedBox(height: PkSpacing.x5),
                            ],
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
