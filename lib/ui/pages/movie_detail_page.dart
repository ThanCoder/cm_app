import 'package:cm_app/core/utils/api_utils.dart';
import 'package:flutter/material.dart';

class MovieDetailsPage extends StatelessWidget {
  const MovieDetailsPage({super.key});

  // Temporary API data
  static const movie = {
    'title': 'Na Willa',
    'year': '2026',
    'poster': 'https://media.homietv.com/file/all-asset-uploads/org_photos/cm-app-media-two/movies/2026-08-26/7WIkN9ODOqR8h404gxEyymth6fi.jpg',
    'overview': '''
Na Willa (2026)

IMDb Rating (7.9)

နာဝီလာဆိုတာ ၁၉၆၀ ပြည်လွန်နှစ်များက အင်ဒိုနီးရှားနိုင်ငံ ဆူရာဘာယာမြို့စွန်က အေးချမ်းတဲ့ရပ်ကွက်လေးထဲမှာနေထိုင်တဲ့ ၆ နှစ်အရွယ်ကလေးမလေးတစ်ယောက်ဖြစ်ပါတယ်။

မိခင်က အင်ဒိုဒေသခံတစ်ဦးဖြစ်ပြီး သူ့ရဲ့နွေးထွေးမှု၊ ဖခင်ဖြစ်သူ တရုတ်အမျိုးသားဘက်က အလိုလိုက်မှုတွေနဲ့ ယဉ်ကျေးမှုနှစ်ခုပေါင်းစပ်ထားတဲ့ မိသားစုလေးမှာ ပျော်ရွှင်စွာကြီးပြင်းလာရပါတယ်။

ဒီဇာတ်ကားမှာတော့ အရာရာကိုစူးစမ်းချင်စိတ်ပြင်းပြပြီး ဖြူစင်ရိုးသားလွန်းတဲ့ နာဝီလာလေးရဲ့မျက်လုံးကတစ်ဆင့် သူ့ကမ္ဘာကြီးကို ရှုမြင်ခံစားရမှာဖြစ်ပါတယ်။
''',
    'rating': '7.9',
    'runtime': '118',
    'releaseDate': '2026-03-18',
    'director': 'Ryan Adriandhy',
  };

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 800;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: isDesktop ? 380 : 280,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
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
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    ApiUtils.getProxyUrl(movie['poster']!),
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported_outlined),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),

                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: .15),
                          Colors.black.withValues(alpha: .85),
                          Theme.of(context).colorScheme.surface,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 32 : 16),
                  child: isDesktop ? _DesktopLayout() : _MobileLayout(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= MOBILE =================

class _MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MovieTitle(),

        const SizedBox(height: 16),

        _MovieInfo(),

        const SizedBox(height: 24),

        const _SectionTitle(title: 'Overview'),

        const SizedBox(height: 10),

        Text(
          MovieDetailsPage.movie['overview']!,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.7),
        ),

        const SizedBox(height: 28),

        const _SectionTitle(title: 'Genres'),

        const SizedBox(height: 12),

        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(label: Text('Comedy')),
            Chip(label: Text('Drama')),
            Chip(label: Text('Family')),
          ],
        ),

        const SizedBox(height: 32),

        const _SectionTitle(title: 'Download'),

        const SizedBox(height: 12),

        const _DownloadList(),
      ],
    );
  }
}

/// ================= DESKTOP =================

class _DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 280,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Image.network(
                    ApiUtils.getProxyUrl(MovieDetailsPage.movie['poster']!),
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported_outlined),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Watch Now'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 40),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MovieTitle(),

              const SizedBox(height: 20),

              _MovieInfo(),

              const SizedBox(height: 28),

              const _SectionTitle(title: 'Overview'),

              const SizedBox(height: 10),

              Text(
                MovieDetailsPage.movie['overview']!,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(height: 1.8),
              ),

              const SizedBox(height: 28),

              const _SectionTitle(title: 'Genres'),

              const SizedBox(height: 12),

              const Wrap(
                spacing: 8,
                children: [
                  Chip(label: Text('Comedy')),
                  Chip(label: Text('Drama')),
                  Chip(label: Text('Family')),
                ],
              ),

              const SizedBox(height: 36),

              const _SectionTitle(title: 'Download'),

              const SizedBox(height: 12),

              const _DownloadList(),
            ],
          ),
        ),
      ],
    );
  }
}

/// ================= TITLE =================

class _MovieTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          MovieDetailsPage.movie['title']!,
          style: Theme.of(context).textTheme.headlineLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            Text(MovieDetailsPage.movie['year']!),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('•'),
            ),

            const Icon(Icons.schedule, size: 18),

            const SizedBox(width: 4),

            Text('${MovieDetailsPage.movie['runtime']} min'),
          ],
        ),
      ],
    );
  }
}

/// ================= INFO =================

class _MovieInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, size: 20, color: Colors.amber.shade700),
              const SizedBox(width: 5),
              Text(
                MovieDetailsPage.movie['rating']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        _InfoChip(
          icon: Icons.calendar_today_outlined,
          label: MovieDetailsPage.movie['releaseDate']!,
        ),

        _InfoChip(
          icon: Icons.person_outline,
          label: MovieDetailsPage.movie['director']!,
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 18), label: Text(label));
  }
}

/// ================= SECTION TITLE =================

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

/// ================= DOWNLOAD =================

class _DownloadList extends StatelessWidget {
  const _DownloadList();

  @override
  Widget build(BuildContext context) {
    final downloads = [
      {
        'server': 'Yoteshin',
        'quality': '1080p',
        'type': 'WEB-DL',
        'size': '1.8 GB',
      },
      {
        'server': 'Megaup',
        'quality': '1080p',
        'type': 'WEB-DL',
        'size': '1.8 GB',
      },
      {
        'server': 'Yoteshin',
        'quality': '720p',
        'type': 'WEB-DL',
        'size': '1 GB',
      },
      {'server': 'Megaup', 'quality': '720p', 'type': 'WEB-DL', 'size': '1 GB'},
      {
        'server': 'Telegram',
        'quality': '720p',
        'type': 'WEB-DL',
        'size': '1 GB',
      },
    ];

    return Column(
      children: downloads.map((item) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(
                item['server'] == 'Telegram'
                    ? Icons.telegram
                    : Icons.download_rounded,
              ),
            ),

            title: Text(
              item['server']!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            subtitle: Text(
              '${item['quality']} • ${item['type']} • ${item['size']}',
            ),

            trailing: FilledButton(
              onPressed: () {
                // Open URL
              },
              child: const Text('Download'),
            ),
          ),
        );
      }).toList(),
    );
  }
}
