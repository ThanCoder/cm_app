
import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/core/models/series_detail.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/widgets/t_loader.dart';

class SeriesDetailScreen extends StatefulWidget {
  final Movie movie;
  const SeriesDetailScreen({super.key, required this.movie});

  @override
  State<SeriesDetailScreen> createState() => _SeriesDetailScreenState();
}

class _SeriesDetailScreenState extends State<SeriesDetailScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  SeriesDetail? detail;
  bool isLoading = false;

  Future<void> init() async {
    // try {
    //   setState(() {
    //     isLoading = true;
    //   });
    //   final res = await ClientServices.instance.getUrlContent(
    //     Setting.getForwardProxyUrl(widget.movie.url),
    //   );
    //   final map = jsonDecode(res);
    //   detail = MovieDetail.fromMap(map['data']);
    //   if (!mounted) return;
    //   setState(() {
    //     isLoading = false;
    //   });
    // } catch (e) {
    //   if (!mounted) return;
    //   setState(() {
    //     isLoading = false;
    //   });
    //   showTMessageDialog(context, e.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [_getAppbar(), ..._getViews()]),
    );
  }

  Widget _getAppbar() {
    return SliverAppBar(title: Text(widget.movie.title));
  }

  List<Widget> _getViews() {
    if (isLoading) {
      return [SliverFillRemaining(child: Center(child: TLoader.random()))];
    }
    return [];
  }
}
