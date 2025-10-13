import 'package:cm_app/app/core/models/movie.dart';
import 'package:cm_app/app/services/movie_recent_services.dart';
import 'package:cm_app/app/ui/components/one_line_movie_component.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/t_database/index.dart';

class RecentMovieComponent extends StatefulWidget {
  final void Function(Movie movie)? onClicked;
  const RecentMovieComponent({super.key, this.onClicked});

  @override
  State<RecentMovieComponent> createState() => _RecentMovieComponentState();
}

class _RecentMovieComponentState extends State<RecentMovieComponent>
    with TDatabaseListener {
  @override
  void initState() {
    MovieRecentServices.getDatabase.addListener(this);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  void dispose() {
    MovieRecentServices.getDatabase.removeListener(this);
    super.dispose();
  }

  @override
  void onDatabaseChanged(TDatabaseListenerTypes type, String? id) {
    if (type == TDatabaseListenerTypes.saved) {
      if (!mounted) return;
      init();
    }
  }

  List<Movie> list = [];
  bool isLoading = false;

  Future<void> init() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(Duration(milliseconds: 500));

      list = await MovieRecentServices.getDatabase.getAll();
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      debugPrint('[RecentMovieComponent:init]:${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return TLoader.random();
    }
    return OneLineMovieComponent(
      title: 'Recent',
      list: list,
      onClicked: widget.onClicked,
    );
  }
}
