import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/content_item.dart';
import '../providers/browse_providers.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.9;

    if (currentScroll >= threshold) {
      final hasMore = ref.read(hasMoreContentProvider);
      if (hasMore) {
        ref.read(browsePageProvider.notifier).nextPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final paginatedContent = ref.watch(paginatedContentProvider);
    final selectedFilters = ref.watch(browseFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CategoryFilterChips(selectedFilters: selectedFilters),
            const SizedBox(height: 8),
            Expanded(
              child: _BrowseContentList(
                paginatedContent: paginatedContent,
                scrollController: _scrollController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryFilterChips extends ConsumerWidget {
  const _CategoryFilterChips({required this.selectedFilters});

  final Set<ContentType> selectedFilters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          for (final type in ContentType.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(type.displayName),
                selected: selectedFilters.contains(type),
                onSelected: (_) {
                  ref.read(browseFilterProvider.notifier).toggleFilter(type);
                  ref.read(browsePageProvider.notifier).reset();
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _BrowseContentList extends ConsumerWidget {
  const _BrowseContentList({
    required this.paginatedContent,
    required this.scrollController,
  });

  final AsyncValue<List<ContentItem>> paginatedContent;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return paginatedContent.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(
            child: Text('No content items found.'),
          );
        }

        final hasMore = ref.watch(hasMoreContentProvider);

        return ListView.separated(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: items.length + (hasMore ? 1 : 0),
          separatorBuilder: (context, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index >= items.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final item = items[index];
            return _BrowseContentTile(item: item);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: Text('Failed to load content: $error')),
    );
  }
}

class _BrowseContentTile extends StatelessWidget {
  const _BrowseContentTile({required this.item});

  final ContentItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(_iconForType(item.type)),
      title: Text(item.title),
      subtitle: Text('${item.type.displayName} • ${item.subtitle}'),
    );
  }

  IconData _iconForType(ContentType type) {
    switch (type) {
      case ContentType.music:
        return Icons.music_note;
      case ContentType.movie:
        return Icons.movie;
      case ContentType.tvSeries:
        return Icons.live_tv;
    }
  }
}
