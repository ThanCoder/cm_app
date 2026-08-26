import 'package:flutter/material.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  int selectedIndex = 0;

  final movies = const [
    Movie(
      id: 25748,
      title: 'The Trepidation: Deadest Night',
      year: '2026',
      rating: '3.9',
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/movies/2026-08-26/mUAwbdfbXxjTw1S3diSEYpRrd3F.jpg',
      genres: ['Horror'],
    ),
    Movie(
      id: 25749,
      title: 'Patton',
      year: '1970',
      rating: '7.4',
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/movies/2026-08-26/rLM7jIEPTjj4CF7F1IrzzNjLUCu.jpg',
      genres: ['Drama', 'History', 'War'],
    ),
    Movie(
      id: 25747,
      title: 'Pluto',
      year: '2026',
      rating: '0.0',
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/movies/2026-08-26/pPxsw4KnZbsklyHUCTKSCHKaC8F.jpg',
      genres: ['Comedy', 'Science Fiction'],
    ),
    Movie(
      id: 25746,
      title: 'The Sheriff',
      year: '2026',
      rating: '6.2',
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/movies/2026-08-26/pba15JjYAoyuFIM6kkZ7qE6oqG2.jpg',
      genres: ['Action', 'Crime'],
    ),
    Movie(
      id: 25745,
      title: 'Dil To Pagal Hai',
      year: '1997',
      rating: '6.9',
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/movies/2026-08-25/HKUrZZbXnwCM4129fPlgHEg0eG.jpg',
      genres: ['Comedy', 'Drama', 'Romance'],
    ),
    Movie(
      id: 25744,
      title: 'Pinocchio: Unstrung',
      year: '2026',
      rating: '7.0',
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/movies/2026-08-25/eUJXk3bTvLBi5Zcb0BCedZU7lVL.jpg',
      genres: ['Fantasy', 'Horror', 'Mystery'],
    ),
    Movie(
      id: 25733,
      title: 'Batman: Knightfall Part 1',
      year: '2026',
      rating: '7.2',
      resolution: '4K',
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/movies/2026-08-25/g19IoButQepcHPShmzfPGYOWfTq.jpg',
      genres: ['Action', 'Adventure', 'Animation'],
    ),
    Movie(
      id: 25743,
      title: 'I Am a Hero',
      year: '2016',
      rating: '7.4',
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/movies/2026-08-25/4RnmHtCLtbBHD9jagVlcSzJTWX6.jpg',
      genres: ['Action', 'Drama', 'Horror'],
    ),
  ];

  final shows = const [
    Show(
      title: 'Reacher',
      year: '2022',
      rating: '8.1',
      seasons: 1,
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/tv-shows/2026-08-12/f1VCQIG2iCyOookdgOzwtUpwWC0.jpg',
      genres: ['Action & Adventure', 'Crime', 'Drama'],
    ),
    Show(
      title: 'Pull Strings',
      year: '2026',
      rating: '0.0',
      seasons: 1,
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/tv-shows/2026-08-19/87irKQfNYW0HlOFXemvSMygDkvD.jpg',
      genres: ['Action & Adventure', 'Comedy'],
    ),
    Show(
      title: 'Our Happy Days',
      year: '2026',
      rating: '9.0',
      seasons: 4,
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/posters/2026-03-30/21-17-21-1.jpg',
      genres: ['Drama', 'Family'],
    ),
    Show(
      title: 'Family Register',
      year: '2026',
      rating: '8.9',
      seasons: 2,
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/tv-shows/2026-07-07/l1EoUpPABU7aqr6K2vt40ac0v7B.jpg',
      genres: ['Drama', 'Family'],
    ),
    Show(
      title: 'A Trap Called Desire',
      year: '2026',
      rating: '8.5',
      seasons: 1,
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/tv-shows/2026-08-11/repjdxPyA19x0ghyJFmECTDwGvj.jpg',
      genres: ['Crime', 'Drama', 'Mystery'],
    ),
    Show(
      title: 'My Bias, My Boss',
      year: '2026',
      rating: '8.9',
      seasons: 1,
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/tv-shows/2026-08-03/A4Y4xlDHS4xi2WI9265vRyIYLoo.jpg',
      genres: ['Comedy', 'Drama'],
    ),
  ];

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
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
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
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
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
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() => selectedIndex = value);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie_rounded),
            label: 'Movies',
          ),
          NavigationDestination(
            icon: Icon(Icons.tv_outlined),
            selectedIcon: Icon(Icons.tv_rounded),
            label: 'Series',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'My List',
          ),
        ],
      ),
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
              movie.poster,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
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
            Image.network(movie.poster, fit: BoxFit.cover),

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Image.network(
                    movie.poster,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(show.poster, fit: BoxFit.cover),
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

class Movie {
  final int id;
  final String title;
  final String year;
  final String rating;
  final String poster;
  final String? resolution;
  final List<String> genres;

  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.poster,
    required this.genres,
    this.resolution,
  });
}

class Show {
  final String title;
  final String year;
  final String rating;
  final int seasons;
  final String poster;
  final List<String> genres;

  const Show({
    required this.title,
    required this.year,
    required this.rating,
    required this.seasons,
    required this.poster,
    required this.genres,
  });
}
