import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/content_item.dart';
import '../models/mood.dart';
import '../providers/app_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final moodsAsync = ref.watch(moodListProvider);
    final selectedMoodId = ref.watch(selectedMoodIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MoodMatch'),
      ),
      body: SafeArea(
        child: moodsAsync.when(
          data: (moods) {
            if (moods.isEmpty) {
              return const Center(child: Text('No moods available.'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _MoodSelectionSection(
                  moods: moods,
                  selectedMoodId: selectedMoodId,
                ),
                const SizedBox(height: 16),
                if (selectedMoodId != null)
                  const _MoodTrioResultSection(),
                const SizedBox(height: 16),
                const Expanded(child: _TopPicksSection()),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Failed to load moods: $error')),
        ),
      ),
    );
  }
}

class _MoodSelectionSection extends ConsumerWidget {
  const _MoodSelectionSection({
    required this.moods,
    required this.selectedMoodId,
  });

  final List<Mood> moods;
  final String? selectedMoodId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: moods.map((mood) {
              final isSelected = selectedMoodId == mood.id;
              return FilterChip(
                label: Text('${mood.emoji} ${mood.name}'),
                selected: isSelected,
                onSelected: (selected) {
                  ref
                      .read(selectedMoodIdProvider.notifier)
                      .setMood(selected ? mood.id : null);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _MoodTrioResultSection extends ConsumerWidget {
  const _MoodTrioResultSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMood = ref.watch(selectedMoodProvider);
    final recommendationsAsync = ref.watch(moodRecommendationsProvider);

    if (selectedMood == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommendations for ${selectedMood.name}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          recommendationsAsync.when(
            data: (recommendations) {
              if (recommendations.isEmpty) {
                return const Text('No recommendations available.');
              }

              return Column(
                children: recommendations.map((item) {
                  return _MoodTrioResultTile(item: item);
                }).toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) => Text('Error: $error'),
          ),
        ],
      ),
    );
  }
}

class _MoodTrioResultTile extends StatelessWidget {
  const _MoodTrioResultTile({required this.item});

  final ContentItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(_iconForType(item.type)),
        title: Text(item.title),
        subtitle: Text('${item.type.displayName} • ${item.subtitle}'),
      ),
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

class _TopPicksSection extends ConsumerWidget {
  const _TopPicksSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodsAsync = ref.watch(moodListProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Picks',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: moodsAsync.when(
              data: (moods) {
                final allRecommendations = moods
                    .expand((mood) => mood.recommendations)
                    .toList();

                if (allRecommendations.isEmpty) {
                  return const Center(child: Text('No picks available.'));
                }

                return ListView.separated(
                  itemCount: allRecommendations.length,
                  separatorBuilder: (context, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = allRecommendations[index];
                    return _TopPickTile(item: item);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPickTile extends StatelessWidget {
  const _TopPickTile({required this.item});

  final ContentItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(_iconForType(item.type)),
      title: Text(item.title),
      subtitle: Text('${item.type.displayName} • ${item.subtitle}'),
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
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
