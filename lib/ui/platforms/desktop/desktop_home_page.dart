import 'package:flutter/material.dart';

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  int selectedNav = 0;
  String selectedType = 'Movies';
  final searchController = TextEditingController();

  final movies = [
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
      id: 25186,
      title: 'Once Upon a Time in a Battlefield',
      year: '2003',
      rating: '6.7',
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/movies/2026-07-07/2Th2BQwuxSrh37p8wWG7y61uq5W.jpg',
      genres: ['Comedy', 'History', 'War'],
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
    Movie(
      id: 25740,
      title: 'I, Nobody',
      year: '2026',
      rating: '6.0',
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/movies/2026-08-25/qFJl3w9KpVXpfZ3rpmv7p0UYZkP.jpg',
      genres: ['Crime', 'Drama', 'Thriller'],
    ),
  ];

  final shows = [
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
      genres: ['Action & Adventure', 'Comedy', 'Sci-Fi & Fantasy'],
    ),
    Show(
      title: 'The Early Spring',
      year: '2026',
      rating: '0.0',
      seasons: 1,
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/tv-shows/2026-08-26/lGFngmJWMO4HTPcI0sUGKBAFqMe.jpg',
      genres: ['Drama'],
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
      title: 'New Recruit Season 4',
      year: '2026',
      rating: '8.5',
      seasons: 2,
      poster: 'https://media.homietv.com/file/all-asset-uploads/cm-app-media-two/posters/2026-08-26/02-04-52-73o2gn_4f.jpg',
      genres: ['Comedy', 'Drama'],
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
      body: Row(
        children: [
          _Sidebar(
            selectedIndex: selectedNav,
            onChanged: (value) {
              setState(() => selectedNav = value);
            },
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  surfaceTintColor: Colors.transparent,
                  toolbarHeight: 72,
                  titleSpacing: 28,
                  title: _TopBar(
                    controller: searchController,
                    selectedType: selectedType,
                    onTypeChanged: (value) {
                      setState(() => selectedType = value);
                    },
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 12, 32, 0),
                    child: _HeroSection(movie: movies[7]),
                  ),
                ),

                SliverToBoxAdapter(
                  child: _Section(
                    title: 'Continue Watching',
                    trailing: 'View all',
                    child: _ContinueWatching(movies: movies.take(5).toList()),
                  ),
                ),

                SliverToBoxAdapter(
                  child: _Section(
                    title: 'Popular Movies',
                    trailing: 'See all',
                    child: _MovieHorizontalList(movies: movies),
                  ),
                ),

                SliverToBoxAdapter(
                  child: _Section(
                    title: 'Popular Series',
                    trailing: 'See all',
                    child: _ShowHorizontalList(shows: shows),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(32, 10, 32, 60),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Latest Movies',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 60),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return _MovieCard(movie: movies[index]);
                    }, childCount: movies.length),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 190,
                          mainAxisExtent: 315,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 28,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SIDEBAR
// -----------------------------------------------------------------------------

class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _Sidebar({required this.selectedIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, 'Home'),
      (Icons.movie_outlined, 'Movies'),
      (Icons.tv_outlined, 'TV Shows'),
      (Icons.bookmark_outline_rounded, 'My List'),
    ];

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: .25),
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
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
                  const SizedBox(width: 12),
                  const Text(
                    'Fate',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),

            for (var i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 3,
                ),
                child: _NavItem(
                  icon: items[i].$1,
                  label: items[i].$2,
                  selected: selectedIndex == i,
                  onTap: () => onChanged(i),
                ),
              ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.settings_outlined),
                      const SizedBox(height: 8),
                      const Text(
                        'Settings',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      selected: selected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(icon),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

// -----------------------------------------------------------------------------
// TOP BAR
// -----------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  final TextEditingController controller;
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const _TopBar({
    required this.controller,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 320,
          child: SearchBar(
            controller: controller,
            hintText: 'Search movies, series...',
            leading: const Icon(Icons.search_rounded),
            trailing: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.tune_rounded),
              ),
            ],
          ),
        ),

        const SizedBox(width: 24),

        SegmentedButton<String>(
          segments: const [
            ButtonSegment(
              value: 'Movies',
              label: Text('Movies'),
              icon: Icon(Icons.movie_outlined),
            ),
            ButtonSegment(
              value: 'Series',
              label: Text('Series'),
              icon: Icon(Icons.tv_outlined),
            ),
          ],
          selected: {selectedType},
          onSelectionChanged: (value) {
            onTypeChanged(value.first);
          },
        ),

        const Spacer(),

        IconButton(
          tooltip: 'Notifications',
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),

        const SizedBox(width: 8),

        const CircleAvatar(radius: 18, child: Icon(Icons.person_outline)),

        const SizedBox(width: 20),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// HERO
// -----------------------------------------------------------------------------

class _HeroSection extends StatelessWidget {
  final Movie movie;

  const _HeroSection({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              movie.poster,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (_, __, ___) {
                return const ColoredBox(
                  color: Colors.black26,
                  child: Icon(Icons.broken_image_outlined, size: 50),
                );
              },
            ),

            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: .95),
                    Colors.black.withValues(alpha: .65),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            Positioned(
              left: 36,
              top: 40,
              bottom: 36,
              width: 470,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'FEATURED MOVIE',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 38,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 19,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        movie.rating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Text(
                        movie.year,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 18),
                      ...movie.genres
                          .take(2)
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                e,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Watch now'),
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
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SECTION
// -----------------------------------------------------------------------------

class _Section extends StatelessWidget {
  final String title;
  final String trailing;
  final Widget child;

  const _Section({
    required this.title,
    required this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 34, 32, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              TextButton(onPressed: () {}, child: Text(trailing)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CONTINUE WATCHING
// -----------------------------------------------------------------------------

class _ContinueWatching extends StatelessWidget {
  final List<Movie> movies;

  const _ContinueWatching({required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 155,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final movie = movies[index];

          return SizedBox(
            width: 270,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
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
                    left: 14,
                    right: 14,
                    bottom: 13,
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
                        const SizedBox(height: 7),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const LinearProgressIndicator(
                            value: .42,
                            minHeight: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// MOVIE LIST
// -----------------------------------------------------------------------------

class _MovieHorizontalList extends StatelessWidget {
  final List<Movie> movies;

  const _MovieHorizontalList({required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 315,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (_, index) {
          return SizedBox(width: 180, child: _MovieCard(movie: movies[index]));
        },
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;

  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
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
                    top: 9,
                    left: 9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        movie.resolution!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton.filledTonal(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {},
                    icon: const Icon(Icons.add_rounded, size: 18),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 5),

          Row(
            children: [
              const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
              const SizedBox(width: 3),
              Text(movie.rating, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 10),
              Text(
                movie.year,
                style: TextStyle(
                  fontSize: 12,
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

// -----------------------------------------------------------------------------
// SERIES
// -----------------------------------------------------------------------------

class _ShowHorizontalList extends StatelessWidget {
  final List<Show> shows;

  const _ShowHorizontalList({required this.shows});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 315,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: shows.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (_, index) {
          return SizedBox(width: 180, child: _ShowCard(show: shows[index]));
        },
      ),
    );
  }
}

class _ShowCard extends StatelessWidget {
  final Show show;

  const _ShowCard({required this.show});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(show.poster, fit: BoxFit.cover),
                Positioned(
                  left: 9,
                  bottom: 9,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${show.seasons} ${show.seasons == 1 ? 'Season' : 'Seasons'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
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
          show.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
            const SizedBox(width: 3),
            Text(show.rating, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 10),
            Text(
              show.year,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// MODELS
// -----------------------------------------------------------------------------

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
