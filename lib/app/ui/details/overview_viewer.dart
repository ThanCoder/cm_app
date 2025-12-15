import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/core/models/movie_detail.dart';
import 'package:cm_app/app/core/models/series_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:t_widgets/t_widgets.dart';

import 'package:than_pkg/than_pkg.dart';

class OverviewViewer<T> extends StatefulWidget {
  final Movie movie;
  final T? detail;
  const OverviewViewer({super.key, required this.movie, required this.detail});

  @override
  State<OverviewViewer<T>> createState() => _OverviewViewerState<T>();

  static String getCleanHtml(String text) {
    final res = text
        .replaceAll('&nbsp;', '<br/>')
        .replaceAllMapped(
          RegExp(r'(<img\b[^>]*?)\swidth="[^"]*"([^>]*>)'),
          (match) => '${match.group(1)} width="100%"${match.group(2)}',
        )
        .replaceAllMapped(
          RegExp(r'(<img\b[^>]*?)\sheight="[^"]*"([^>]*>)'),
          (match) => '${match.group(1)} width="auto"${match.group(2)}',
        )
        // 2️⃣ width မပါရင် ထည့်
        .replaceAllMapped(
          RegExp(r'<img(?![^>]*\bwidth=)([^>]*)>'),
          (match) => '<img${match.group(1)} width="100%">',
        )
        // 3️⃣ height မပါရင် height="auto" ထည့်
        .replaceAllMapped(
          RegExp(r'(<img\b(?![^>]*\bheight=)[^>]*>)'),
          (match) => match.group(1)!.replaceFirst('>', ' height="auto">'),
        )
        .replaceAll('\n\n', '<br/>')
        .trim();
    return res;
  }
}

class _OverviewViewerState<T> extends State<OverviewViewer<T>> {
  // @override
  // void didUpdateWidget(covariant OverviewViewer<T> oldWidget) {
  //   if (oldWidget.detail != widget.detail) {
  //     setState(() {});
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.detail == null) {
      return Center(child: Text('Movie Detail မရှိပါ!...'));
    }
    return _getViews();
  }

  Widget _getViews() {
    if (T == MovieDetail) {
      return _getMovieDetail();
    }
    if (T == SeriesDetail) {
      return _getSeriesDetail();
    }

    return Center(child: Text('Detail Type: `$T` မရှိပါ!...'));
  }

  Widget _getMovieDetail() {
    final det = widget.detail as MovieDetail;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text('Original Title: `${det.originalTitle}`'),
            det.runtime.isEmpty
                ? SizedBox.shrink()
                : Text('Runtime: ${det.runtime}  Minutes'),
            Text('Year: ${widget.movie.year}'),
            Text('is Adult: ${det.isAdult ? 'Yes' : 'No'}'),
            // Text('Directors	:${widget.movie.id}'),
            _getCategories(),
            Divider(),
            _getDesc(det.overview),
          ],
        ),
      ),
    );
  }

  Widget _getSeriesDetail() {
    final det = widget.detail as SeriesDetail;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text('Original Title: `${det.originalTitle}`'),
            det.runtime.isEmpty
                ? SizedBox.shrink()
                : Text('Runtime: ${det.runtime}  Minutes'),
            Text('Year: ${widget.movie.year}'),
            Text('is Adult: ${det.isAdult ? 'Yes' : 'No'}'),
            _getCategories(),
            Divider(),
            _getDesc(det.overview),
          ],
        ),
      ),
    );
  }

  Widget _getCategories() {
    final list = widget.movie.categories;
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: List.generate(list.length, (index) {
        final item = list[index];
        return TChip(
          title: Text(item.name),
          onClick: () {
            debugPrint('Category: ${item.name}: id: ${item.id}');
          },
        );
      }),
    );
  }

  Widget _getDesc(String text) {
    if (isFoundHtmlTag(text)) {
      return SizedBox(
        width: double.infinity,
        child: Html(
          data: OverviewViewer.getCleanHtml(text),
          style: {
            '*': Style(fontSize: FontSize(16)),
            // 'img': Style(width: Width(100, Unit.percent)),
          },

          onLinkTap: (url, attributes, element) {
            if (url == null || url.isEmpty) {
              showTMessageDialogError(context, 'Url မရှိပါ!...');
              return;
            }
            _showMenu(url);
          },
        ),
      );
    }
    return SelectableText(text, style: TextStyle(fontSize: 16));
  }

  bool isFoundHtmlTag(String text) {
    final htmlTagRegex = RegExp(r'<[^>]+>');
    return htmlTagRegex.hasMatch(text);
    // return false;
  }

  void _showMenu(String url) {
    showTMenuBottomSheet(
      context,
      children: [
        ListTile(
          leading: Icon(Icons.open_in_browser),
          title: Text('Open Url'),
          onTap: () {
            Navigator.pop(context);
            ThanPkg.platform.launch(url);
          },
        ),
        ListTile(
          leading: Icon(Icons.copy),
          title: Text('Copy Url'),
          onTap: () {
            Navigator.pop(context);
            ThanPkg.appUtil.copyText(url);
          },
        ),
      ],
    );
  }
}
