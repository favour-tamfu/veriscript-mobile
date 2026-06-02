import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/vs_app_bar.dart';
import '../../../core/widgets/vs_card.dart';
import '../../../core/widgets/vs_empty_state.dart';
import '../../converter/data/conversion_repository.dart';
import '../data/history_repository.dart';
import '../domain/history_item.dart';

enum _FilterType { all, scans, conversions, translations, ocr }
enum _SortOrder { newest, oldest }
enum _StatusFilter { all, completed, failed }

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  bool _showSearch = false;
  String _searchQuery = '';
  _FilterType _filter = _FilterType.all;
  _SortOrder _sort = _SortOrder.newest;
  _StatusFilter _statusFilter = _StatusFilter.all;
  bool _isLoadingRemote = false;
  List<HistoryItem> _items = [];
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _loadRemoteHistory();
  }

  Future<void> _loadRemoteHistory({bool refresh = false}) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    setState(() {
      _isLoadingRemote = true;
      if (refresh) {
        _page = 0;
        _items = [];
      }
    });

    final repo = ref.read(historyRepositoryProvider);
    try {
      final items = await repo.fetchRemoteHistory(userId, page: _page);
      await repo.syncToLocal(items);
      if (!mounted) return;
      setState(() {
        _items = refresh ? items : [..._items, ...items];
        _isLoadingRemote = false;
      });
    } catch (_) {
      // Offline / fetch failed: fall back to the local cache if we have nothing.
      final fallback = _items.isEmpty ? await repo.fetchLocalHistory(userId) : _items;
      if (!mounted) return;
      setState(() {
        _items = fallback;
        _isLoadingRemote = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';

    return Scaffold(
      appBar: VsAppBar(
        title: isFrench ? 'Historique' : 'History',
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.search_off : Icons.search),
            onPressed: () => setState(() {
              _showSearch = !_showSearch;
              if (!_showSearch) _searchQuery = '';
            }),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context, isFrench),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showSearch)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: isFrench ? 'Rechercher des documents...' : 'Search documents...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.vsBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
            ),
          Expanded(child: _buildList(context, isFrench)),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, bool isFrench) {
    if (_isLoadingRemote && _items.isEmpty) {
      return _buildShimmer();
    }

    var items = _items;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      items = items.where((i) => i.name.toLowerCase().contains(q)).toList();
    }
    items = _applyFilters(items);

    if (items.isEmpty && !_isLoadingRemote) {
      return RefreshIndicator(
        onRefresh: () => _loadRemoteHistory(refresh: true),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: VsEmptyState(
                lottieAsset: 'assets/animations/empty.json',
                title: isFrench ? 'Aucun historique' : 'No history yet',
                subtitle: isFrench
                    ? 'Vos documents traités apparaîtront ici'
                    : 'Your processed documents will appear here',
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadRemoteHistory(refresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length + (_isLoadingRemote ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == items.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: AppColors.vsAccent),
              ),
            );
          }
          return _buildHistoryCard(context, items[index], isFrench);
        },
      ),
    );
  }

  List<HistoryItem> _applyFilters(List<HistoryItem> items) {
    var filtered = items;

    if (_filter != _FilterType.all) {
      final action = _filter.name.replaceAll('s', '');
      filtered = filtered.where((i) => i.action == action || i.action == _filter.name).toList();
    }

    if (_statusFilter == _StatusFilter.completed) {
      filtered = filtered.where((i) => i.status == 'done').toList();
    } else if (_statusFilter == _StatusFilter.failed) {
      filtered = filtered.where((i) => i.status == 'failed').toList();
    }

    if (_sort == _SortOrder.oldest) {
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return filtered;
  }

  Widget _buildHistoryCard(BuildContext context, HistoryItem item, bool isFrench) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: AppColors.vsError,
        child: const Icon(Icons.delete_forever, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(isFrench ? 'Supprimer?' : 'Delete this document?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(isFrench ? 'Annuler' : 'Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(isFrench ? 'Supprimer' : 'Delete',
                        style: const TextStyle(color: AppColors.vsError)),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) {
        setState(() => _items.removeWhere((i) => i.id == item.id));
        ref.read(historyRepositoryProvider).deleteDocument(
              item.documentId,
              '',
              Supabase.instance.client.auth.currentUser?.id ?? '',
            );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFrench ? 'Document supprimé' : 'Document deleted'),
            action: SnackBarAction(
              label: isFrench ? 'Annuler' : 'Undo',
              onPressed: () {},
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openItem(context, item, isFrench),
          child: VsCard(
            child: Row(
              children: [
                _buildActionIcon(item.action),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _buildSubtitle(item, isFrench),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsGray),
                      ),
                      Text(
                        DateFormat.yMMMd().add_jm().format(item.createdAt.toLocal()),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.vsGray, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusChip(context, item.status, isFrench),
                const Icon(Icons.chevron_right, color: AppColors.vsGray, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcon(String action) {
    final (icon, color) = switch (action) {
      'scan' => (Icons.document_scanner_rounded, AppColors.vsPrimary),
      'convert' => (Icons.swap_horiz_rounded, AppColors.vsAccent),
      'translate' => (Icons.translate_rounded, AppColors.vsCta),
      'ocr' => (Icons.camera_alt_rounded, AppColors.vsWarning),
      _ => (Icons.article_rounded, AppColors.vsGray),
    };

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status, bool isFrench) {
    final color = status == 'done' ? AppColors.vsSuccess : status == 'failed' ? AppColors.vsError : AppColors.vsWarning;
    final label = status == 'done'
        ? (isFrench ? 'Terminé' : 'Done')
        : status == 'failed'
            ? (isFrench ? 'Échoué' : 'Failed')
            : (isFrench ? 'En cours' : 'Processing');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }

  void _openItem(BuildContext context, HistoryItem item, bool isFrench) {
    // A completed scan opens the full Originality Report directly.
    if (item.action == 'scan' && item.status == 'done') {
      context.push('/scanner/result/${item.id}');
      return;
    }
    _showOperationSheet(context, item, isFrench);
  }

  void _showOperationSheet(BuildContext context, HistoryItem item, bool isFrench) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.vsSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildActionIcon(item.action),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(ctx).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._operationDetailRows(ctx, item, isFrench),
            _detailRow(ctx, isFrench ? 'Date' : 'Date',
                DateFormat.yMMMd().add_jm().format(item.createdAt.toLocal())),
            _detailRow(ctx, isFrench ? 'Statut' : 'Status',
                _statusText(item.status, isFrench)),
            const SizedBox(height: 20),
            if (item.action == 'convert' &&
                item.status == 'done' &&
                item.outputPath != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: Text(isFrench
                      ? 'Télécharger le fichier converti'
                      : 'Download converted file'),
                  onPressed: () => _downloadConverted(ctx, item, isFrench),
                ),
              ),
            if (item.action == 'scan')
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.assessment_rounded),
                  label: Text(
                      isFrench ? 'Voir le rapport complet' : 'View full report'),
                  onPressed: item.status == 'done'
                      ? () {
                          Navigator.pop(ctx);
                          context.push('/scanner/result/${item.id}');
                        }
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _operationDetailRows(
      BuildContext ctx, HistoryItem item, bool isFrench) {
    switch (item.action) {
      case 'convert':
        return [
          _detailRow(ctx, isFrench ? 'Opération' : 'Operation',
              isFrench ? 'Conversion de fichier' : 'File conversion'),
          _detailRow(ctx, isFrench ? 'De → Vers' : 'From → To',
              '${(item.fromFormat ?? '?').toUpperCase()} → ${(item.toFormat ?? '?').toUpperCase()}'),
        ];
      case 'scan':
        return [
          _detailRow(ctx, isFrench ? 'Opération' : 'Operation',
              isFrench ? 'Vérification de plagiat' : 'Plagiarism check'),
          if (item.similarityPct != null)
            _detailRow(ctx, isFrench ? 'Similarité' : 'Similarity',
                '${item.similarityPct!.round()}%'),
          if (item.aiProbability != null)
            _detailRow(ctx, isFrench ? 'Contenu IA' : 'AI content',
                '${item.aiProbability!.round()}%'),
        ];
      case 'translate':
        return [
          _detailRow(ctx, isFrench ? 'Opération' : 'Operation',
              isFrench ? 'Traduction' : 'Translation'),
          _detailRow(ctx, isFrench ? 'Langues' : 'Languages',
              '${(item.sourceLang ?? '?').toUpperCase()} → ${(item.targetLang ?? '?').toUpperCase()}'),
        ];
      default:
        return [
          _detailRow(ctx, isFrench ? 'Type' : 'Type', item.type.toUpperCase()),
        ];
    }
  }

  Widget _detailRow(BuildContext ctx, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: Theme.of(ctx)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.vsGray)),
          ),
          Expanded(
            child: Text(value,
                style: Theme.of(ctx)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  String _statusText(String status, bool isFrench) {
    return status == 'done'
        ? (isFrench ? 'Terminé' : 'Done')
        : status == 'failed'
            ? (isFrench ? 'Échoué' : 'Failed')
            : (isFrench ? 'En cours' : 'Processing');
  }

  Future<void> _downloadConverted(
      BuildContext sheetContext, HistoryItem item, bool isFrench) async {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(sheetContext);
    try {
      final url = await ref
          .read(conversionRepositoryProvider)
          .getSignedDownloadUrl(item.outputPath!);
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      messenger.showSnackBar(SnackBar(
        content: Text(isFrench ? 'Téléchargement échoué.' : 'Download failed.'),
        backgroundColor: AppColors.vsError,
      ));
    }
  }

  String _buildSubtitle(HistoryItem item, bool isFrench) {
    return switch (item.action) {
      'scan' => item.similarityPct != null
          ? '${isFrench ? "Similarité" : "Similarity"}: ${item.similarityPct!.round()}%'
          : item.type.toUpperCase(),
      'convert' => '${item.fromFormat?.toUpperCase() ?? ''} → ${item.toFormat?.toUpperCase() ?? ''}',
      'translate' => '${item.sourceLang?.toUpperCase() ?? ''} → ${item.targetLang?.toUpperCase() ?? ''}',
      _ => item.type.toUpperCase(),
    };
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Shimmer.fromColors(
          baseColor: AppColors.vsLightGray,
          highlightColor: AppColors.vsSurface,
          child: Container(
            height: 80,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, bool isFrench) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.vsSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isFrench ? 'Filtrer par type' : 'Filter by type', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _FilterType.values.map((f) => ChoiceChip(
                  label: Text(_filterLabel(f, isFrench)),
                  selected: _filter == f,
                  onSelected: (_) => setSheetState(() => setState(() => _filter = f)),
                )).toList(),
              ),
              const SizedBox(height: 16),
              Text(isFrench ? 'Trier par' : 'Sort by', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _SortOrder.values.map((s) => ChoiceChip(
                  label: Text(s == _SortOrder.newest ? (isFrench ? 'Plus récent' : 'Newest first') : (isFrench ? 'Plus ancien' : 'Oldest first')),
                  selected: _sort == s,
                  onSelected: (_) => setSheetState(() => setState(() => _sort = s)),
                )).toList(),
              ),
              const SizedBox(height: 16),
              Text(isFrench ? 'Statut' : 'Status', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _StatusFilter.values.map((s) => ChoiceChip(
                  label: Text(_statusLabel(s, isFrench)),
                  selected: _statusFilter == s,
                  onSelected: (_) => setSheetState(() => setState(() => _statusFilter = s)),
                )).toList(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _filterLabel(_FilterType f, bool isFrench) {
    return switch (f) {
      _FilterType.all => isFrench ? 'Tout' : 'All',
      _FilterType.scans => isFrench ? 'Analyses' : 'Scans',
      _FilterType.conversions => isFrench ? 'Conversions' : 'Conversions',
      _FilterType.translations => isFrench ? 'Traductions' : 'Translations',
      _FilterType.ocr => 'OCR',
    };
  }

  String _statusLabel(_StatusFilter s, bool isFrench) {
    return switch (s) {
      _StatusFilter.all => isFrench ? 'Tout' : 'All',
      _StatusFilter.completed => isFrench ? 'Terminé' : 'Completed',
      _StatusFilter.failed => isFrench ? 'Échoué' : 'Failed',
    };
  }
}
