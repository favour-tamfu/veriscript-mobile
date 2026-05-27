import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/vs_app_bar.dart';
import '../../../core/widgets/vs_card.dart';
import '../../../core/widgets/vs_empty_state.dart';
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
  List<HistoryItem> _remoteItems = [];
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
        _remoteItems = [];
      }
    });

    try {
      final items = await ref.read(historyRepositoryProvider).fetchRemoteHistory(userId, page: _page);
      await ref.read(historyRepositoryProvider).syncToLocal(items);
      setState(() {
        _remoteItems = refresh ? items : [..._remoteItems, ...items];
        _isLoadingRemote = false;
      });
    } catch (_) {
      setState(() => _isLoadingRemote = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';

    final historyStream = _searchQuery.isNotEmpty
        ? ref.watch(historyRepositoryProvider).searchLocalHistory(userId, _searchQuery)
        : ref.watch(historyRepositoryProvider).watchLocalHistory(userId);

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
          Expanded(
            child: StreamBuilder<List<HistoryItem>>(
              stream: historyStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && _isLoadingRemote) {
                  return _buildShimmer();
                }

                var items = snapshot.data ?? [];
                items = _applyFilters(items);

                if (items.isEmpty && !_isLoadingRemote) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: VsEmptyState(
                      lottieAsset: 'assets/animations/empty.json',
                      title: isFrench ? 'Aucun historique' : 'No history yet',
                      subtitle: isFrench
                          ? 'Vos documents traités apparaîtront ici'
                          : 'Your processed documents will appear here',
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
              },
            ),
          ),
        ],
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
            ],
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
