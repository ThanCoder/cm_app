import 'package:cm_app/app/ui/components/cache_image.dart';
import 'package:cm_app/app/ui/fetcher/services/fetcher_services.dart';
import 'package:cm_app/app/ui/fetcher/types/content_responses.dart';
import 'package:cm_app/app/ui/fetcher/types/movie_pagi_response.dart';
import 'package:cm_app/app/ui/fetcher/types/website.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class TvShowContentPage extends StatefulWidget {
  final MovieItem item;
  final Website website;
  final String html;
  const TvShowContentPage({
    super.key,
    required this.html,
    required this.website,
    required this.item,
  });

  @override
  State<TvShowContentPage> createState() => _TvShowContentPageState();
}

class _TvShowContentPageState extends State<TvShowContentPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  bool isLoading = false;
  TvShowContentResponse? response;

  Future<void> init() async {
    try {
      if (isLoading) return;
      setState(() {
        isLoading = true;
      });
      response = await FetcherServices.instace.fetchTVShowPageContent(
        widget.html,
        website: widget.website,
      );

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showTMessageDialogError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _itemWidget;
  }

  int pageIndex = 0;

  Widget get _itemWidget {
    if (response == null) {
      return Text('Response is Null');
    }
    final pages = [
      _HomePage(item: widget.item, response: response!),
      _CharacterList(list: response!.castList),
      _SeasonList(list: response!.seasons),
    ];

    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (value) => setState(() {
          pageIndex = value;
        }),
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: 'Character',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.slow_motion_video_sharp),
            label: 'Seasons',
          ),
        ],
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  final MovieItem item;
  final TvShowContentResponse response;
  const _HomePage({required this.item, required this.response});

  @override
  Widget build(BuildContext context) {
    return TScrollableColumn(
      children: [
        Card(
          child: Row(
            spacing: 5,
            children: [
              SizedBox(
                width: 140,
                height: 180,
                child: TCacheImage(url: item.coverUrl),
              ),
              Text(item.title),
            ],
          ),
        ),
        Text(response.descText, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}

class _CharacterList extends StatelessWidget {
  final List<TvShowCast> list;
  const _CharacterList({required this.list});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisExtent: 120,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final cast = list[index];
        return Row(
          spacing: 4,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CacheImage(url: cast.profileUrl, fit: BoxFit.cover),
            ),
            Expanded(
              child: Column(
                spacing: 2,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'T: ${cast.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(Icons.person),
                      Expanded(
                        child: Text(
                          cast.characterName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
        // return Text(cast.name);
      },
    );
  }
}

class _SeasonList extends StatefulWidget {
  final List<TvShowSeason> list;
  const _SeasonList({required this.list});

  @override
  State<_SeasonList> createState() => _SeasonListState();
}

class _SeasonListState extends State<_SeasonList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.list.length,
      itemBuilder: (context, index) => _listItem(widget.list[index]),
    );
  }

  Widget _listItem(TvShowSeason season) {
    return ExpansionTile(
      title: Text(season.title),
      children: season.episodios.map((e) => _episodeItem(e)).toList(),
    );
  }

  Widget _episodeItem(TvShowEpisode episode) {
    // print(episode.coverUrl);
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () {
        try {
          ThanPkg.platform.launch(episode.url);
        } catch (e) {
          showTMessageDialogError(context, e.toString());
        }
      },
      child: Card(
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CacheImage(
                url: episode.coverUrl,
                placeholder: (message) =>
                    Icon(Icons.image_not_supported_outlined),
              ),
            ),

            Expanded(
              child: Column(
                children: [Text(episode.title), Text(episode.number)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
