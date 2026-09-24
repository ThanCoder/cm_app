import 'dart:convert';
import 'dart:math';

import 'package:cm_app/core/models/movie.dart';
import 'package:cm_app/core/utils/api_utils.dart';
import 'package:cm_app/core/utils/cache_utils.dart';
import 'package:cm_app/platforms/components/card_button.dart';
import 'package:cm_app/routes.dart';
import 'package:cm_app/platforms/components/m_image.dart';
import 'package:flutter/material.dart';

// ============================================================
// HOME
// ============================================================

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  List<MediaItem> movies = [];
  List<MediaItem> tvShows = [];
  @override
  void initState() {
    fetchMovie();
    fetchShow();
    super.initState();
  }

  bool movieFetching = false;
  bool showFetching = false;
  String? movieError;
  String? showError;

  Future<void> fetchMovie() async {
    setState(() {
      movieFetching = true;
      movieError = null;
    });
    // check cache
    final cached = await CacheUtils.getContent('trending-movies');
    if (cached != null) {
      try {
        List<dynamic> movieList = jsonDecode(cached)['data'];
        movies = movieList.map((e) => MediaItem.fromMap(e)).toList();
        setState(() {});
        // ignore: empty_catches
      } catch (e) {}
    }
    final movieUrl = '${ApiUtils.currentApiUrl()}/api/trending/movies';
    final movieRes = await ApiUtils.getApiContent(movieUrl);
    if (!mounted) return;

    if (movieRes.isErr) {
      setState(() {
        movieFetching = false;
        movieError = movieRes.unwrapError();
      });

      return;
    }
    try {
      final map = jsonDecode(movieRes.unwrap());
      List<dynamic> movieList = map['data'];
      movies = movieList.map((e) => MediaItem.fromMap(e)).toList();
      setState(() {
        movieFetching = false;
      });
      // save cache
      await CacheUtils.setContent('trending-movies', movieRes.unwrap());
    } catch (e) {
      setState(() {
        movieFetching = false;
        movieError = e.toString();
      });
    }
  }

  Future<void> fetchShow() async {
    setState(() {
      showFetching = true;
      showError = null;
    });
    final cached = await CacheUtils.getContent('trending-tv-shows');
    if (cached != null) {
      try {
        List<dynamic> showList = jsonDecode(cached)['data'];
        tvShows = showList.map((e) => MediaItem.fromMap(e)).toList();
        setState(() {});
        // ignore: empty_catches
      } catch (e) {}
    }
    // show
    final showUrl = '${ApiUtils.currentApiUrl()}/api/trending/tv-shows';
    final showRes = await ApiUtils.getApiContent(showUrl);
    if (!mounted) return;

    if (showRes.isErr) {
      setState(() {
        showError = showRes.unwrapError();
        showFetching = false;
      });
      return;
    }
    try {
      final map = jsonDecode(showRes.unwrap());
      List<dynamic> showList = map['data'];
      tvShows = showList.map((e) => MediaItem.fromMap(e)).toList();
      setState(() {
        showFetching = false;
      });
      // save cache
      await CacheUtils.setContent('trending-tv-shows', showRes.unwrap());
    } catch (e) {
      setState(() {
        showError = e.toString();
        showFetching = false;
      });
    }
  }

  Future<void> fetch() async {
    fetchMovie();
    fetchShow();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,

      appBar: AppBar(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 18,
        title: Row(
          children: [
            Icon(Icons.movie_creation_rounded, color: scheme.primary),
            const SizedBox(width: 8),
            const Text('TVP', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: RefreshIndicator.adaptive(
        onRefresh: fetch,
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: _MobileSearch()),
            if (movies.isNotEmpty)
              SliverToBoxAdapter(
                child: _FeaturedMovie(
                  movie: movies[Random().nextInt(movies.length)],
                  onWatch: (movie) {
                    goMovieDetail(context, item: movie);
                  },
                ),
              ),

            ...movieSections, // tv show
            ...showSections,
          ],
        ),
      ),
    );
  }

  List<Widget> get movieSections {
    return [
      if (movieFetching && movies.isNotEmpty)
        SliverToBoxAdapter(child: LinearProgressIndicator()),

      SliverToBoxAdapter(
        child: _SectionTitle(
          title: 'Trending Movies',
          onClicked: () => goMoviePage(context),
        ),
      ),
      if (movieFetching && movies.isEmpty)
        SliverFillRemaining(
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      if (movieError != null && movies.isEmpty)
        SliverFillRemaining(
          child: Center(
            child: Text(
              'Movies Error: $movieError',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      if (movieError == null && movies.isEmpty)
        SliverFillRemaining(
          child: Center(
            child: CardButton(title: 'Movies Empty', onRefresh: fetchShow),
          ),
        ),
      if (movies.isNotEmpty)
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return _MovieCard(
                movie: movies[index],
                onClicked: (movie) {
                  goMovieDetail(context, item: movie);
                },
              );
            }, childCount: movies.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 22,
              childAspectRatio: .61,
            ),
          ),
        ),
    ];
  }

  List<Widget> get showSections {
    return [
      if (showFetching && tvShows.isNotEmpty)
        SliverToBoxAdapter(child: LinearProgressIndicator()),

      SliverToBoxAdapter(
        child: _SectionTitle(
          title: 'Trending TV Shows',
          onClicked: () => goTvShowPage(context),
        ),
      ),
      if (showFetching && tvShows.isEmpty)
        SliverFillRemaining(
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),

      if (showError != null && tvShows.isEmpty)
        SliverFillRemaining(
          child: Center(
            child: Text(
              'Error: $showError',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      if (showError == null && tvShows.isEmpty)
        SliverFillRemaining(
          child: Center(
            child: CardButton(title: 'Tv Shows Empty', onRefresh: fetchShow),
          ),
        ),
      if (tvShows.isNotEmpty)
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return _MovieCard(
                movie: tvShows[index],
                onClicked: (movie) {
                  goMovieDetail(context, item: movie);
                },
              );
            }, childCount: tvShows.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 22,
              childAspectRatio: .61,
            ),
          ),
        ),
    ];
  }
}

// ============================================================
// SEARCH
// ============================================================

final class _MobileSearch extends StatelessWidget {
  const _MobileSearch();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
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
    );
  }
}

// ============================================================
// FEATURED
// ============================================================

final class _FeaturedMovie extends StatelessWidget {
  const _FeaturedMovie({required this.movie, required this.onWatch});

  final MediaItem movie;
  final void Function(MediaItem movie) onWatch;

  @override
  Widget build(BuildContext context) {
    // final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
      child: AspectRatio(
        aspectRatio: 1.55,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              MImage(source: movie.poster, fit: BoxFit.cover),

              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: .9),
                      Colors.black.withValues(alpha: .25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(18),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (movie.resolution != null)
                            _Badge(text: movie.resolution!),

                          const SizedBox(width: 7),

                          const Icon(
                            Icons.star_rounded,
                            size: 17,
                            color: Colors.amber,
                          ),

                          const SizedBox(width: 3),

                          Text(
                            movie.rating,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        '${movie.year}  •  ${movie.categories.first.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 11),

                      FilledButton.icon(
                        onPressed: () => onWatch(movie),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 38),
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 20),
                        label: const Text('Watch Now'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SECTION TITLE
// ============================================================

final class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.onClicked});

  final String title;
  final void Function()? onClicked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          TextButton(onPressed: onClicked, child: const Text('See all')),
        ],
      ),
    );
  }
}

// ============================================================
// MOVIE CARD
// ============================================================

final class _MovieCard extends StatelessWidget {
  const _MovieCard({required this.movie, this.onClicked});

  final MediaItem movie;
  final void Function(MediaItem movie)? onClicked;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => onClicked?.call(movie),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MImage(source: movie.poster, fit: BoxFit.cover),

                  if (movie.resolution != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _Badge(text: movie.resolution!),
                    ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .72),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 13,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            movie.rating,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: scheme.surface.withValues(alpha: .9),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 21,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              Text(
                movie.year,
                style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  movie.categories.map((e) => e.name).join(', '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
