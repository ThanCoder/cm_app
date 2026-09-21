import 'package:cm_app/core/models/tv_show.dart';
import 'package:cm_app/core/utils/api_utils.dart';
import 'package:cm_app/routes.dart';
import 'package:cm_app/ui/platforms/components/dialog/error_alert_dialog.dart';
import 'package:cm_app/ui/platforms/components/m_image.dart';
import 'package:flutter/material.dart';

class TvShowsPage extends StatefulWidget {
  const TvShowsPage({super.key});

  @override
  State<TvShowsPage> createState() => _TvShowsPageState();
}

class _TvShowsPageState extends State<TvShowsPage> {
  final _scrollController = ScrollController();

  final List<TvShowItem> _shows = [];

  int _page = 0;

  static const int _lastPage = 71;

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

    if (position.pixels >= position.maxScrollExtent - 500) {
      _loadNextPage();
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final nextPage = _page + 1;

    final url = '${ApiUtils.currentApiUrl()}/api/tv-shows?page=$nextPage';
    // print(':Dev $url');
    final res = await ApiUtils.getApiContent(url);
    if (!mounted) return;

    if (res.isErr) {
      setState(() {
        _isLoading = false;
      });
      showErrorDialog(context, res.unwrapError());
      return;
    }
    List<dynamic> list = res.unwrap()['data'];
    final newShows = list.map((e) => TvShowItem.fromJson(e)).toList();
    setState(() {
      _shows.addAll(newShows);

      _page = nextPage;

      _hasMore = _page < _lastPage;

      _isLoading = false;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _shows.clear();
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
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TV Shows',
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
      body: RefreshIndicator.noSpinner(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final show = _shows[index];

                  return _TvShowCard(
                    show: show,
                    onTap: () {
                      goTvShowDetail(context, item: show);
                    },
                  );
                }, childCount: _shows.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 20,
                  childAspectRatio: .62,
                ),
              ),
            ),

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
                            'No more TV shows',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.outline,
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

class _TvShowCard extends StatelessWidget {
  const _TvShowCard({required this.show, required this.onTap});

  final TvShowItem show;
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
                    child: MImage(source: show.poster, fit: BoxFit.cover),
                  ),
                ),

                // Rating
                if (show.rating != '0.0')
                  Positioned(
                    left: 8,
                    top: 8,
                    child: _TvBadge(
                      icon: Icons.star_rounded,
                      text: show.rating,
                    ),
                  ),

                // Resolution
                if (show.resolution != null)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: _TvBadge(text: show.resolution!),
                  ),

                // Seasons
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: _TvBadge(
                    icon: Icons.video_library_rounded,
                    text:
                        '${show.seasons} '
                        '${show.seasons == 1 ? 'Season' : 'Seasons'}',
                  ),
                ),

                // Bottom gradient
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 90,
                  child: IgnorePointer(
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
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Text(
            show.title,
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
                show.year,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.outline,
                ),
              ),
              const SizedBox(width: 6),
              const Text('•'),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  show.categories.map((e) => e.name).take(2).join(' • '),
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

class _TvBadge extends StatelessWidget {
  const _TvBadge({required this.text, this.icon});

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

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
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
