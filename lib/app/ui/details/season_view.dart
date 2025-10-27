import 'package:cm_app/app/core/models/season.dart';
import 'package:cm_app/app/core/models/series_detail.dart';
import 'package:cm_app/more_libs/setting_v2.8.3/setting.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class SeasonView extends StatefulWidget {
  final SeriesDetail detail;
  final void Function(Episode episode)? onClicked;
  const SeasonView({super.key, required this.detail, this.onClicked});

  @override
  State<SeasonView> createState() => _SeasonViewState();
}

class _SeasonViewState extends State<SeasonView> {
  List<Episode> list = [];
  Season? season;
  @override
  void initState() {
    if (widget.detail.seasons.isNotEmpty) {
      season = widget.detail.seasons.first;
      list = widget.detail.seasons.first.episodes;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _getSeasonWidget(),

        // current Season
        SliverToBoxAdapter(child: Divider()),
        _getEpisodeList(),
      ],
    );
  }

  Widget _getSeasonWidget() {
    final seasonTitles = widget.detail.seasons.map((e) => e.name).toList();
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: List.generate(seasonTitles.length, (index) {
            final item = seasonTitles[index];
            return TChip(
              avatar: season != null && season!.name == item
                  ? Icon(Icons.check)
                  : null,
              title: Text(item),
              onClick: () {
                final index = widget.detail.seasons.indexWhere(
                  (e) => e.name == item,
                );
                if (index == -1) return;
                season = widget.detail.seasons[index];
                list = season!.episodes;
                setState(() {});
              },
            );
          }).toList(),
        ),
      ),
    );
    /* TTagsWrapView(
        values: seasonTitles,
        onClicked: (value) {
          final index = widget.detail.seasons.indexWhere(
            (e) => e.name == value,
          );
          if (index == -1) return;
          season = widget.detail.seasons[index];
          list = season!.episodes;
          setState(() {});
        },
      )*/
  }

  Widget _getEpisodeList() {
    return SliverList.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => _getListItem(list[index]),
    );
  }

  Widget _getListItem(Episode ep) {
    return GestureDetector(
      onTap: () => widget.onClicked?.call(ep),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 5,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: TImage(source: Setting.getForwardProxyUrl(ep.poster)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Episode-${ep.episodeNumber}'),
                    Text('Air Date: ${ep.airDate}'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
