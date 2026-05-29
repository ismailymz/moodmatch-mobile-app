import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/content_item.dart';
import '../../providers/favorites_provider.dart';

// [Project Description - Page 2]: State management zorunluluğu ve
// [Unit 3 - Page 12]: "Parent manages the state" kuralı gereği, favori durumu
// global olarak yönetildiği için reaktif dinleme yapabilen ConsumerWidget kullanıyoruz.
class DetailScreen extends ConsumerWidget {
  // [FlutterUnit06 - Page 38]: "Data passing between screens" (Ekranlar arası veri taşıma)
  // kuralına uygun olarak tıklanan öğeyi parametre olarak alıyoruz.
  final ContentItem item;

  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // [Unit 1 & Unit 7]: Riverpod yardımıyla favoriler listesi dinleniyor.
    final favoriteItems = ref.watch(favoritesProvider);
    final isFavorite = favoriteItems.any((fav) => fav.id == item.id);
    final double generatedRating = 3.0 + (item.id.hashCode.abs() % 21) / 10;

    // [Unit 2 - Page 7 & FlutterUnit06 - Page 3]: Her ekranın temeli Scaffold'dur.
    return Scaffold(
      // [Issue #6 Task]: "Implement layout with CustomScrollView, SliverAppBar..."
      // İçeriğin kaydırılabilir olması (Scrollable view) istendiği için bu yapı kullanıldı.
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // [Issue #6 Task]: "Poster image must be full-width and around 250px tall"
            expandedHeight: 250.0,
            pinned: true,
            // Scaffold'un AppBar'ı otomatik olarak geri (Back) butonu ekler, bu da Navigator.pop işlemini kendi yapar.

            actions: [
              IconButton(
                // [Unit 4 - Page 39]: Material Icons kullanımı.
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.redAccent : Colors.white,
                ),
                onPressed: () async {
                  // [Unit 3 - Page 15]: Butona tıklandığında state güncellenir.
                  // Optimizasyon için watch yerine read kullanıyoruz.
                  await ref.read(favoritesProvider.notifier).toggleFavorite(item);

                  if (context.mounted) {
                    // [FlutterUnit06 - Page 3]: Scaffold "It also provides APIs for showing snack bars"
                    // kuralına dayanarak kullanıcıya geri bildirim veriyoruz.
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFavorite
                              ? 'Removed from favourites'
                              : 'Added to favourites',
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: item.id,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    item.imageUrl != null && item.imageUrl!.isNotEmpty
                        ? Image.asset(item.imageUrl!, fit: BoxFit.cover)
                        : Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        _iconForType(item.type),
                        size: 64,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.6, 1.0],
                          colors: [Colors.transparent, Colors.black87],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.type.displayName.toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      const Spacer(),

                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${generatedRating.toStringAsFixed(1)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 8.0,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Mood: ${item.moodId}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    item.subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (item.sourceUrl != null && item.sourceUrl!.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.link, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                            },
                            child: Text(
                              item.sourceUrl!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
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