import 'package:cm_app/core/models/tv_show_detail.dart';
import 'package:cm_app/funcs.dart';
import 'package:cm_app/platforms/components/m_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TvShowDetailPage extends StatefulWidget {
  const TvShowDetailPage({
    super.key,
    required this.fetchUrl,
    required this.contentId,
    required this.contentHashId,
    required this.tvShow,
    this.onUpdated,
  });
  final String fetchUrl;
  final String contentHashId;
  final String contentId;
  final TvShowDetail tvShow;
  final Future<TvShowDetail?> Function(
    String fetchUrl,
    String lateContentId,
    String lastContentHashId,
  )?
  onUpdated;

  @override
  State<TvShowDetailPage> createState() => _TvShowDetailPageState();
}

class _TvShowDetailPageState extends State<TvShowDetailPage> {
  @override
  void initState() {
    tvShow = widget.tvShow;
    if (widget.onUpdated != null) {
      widget.onUpdated!(widget.fetchUrl, widget.contentId, widget.contentHashId)
          .then((value) {
            if (value == null) return;
            tvShow = value;
            if (!mounted) return;
            setState(() {});
          });
    }
    super.initState();
  }

  late TvShowDetail tvShow;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildHero(context),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(context),
                  const SizedBox(height: 16),
                  _buildActions(context),
                  const SizedBox(height: 24),
                  _buildMeta(context),
                  const SizedBox(height: 18),
                  _buildGenres(context),
                  const SizedBox(height: 22),
                  _buildOverview(context),
                  const SizedBox(height: 28),
                  _buildDirector(context),
                  const SizedBox(height: 30),
                  _buildCast(context),
                  const SizedBox(height: 30),
                  _buildEpisodes(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      expandedHeight: 440,
      pinned: true,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: _circleButton(
          context,
          icon: Icons.arrow_back_rounded,
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: _circleButton(
            context,
            icon: Icons.more_vert_rounded,
            onPressed: () {},
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            MImage(source: widget.tvShow.backdropPath, fit: BoxFit.cover),

            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: .20),
                    Colors.black.withValues(alpha: .10),
                    colorScheme.surface.withValues(alpha: .85),
                    colorScheme.surface,
                  ],
                  stops: const [0, .35, .85, 1],
                ),
              ),
            ),

            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildPoster(context),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.tvShow.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
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

  Widget _buildPoster(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: MImage(
        source: widget.tvShow.poster,
        width: 120,
        height: 175,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.tvShow.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.tvShow.originalTitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              _playFirstEpisode(context);
            },
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Play'),
          ),
        ),
        const SizedBox(width: 10),
        IconButton.filledTonal(
          onPressed: () {},
          icon: Icon(
            widget.tvShow.bookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
          ),
        ),
        const SizedBox(width: 6),
        IconButton.filledTonal(
          onPressed: () {},
          icon: const Icon(Icons.share_outlined),
        ),
      ],
    );
  }

  void _playFirstEpisode(BuildContext context) {
    if (widget.tvShow.seasons.isEmpty) {
      return;
    }

    final season = widget.tvShow.seasons.first;

    if (season.episodes.isEmpty) {
      return;
    }

    final episode = season.episodes.first;

    if (!episode.hasDownloads) {
      return;
    }
  }

  Widget _buildMeta(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _metaItem(context, Icons.calendar_today_outlined, widget.tvShow.year),
        _metaItem(context, Icons.tv_rounded, widget.tvShow.status),
        _metaItem(context, Icons.movie_outlined, widget.tvShow.type),
        _metaItem(
          context,
          Icons.layers_outlined,
          '${widget.tvShow.episodeCount} Episodes',
        ),
        if (widget.tvShow.ratingValue > 0)
          _metaItem(context, Icons.star_rounded, widget.tvShow.rating),
      ],
    );
  }

  Widget _metaItem(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 5),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildGenres(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final category in widget.tvShow.categories)
          Chip(
            label: Text(category.name),
            visualDensity: VisualDensity.compact,
          ),
        for (final tag in widget.tvShow.tags)
          Chip(label: Text(tag.name), visualDensity: VisualDensity.compact),
      ],
    );
  }

  Widget _buildOverview(BuildContext context) {
    final theme = Theme.of(context);
    final hasHtmlTag = RegExp(r'<[^>]+>').hasMatch(widget.tvShow.overview);
    if (hasHtmlTag) {
      return Html(
        data: widget.tvShow.overview,
        style: {'*': Style(fontSize: .large)},
        onLinkTap: (url, attributes, element) {
          if (url == null || url.isEmpty) return;
          launchPageUrl(context, url);
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.tvShow.overview,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.65,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDirector(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Director',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final director in widget.tvShow.directors)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 23,
                    child: Text(
                      director.isEmpty ? '?' : director[0],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    director,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCast(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cast',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.tvShow.casts.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final cast = widget.tvShow.casts[index];

              return SizedBox(
                width: 88,
                child: Column(
                  children: [
                    ClipOval(
                      child: cast.profilePath == null
                          ? _avatarPlaceholder(context)
                          : MImage(
                              source: cast.profilePath!,
                              width: 76,
                              height: 76,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cast.name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _avatarPlaceholder(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.person_outline_rounded, size: 32),
    );
  }

  Widget _buildEpisodes(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Episodes',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),

        for (final season in widget.tvShow.seasons)
          _buildSeason(context, season),
      ],
    );
  }

  Widget _buildSeason(BuildContext context, TvShowSeason season) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 14),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        leading: Icon(
          Icons.video_library_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          season.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text('${season.episodes.length} Episodes'),
        children: [
          for (final episode in season.episodes)
            _buildEpisode(context, episode),
        ],
      ),
    );
  }

  Widget _buildEpisode(BuildContext context, TvShowEpisode episode) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        _showEpisodeServers(context, episode);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: MImage(
                source: episode.poster,
                width: 110,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EP ${episode.episodeNumber}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    episode.displayTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    [
                      if (episode.runtime != null) episode.runtime!,
                      episode.airDate,
                    ].join(' • '),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              episode.hasDownloads
                  ? Icons.play_circle_outline_rounded
                  : Icons.lock_outline_rounded,
              color: episode.hasDownloads
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showEpisodeServers(BuildContext context, TvShowEpisode episode) {
    if (!episode.hasDownloads) {
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Text(
                'Episode ${episode.episodeNumber}',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                episode.displayTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 18),

              for (final link in episode.downloadLinks)
                _serverItem(context, link),
            ],
          ),
        );
      },
    );
  }

  Widget _serverItem(BuildContext context, TvShowDownloadLink link) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        launchPageUrl(context, link.url);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: colorScheme.surfaceContainerHighest,
        ),
        child: Row(
          children: [
            Icon(Icons.cloud_download_outlined, color: colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    link.serverName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${link.quality} • '
                    '${link.resolution} • '
                    '${link.size}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                launchPageUrl(context, link.url);
              },
              icon: const Icon(Icons.play_arrow_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.black.withValues(alpha: .45),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
