import 'package:cm_app/core/models/movie_detail.dart';
import 'package:cm_app/ui/platforms/components/m_image.dart';
import 'package:flutter/material.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key, required this.movie});

  final MovieDetail movie;

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
                  const SizedBox(height: 20),
                  _buildGenres(context),
                  const SizedBox(height: 24),
                  _buildTagline(context),
                  const SizedBox(height: 24),
                  _buildOverview(context),
                  const SizedBox(height: 28),
                  _buildDirector(context),
                  const SizedBox(height: 32),
                  _buildCast(context),
                  const SizedBox(height: 32),
                  _buildDownloads(context),
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
          icon: Icons.arrow_back,
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: _circleButton(
            context,
            icon: Icons.more_vert,
            onPressed: () {},
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            MImage(source: movie.backdropPath),
            // Image.network(
            //   movie.backdropPath,
            //   fit: BoxFit.cover,
            //   errorBuilder: (_, _, _) => const SizedBox(),
            // ),

            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: .25),
                    Colors.black.withValues(alpha: .15),
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
                  _poster(context),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      movie.title,
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

  Widget _poster(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        movie.poster,
        width: 120,
        height: 175,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return Container(
            width: 120,
            height: 175,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.movie_outlined),
          );
        },
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          movie.originalTitle,
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
            onPressed: () {},
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Play'),
          ),
        ),
        const SizedBox(width: 10),
        IconButton.filledTonal(
          onPressed: () {},
          icon: Icon(
            movie.bookmarked
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

  Widget _buildMeta(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _metaItem(context, Icons.calendar_today_outlined, movie.year),
        _metaItem(context, Icons.access_time_rounded, movie.durationText),
        _metaItem(context, Icons.star_rounded, movie.rating),
        _metaItem(context, Icons.hd_rounded, _bestResolution),
      ],
    );
  }

  String get _bestResolution {
    final links = movie.movieDownloadLinks;

    if (links.isEmpty) {
      return 'HD';
    }

    final has1080p = links.any((link) => link.resolution == '1080p');

    return has1080p ? '1080p' : links.first.resolution;
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
        for (final category in movie.categories)
          Chip(
            label: Text(category.name),
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }

  Widget _buildTagline(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: theme.colorScheme.primaryContainer.withValues(alpha: .35),
      ),
      child: Row(
        children: [
          Icon(Icons.format_quote_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              movie.tagline,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(BuildContext context) {
    final theme = Theme.of(context);

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
          movie.overview,
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
            for (final director in movie.directors)
              _directorItem(context, director),
          ],
        ),
      ],
    );
  }

  Widget _directorItem(BuildContext context, String name) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 24,
          child: Text(
            name.isEmpty ? '?' : name[0],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          name,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
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
            itemCount: movie.casts.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final cast = movie.casts[index];

              return SizedBox(
                width: 88,
                child: Column(
                  children: [
                    ClipOval(
                      child: cast.profilePath != null
                          ? Image.network(
                              cast.profilePath!,
                              width: 76,
                              height: 76,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) {
                                return _avatarPlaceholder(context);
                              },
                            )
                          : _avatarPlaceholder(context),
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

  Widget _buildDownloads(BuildContext context) {
    final theme = Theme.of(context);

    final links = movie.movieDownloadLinks;

    if (links.isEmpty) {
      return const SizedBox();
    }

    final grouped = <String, List<MovieDownloadLink>>{};

    for (final link in links) {
      grouped.putIfAbsent(link.resolution, () => []).add(link);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Download',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),

        for (final entry in grouped.entries)
          _buildResolutionGroup(
            context,
            resolution: entry.key,
            links: entry.value,
          ),
      ],
    );
  }

  Widget _buildResolutionGroup(
    BuildContext context, {
    required String resolution,
    required List<MovieDownloadLink> links,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        title: Text(
          resolution,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text('${links.length} servers'),
        leading: Icon(Icons.hd_rounded, color: theme.colorScheme.primary),
        children: [
          for (final link in links) _downloadItem(context, link: link),
        ],
      ),
    );
  }

  Widget _downloadItem(
    BuildContext context, {
    required MovieDownloadLink link,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.download_rounded,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
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
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ),
        ],
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
