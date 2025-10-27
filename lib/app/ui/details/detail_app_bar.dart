import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/core/models/movie_detail.dart';
import 'package:cm_app/app/core/models/series_detail.dart';
import 'package:cm_app/app/ui/components/movie_bookmark_button.dart';
import 'package:cm_app/app/ui/details/overview_viewer.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets_dev.dart';
import 'package:than_pkg/than_pkg.dart';

class DetailAppBar<T> extends StatefulWidget {
  final Movie movie;
  final void Function()? onInit;
  final T? detail;
  const DetailAppBar({
    super.key,
    required this.movie,
    this.detail,
    this.onInit,
  });

  @override
  State<DetailAppBar> createState() => _DetailAppBarState();
}

class _DetailAppBarState extends State<DetailAppBar> {
  @override
  void didUpdateWidget(covariant DetailAppBar oldWidget) {
    if (oldWidget.detail != widget.detail) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      snap: true,
      floating: true,
      pinned: false,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios_new),
      ),
      actions: [
        // bookmark
        MovieBookmarkButton(movie: widget.movie),
        IconButton(
          onPressed: _showMenu,
          icon: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(Icons.more_vert, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _showMenu() {
    showTMenuBottomSheet(
      context,
      children: [
        ListTile(
          leading: Icon(Icons.refresh),
          title: Text('Refresh'),
          onTap: () {
            Navigator.pop(context);
            widget.onInit?.call();
          },
        ),
        ListTile(
          leading: Icon(Icons.copy),
          title: Text('Copy Soure Url'),
          onTap: () {
            Navigator.pop(context);
            ThanPkg.appUtil.copyText(widget.movie.url);
          },
        ),
        ListTile(
          leading: Icon(Icons.copy),
          title: Text('Copy Title'),
          onTap: () {
            Navigator.pop(context);
            ThanPkg.appUtil.copyText(widget.movie.title);
          },
        ),
        ListTile(
          leading: Icon(Icons.copy_all),
          title: Text('Copy Overview Text'),
          onTap: () {
            Navigator.pop(context);
            if (widget.detail == null) return;
            if (widget.detail.runtimeType == SeriesDetail) {
              final det = widget.detail as SeriesDetail;
              ThanPkg.appUtil.copyText(
                OverviewViewer.getCleanHtml(det.overview),
              );
            }
            if (widget.detail.runtimeType == MovieDetail) {
              final det = widget.detail as MovieDetail;
              ThanPkg.appUtil.copyText(
                OverviewViewer.getCleanHtml(det.overview),
              );
            }
          },
        ),
      ],
    );
  }
}
