import 'package:cm_app/core/models/movie.dart';
import 'package:cm_app/core/models/show.dart';
import 'package:cm_app/core/utils/api_utils.dart';
import 'package:cm_app/ui/api.dart';
import 'package:cm_app/ui/pages/movie_detail_page.dart';
import 'package:cm_app/ui/pages/show_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // ---------------------------------------------------------------
            // APP BAR
            // ---------------------------------------------------------------

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Fate',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search_rounded),
                    ),
                    const SizedBox(width: 2),
                    const CircleAvatar(
                      radius: 18,
                      child: Icon(Icons.person_outline_rounded, size: 20),
                    ),
                  ],
                ),
              ),
            ),

            // ---------------------------------------------------------------
            // HERO
            // ---------------------------------------------------------------
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
              sliver: SliverToBoxAdapter(child: _MobileHero(movie: movies[6])),
            ),

            // ---------------------------------------------------------------
            // GENRES
            // ---------------------------------------------------------------
            SliverPadding(
              padding: const EdgeInsets.only(top: 20),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: 42,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _GenreChip(label: 'All', selected: true),
                      _GenreChip(label: 'Action'),
                      _GenreChip(label: 'Drama'),
                      _GenreChip(label: 'Comedy'),
                      _GenreChip(label: 'Horror'),
                      _GenreChip(label: 'Sci-Fi'),
                    ],
                  ),
                ),
              ),
            ),

            // ---------------------------------------------------------------
            // CONTINUE WATCHING
            // ---------------------------------------------------------------
            SliverToBoxAdapter(
              child: _MobileSection(
                title: 'Continue Watching',
                trailing: 'View all',
                child: SizedBox(
                  height: 132,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (_, index) {
                      return _ContinueCard(
                        movie: movies[index],
                        progress: .25 + (index * .12),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ---------------------------------------------------------------
            // POPULAR MOVIES
            // ---------------------------------------------------------------
            SliverToBoxAdapter(
              child: _MobileSection(
                title: 'Popular Movies',
                trailing: 'See all',
                child: SizedBox(
                  height: 280,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 14),
                    itemBuilder: (_, index) {
                      return SizedBox(
                        width: 145,
                        child: _MobileMovieCard(movie: movies[index]),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ---------------------------------------------------------------
            // SERIES
            // ---------------------------------------------------------------
            SliverToBoxAdapter(
              child: _MobileSection(
                title: 'Popular Series',
                trailing: 'See all',
                child: SizedBox(
                  height: 280,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: shows.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 14),
                    itemBuilder: (_, index) {
                      return SizedBox(
                        width: 145,
                        child: _MobileShowCard(show: shows[index]),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ---------------------------------------------------------------
            // LATEST
            // ---------------------------------------------------------------
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Latest Movies',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((_, index) {
                  return _MobileMovieCard(movie: movies[index]);
                }, childCount: movies.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 22,
                  crossAxisSpacing: 14,
                  childAspectRatio: .52,
                ),
              ),
            ),
          ],
        ),
      ),

      // ---------------------------------------------------------------------
      // BOTTOM NAV
      // ---------------------------------------------------------------------
    );
  }
}

// =============================================================================
// HERO
// =============================================================================

class _MobileHero extends StatelessWidget {
  final Movie movie;

  const _MobileHero({required this.movie});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.55,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              ApiUtils.getProxyUrl(movie.poster),
              fit: BoxFit.cover,
              errorBuilder: (_,_, _) {
                return const ColoredBox(
                  color: Colors.black12,
                  child: Icon(Icons.broken_image_outlined),
                );
              },
            ),

            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [.0, .55, 1],
                  colors: [
                    Colors.black.withValues(alpha: .9),
                    Colors.black.withValues(alpha: .2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 17,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        movie.rating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        movie.year,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow_rounded, size: 19),
                        label: const Text('Watch'),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        onPressed: () {},
                        icon: const Icon(Icons.add_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SECTION
// =============================================================================

class _MobileSection extends StatelessWidget {
  final String title;
  final String trailing;
  final Widget child;

  const _MobileSection({
    required this.title,
    required this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                TextButton(onPressed: () {}, child: Text(trailing)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

// =============================================================================
// CONTINUE CARD
// =============================================================================

class _ContinueCard extends StatelessWidget {
  final Movie movie;
  final double progress;

  const _ContinueCard({required this.movie, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              ApiUtils.getProxyUrl(movie.poster),
              fit: BoxFit.cover,
            ),

            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
            ),

            Positioned(
              left: 12,
              right: 12,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// MOVIE CARD
// =============================================================================

class _MobileMovieCard extends StatelessWidget {
  final Movie movie;

  const _MobileMovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushMaterialPageRoute(builder: (mainCtx) => MovieDetailsPage());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.network(
                      ApiUtils.getProxyUrl(movie.poster),
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return const ColoredBox(
                          color: Colors.black12,
                          child: Icon(Icons.broken_image_outlined),
                        );
                      },
                    ),
                  ),
                ),

                if (movie.resolution != null)
                  Positioned(
                    top: 7,
                    left: 7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        movie.resolution!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton.filledTonal(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {},
                    icon: const Icon(Icons.add_rounded, size: 18),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
              const SizedBox(width: 3),
              Text(movie.rating, style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 8),
              Text(
                movie.year,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SHOW CARD
// =============================================================================

class _MobileShowCard extends StatelessWidget {
  final Show show;

  const _MobileShowCard({required this.show});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushMaterialPageRoute(builder: (mainCtx) => ShowDetailPage());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    ApiUtils.getProxyUrl(show.poster),
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 7,
                    bottom: 7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '${show.seasons} ${show.seasons == 1 ? 'Season' : 'Seasons'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            show.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
              const SizedBox(width: 3),
              Text(show.rating, style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 8),
              Text(
                show.year,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// GENRE CHIP
// =============================================================================

class _GenreChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _GenreChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: selected,
        label: Text(label),
        onSelected: (_) {},
        showCheckmark: false,
      ),
    );
  }
}

// =============================================================================
// MODELS
// =============================================================================

// class Movie {
//   final int id;
//   final String title;
//   final String year;
//   final String rating;
//   final String poster;
//   final String? resolution;
//   final List<String> genres;

//   const Movie({
//     required this.id,
//     required this.title,
//     required this.year,
//     required this.rating,
//     required this.poster,
//     required this.genres,
//     this.resolution,
//   });
// }

// class Show {
//   final String title;
//   final String year;
//   final String rating;
//   final int seasons;
//   final String poster;
//   final List<String> genres;

//   const Show({
//     required this.title,
//     required this.year,
//     required this.rating,
//     required this.seasons,
//     required this.poster,
//     required this.genres,
//   });
// }
