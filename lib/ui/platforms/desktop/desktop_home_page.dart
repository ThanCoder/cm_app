import 'package:cm_app/core/models/movie.dart';
import 'package:cm_app/routes.dart';
import 'package:cm_app/ui/trending_data.dart';
import 'package:cm_app/ui/platforms/components/m_image.dart';
import 'package:flutter/material.dart';

final class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: _TopBar()),

          SliverToBoxAdapter(child: _HeroSection(movie: trendingMovies[4])),

          const SliverToBoxAdapter(
            child: _Section(title: 'Trending Movies', items: trendingMovies),
          ),

          const SliverToBoxAdapter(
            child: _Section(title: 'Trending TV Shows', items: trendingTvShows),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
        ],
      ),
    );
  }
}

// ============================================================
// TOP BAR
// ============================================================

final class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 22, 32, 12),
      child: Row(
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: SizedBox(
                height: 48,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search movies and TV shows...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: scheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),

          const SizedBox(width: 8),

          CircleAvatar(
            radius: 20,
            backgroundColor: scheme.primaryContainer,
            child: Icon(Icons.person_rounded, color: scheme.onPrimaryContainer),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HERO
// ============================================================

final class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.movie});

  final MediaItem movie;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 390,
      margin: const EdgeInsets.fromLTRB(32, 10, 32, 30),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image.network(movie.poster, fit: BoxFit.cover),
          MImage(source: movie.poster, fit: BoxFit.cover),

          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withValues(alpha: .92),
                  Colors.black.withValues(alpha: .62),
                  Colors.transparent,
                ],
                stops: const [0, .48, 1],
              ),
            ),
          ),

          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: .45),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(40),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 470,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TRENDING NOW',
                      style: TextStyle(
                        color: scheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 19,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          movie.rating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Text(
                          movie.year,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        if (movie.resolution != null) ...[
                          const SizedBox(width: 14),
                          _Badge(text: movie.resolution!),
                        ],
                      ],
                    ),

                    const SizedBox(height: 14),

                    Text(
                      movie.categories
                          .map((category) => category.name)
                          .join('  •  '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 26),

                    Row(
                      children: [
                        FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Watch Now'),
                        ),
                        const SizedBox(width: 10),
                        IconButton.filledTonal(
                          onPressed: () {},
                          icon: const Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SECTION
// ============================================================

final class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items});

  final String title;
  final List<MediaItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(onPressed: () {}, child: const Text('View all')),
            ],
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 335,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(width: 18),
              itemBuilder: (context, index) {
                return _MediaCard(
                  item: items[index],
                  onClicked: (item) {
                    goMovieDetail(context, item: item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MEDIA CARD
// ============================================================

final class _MediaCard extends StatefulWidget {
  const _MediaCard({required this.item, this.onClicked});
  final MediaItem item;
  final void Function(MediaItem item)? onClicked;

  @override
  State<_MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends State<_MediaCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final item = widget.item;

    return GestureDetector(
      onTap: () => widget.onClicked?.call(item),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            hovered = false;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 190,
          transform: hovered
              ? (Matrix4.identity()..translateByVector3(.new(0.0, -7.0, 0)))
              : Matrix4.identity(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MImage(source: item.poster),

                      if (item.resolution != null)
                        Positioned(
                          left: 9,
                          top: 9,
                          child: _Badge(text: item.resolution!),
                        ),

                      Positioned(
                        right: 9,
                        top: 9,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .75),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 14,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                item.rating,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 160),
                        opacity: hovered ? 1 : 0,
                        child: Container(
                          color: Colors.black.withValues(alpha: .48),
                          child: Center(
                            child: CircleAvatar(
                              radius: 27,
                              backgroundColor: scheme.primary,
                              child: Icon(
                                Icons.play_arrow_rounded,
                                size: 32,
                                color: scheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 5),

              Row(
                children: [
                  Text(
                    item.year,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      item.categories
                          .map((category) => category.name)
                          .join(', '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// BADGE
// ============================================================

final class _Badge extends StatelessWidget {
  const _Badge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .9),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
