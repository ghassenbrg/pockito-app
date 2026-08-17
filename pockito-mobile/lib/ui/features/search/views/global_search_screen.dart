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
    final hits = viewModel.search(_query);
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
                              PkCard(
                                padding: EdgeInsets.zero,
                                child: Column(
                                  children: [
                                    for (final hit in entry.value)
                                      ListTile(
                                        key: ValueKey('hit_${hit.id}'),
                                        leading: PkIconTile(
                                          icon: hit.icon,
                                          color: PkPalette.categoryAt(
                                            hit.colorIndex,
                                          ),
                                          size: 40,
                                          iconSize: 19,
                                        ),
                                        title: Text(
                                          hit.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: hit.subtitle.isEmpty
                                            ? null
                                            : Text(
                                                hit.subtitle,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                        trailing:
                                            hit.amountMinor == null ||
                                                hit.currency == null
                                            ? const Icon(
                                                Icons.chevron_right_rounded,
                                              )
                                            : Text(
                                                PkFormat.money(
                                                  hit.amountMinor!,
                                                  hit.currency!,
                                                ),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge
                                                    ?.copyWith(
                                                      fontFeatures: const [
                                                        FontFeature.tabularFigures(),
                                                      ],
                                                    ),
                                              ),
                                        onTap: () => context.push(hit.route),
                                      ),
                                  ],
                                ),
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
