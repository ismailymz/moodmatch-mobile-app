import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/content_item.dart';
import '../providers/app_providers.dart';
import '../utils/search_validator.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final errorMessage = validateSearchQuery(value);

    if (errorMessage == null || value.trim().isEmpty) {
      ref.read(searchQueryProvider.notifier).setQuery(value);
    } else {
      ref.read(searchQueryProvider.notifier).clear();
    }

    _formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  key: const Key('searchField'),
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search recommendations',
                    hintText: 'Type at least 2 characters',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  validator: validateSearchQuery,
                  onChanged: _onSearchChanged,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: searchQuery.trim().isEmpty
                      ? const _SearchEmptyState()
                      : _SearchResultsList(searchResults: searchResults),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Search for music, movies, or TV shows.'));
  }
}

class _SearchResultsList extends StatelessWidget {
  const _SearchResultsList({required this.searchResults});

  final AsyncValue<List<ContentItem>> searchResults;

  @override
  Widget build(BuildContext context) {
    return searchResults.when(
      data: (results) {
        if (results.isEmpty) {
          return const Center(child: Text('No search results found.'));
        }

        return ListView.separated(
          itemCount: results.length,
          separatorBuilder: (context, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = results[index];
            return _SearchResultTile(item: item);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: Text('Search failed: $error')),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.item});

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
