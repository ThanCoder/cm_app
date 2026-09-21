import 'package:cm_app/core/models/movie.dart';
import 'package:cm_app/ui/movies_data.dart';
import 'package:cm_app/ui/platforms/components/m_image.dart';
import 'package:flutter/material.dart';

// import 'package:your_app/widgets/m_image.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final _scrollController = ScrollController();

  final List<MediaItem> _movies = [];

  int _page = 0;
  static const int _lastPage = 313;

  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    _loadNextPage();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    // Bottom မရောက်ခင် 500px လောက်ကတည်းက next page load
    if (position.pixels >= position.maxScrollExtent - 500) {
      _loadNextPage();
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;

    setState(() {});

    // API request လို delay mock
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final nextPage = _page + 1;

    // Mock page data
    final newMovies = _mockPage(nextPage);

    setState(() {
      _movies.addAll(newMovies);

      _page = nextPage;

      _hasMore = _page < _lastPage;

      _isLoading = false;
    });
  }

  List<MediaItem> _mockPage(int page) {
    if (page == 1) {
      return mockMovies;
    }

    // Page 2, 3 ... ကို mock လုပ်ဖို့
    // same data ကို duplicate မဖြစ်အောင် id/title ပြောင်းပေးထားတယ်။
    return mockMovies.map((movie) {
      return MediaItem(
        id: movie.id + (page * 100000),
        title: '${movie.title} $page',
        slug: '${movie.slug}-$page',
        year: movie.year,
        poster: movie.poster,
        rating: movie.rating,
        resolution: movie.resolution,
        isAdult: movie.isAdult,
        categories: movie.categories,
        type: movie.type,
        homietv: movie.homietv,
        ysflix: movie.ysflix,
      );
    }).toList();
  }

  Future<void> _refresh() async {
    setState(() {
      _movies.clear();
      _page = 0;
      _hasMore = true;
    });

    await _loadNextPage();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movies',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final movie = _movies[index];

                  return _MovieCard(
                    movie: movie,
                    onTap: () {
                      // TODO: open movie detail
                    },
                  );
                }, childCount: _movies.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 20,
                  childAspectRatio: .62,
                ),
              ),
            ),

            // Page loading indicator
            SliverToBoxAdapter(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _isLoading
                    ? const Padding(
                        key: ValueKey('loading'),
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          ),
                        ),
                      )
                    : !_hasMore
                    ? Padding(
                        key: const ValueKey('end'),
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Center(
                          child: Text(
                            'No more movies',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(key: ValueKey('empty'), height: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  const _MovieCard({required this.movie, required this.onTap});

  final MediaItem movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: MImage(source: movie.poster, fit: BoxFit.cover),
                  ),
                ),

                // Rating
                Positioned(
                  left: 8,
                  top: 8,
                  child: _MovieBadge(
                    icon: Icons.star_rounded,
                    text: movie.rating,
                  ),
                ),

                // Resolution
                if (movie.resolution != null)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: _MovieBadge(text: movie.resolution!),
                  ),

                // Bottom gradient
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 80,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(14),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          scheme.scrim.withValues(alpha: .8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              Text(
                movie.year,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.outline,
                ),
              ),
              const SizedBox(width: 6),
              const Text('•'),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  movie.categories.map((e) => e.name).take(2).join(' • '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.outline,
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

class _MovieBadge extends StatelessWidget {
  const _MovieBadge({required this.text, this.icon});

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.scrim.withValues(alpha: .72),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: scheme.primary),
              const SizedBox(width: 3),
            ],
            Text(
              text,
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
