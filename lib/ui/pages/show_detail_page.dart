import 'package:cm_app/core/utils/api_utils.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';

class ShowDetailPage extends StatefulWidget {
  const ShowDetailPage({super.key});

  @override
  State<ShowDetailPage> createState() => _ShowDetailPageState();
}

class _ShowDetailPageState extends State<ShowDetailPage> {
  int selectedSeason = 0;

  final seasons = [
    {
      'name': 'Specials',
      'episodes': [
        {
          'episode': '1',
          'date': '2026-08-05',
          'downloads': [
            {'server': 'Yoteshin', 'quality': '1080p', 'size': '850 Mb'},
            {'server': 'Telegram', 'quality': '720p', 'size': '380 Mb'},
          ],
        },
        {
          'episode': '2',
          'date': '2026-08-19',
          'downloads': [
            {'server': 'Yoteshin', 'quality': '1080p', 'size': '790 Mb'},
            {'server': 'Telegram', 'quality': '720p', 'size': '345 Mb'},
          ],
        },
        {
          'episode': '3',
          'date': '2026-08-26',
          'downloads': [
            {'server': 'Yoteshin', 'quality': '1080p', 'size': '640 Mb'},
            {'server': 'Telegram', 'quality': '720p', 'size': '270 Mb'},
          ],
        },
      ],
    },
    {'name': 'Season 1', 'episodes': []},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// ================= APP BAR =================
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://image.tmdb.org/t/p/original/uHJeyQ0VECADbV0z60jL2YEbfAD.jpg',
                    fit: BoxFit.cover,
                  ),

                  /// Dark overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: .15),
                          theme.scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined),
              ),
            ],
          ),

          /// ================= CONTENT =================
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth > 700;

                      if (isDesktop) {
                        return _desktopLayout();
                      }

                      return _mobileLayout();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =========================================================
  /// DESKTOP
  /// =========================================================

  Widget _desktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 220, child: _poster()),

        const SizedBox(width: 28),

        Expanded(child: _details()),
      ],
    );
  }

  /// =========================================================
  /// MOBILE
  /// =========================================================

  Widget _mobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: SizedBox(width: 180, child: _poster())),

        const SizedBox(height: 24),

        _details(),
      ],
    );
  }

  /// =========================================================
  /// POSTER
  /// =========================================================

  Widget _poster() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: Image.network(
          ApiUtils.getProxyUrl(
            'https://media.homietv.com/file/all-asset-uploads/org_photos/cm-app-media-two/tv-shows/2026-08-12/9u2L1HD2BS7qu7BxCZO0uj9DEAy.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// =========================================================
  /// DETAILS
  /// =========================================================

  Widget _details() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TITLE
        Text(
          'Moonshadow',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'เงาใต้พระจันทร์',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 16),

        /// INFO
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _InfoChip(icon: Icons.calendar_month_outlined, label: '2026'),

            _InfoChip(icon: Icons.tv_outlined, label: 'TV Show'),

            _InfoChip(icon: Icons.update, label: 'Returning'),

            _InfoChip(icon: Icons.category_outlined, label: 'Miniseries'),
          ],
        ),

        const SizedBox(height: 24),

        /// GENRES
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _GenreChip('Drama'),
            _GenreChip('Trending'),
            _GenreChip('Thai Drama'),
          ],
        ),

        const SizedBox(height: 28),

        /// OVERVIEW
        Text(
          'Overview',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          '“ လရောင်အောက်က ချစ်ရိပ်ငယ်” ဇာတ်လမ်းတွဲမှာ '
          'ကျန်၊ ခီး နဲ့ ဂျေတို့ရဲ့ ရှုပ်ထွေးနေတဲ့ '
          'ဆက်ဆံရေးတွေကြားက စစ်မှန်တဲ့ ချစ်ခြင်းတရားကို '
          'တွေ့မြင်ရမှာ ဖြစ်ပါတယ်။',
          style: theme.textTheme.bodyLarge?.copyWith(height: 1.7),
        ),

        const SizedBox(height: 32),

        /// CAST
        _castSection(),

        const SizedBox(height: 32),

        /// SEASONS
        Text(
          'Episodes',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        _seasonSelector(),

        const SizedBox(height: 16),

        _episodeList(),
      ],
    );
  }

  /// =========================================================
  /// CAST
  /// =========================================================

  Widget _castSection() {
    final casts = [
      {
        'name': 'Thasorn Klinnium',
        'image':
            'https://image.tmdb.org/t/p/w200/lW4zTAWtjUFVmFpcm2honfsfvq2.jpg',
      },
      {
        'name': 'Pattraphus Borattasuwan',
        'image':
            'https://image.tmdb.org/t/p/w200/39kLgQ6Cu0xuMwHVIIYUTayEAa5.jpg',
      },
      {
        'name': 'Rachanun Mahawan',
        'image':
            'https://image.tmdb.org/t/p/w200/beNrYyUndPabJmG4Ffh51JXJru7.jpg',
      },
      {
        'name': 'Juthapich Indrajundra',
        'image':
            'https://image.tmdb.org/t/p/w200/7InqUeCuUYmth8tNoz8wvpD1kXJ.jpg',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cast',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: casts.length,
            separatorBuilder: (_,_) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final cast = casts[index];

              return SizedBox(
                width: 90,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundImage: NetworkImage(cast['image']!),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      cast['name']!,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
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

  /// =========================================================
  /// SEASON SELECTOR
  /// =========================================================

  Widget _seasonSelector() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: seasons.length,
        separatorBuilder: (_,_) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final season = seasons[index];
          final selected = selectedSeason == index;

          return ChoiceChip(
            label: Text(season['name'] as String),
            selected: selected,
            onSelected: (_) {
              setState(() {
                selectedSeason = index;
              });
            },
          );
        },
      ),
    );
  }

  /// =========================================================
  /// EPISODES
  /// =========================================================

  Widget _episodeList() {
    final season = seasons[selectedSeason];
    final episodes = season.getMapList(['episodes']);

    if (episodes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.movie_outlined, size: 48),

              SizedBox(height: 12),

              Text('Episodes not available yet'),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: episodes.length,
      separatorBuilder: (_,_) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final episode = episodes[index];

        return _EpisodeCard(episode: episode);
      },
    );
  }
}

/// =========================================================
/// EPISODE CARD
/// =========================================================

class _EpisodeCard extends StatelessWidget {
  final Map<String, dynamic> episode;

  const _EpisodeCard({required this.episode});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    final downloads = episode['downloads'] as List<Map<String, String>>;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: CircleAvatar(child: Text(episode['episode'] as String)),

        title: Text(
          'Episode ${episode['episode']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Text(episode['date'] as String),

        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: downloads.map((download) {
                return _DownloadItem(
                  server: download['server']!,
                  quality: download['quality']!,
                  size: download['size']!,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// =========================================================
/// DOWNLOAD ITEM
/// =========================================================

class _DownloadItem extends StatelessWidget {
  final String server;
  final String quality;
  final String size;

  const _DownloadItem({
    required this.server,
    required this.quality,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: ListTile(
        leading: const Icon(Icons.download_outlined),

        title: Text(server),

        subtitle: Text('$quality • $size'),

        trailing: FilledButton(
          onPressed: () {
            // download action
          },
          child: const Text('Download'),
        ),
      ),
    );
  }
}

/// =========================================================
/// INFO CHIP
/// =========================================================

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 18), label: Text(label));
  }
}

/// =========================================================
/// GENRE CHIP
/// =========================================================

class _GenreChip extends StatelessWidget {
  final String label;

  const _GenreChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}
