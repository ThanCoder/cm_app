import 'package:cm_app/app/core/models/movie_year.dart';
import 'package:cm_app/app/services/movie_services.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class MovieYearPage extends StatefulWidget {
  final void Function(MovieYear item)? onClicked;
  const MovieYearPage({super.key, this.onClicked});

  @override
  State<MovieYearPage> createState() => _MovieYearPageState();
}

class _MovieYearPageState extends State<MovieYearPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  static List<MovieYear> list = [];
  bool isLoading = false;

  Future<void> init({bool isUsedCache = true}) async {
    try {
      if (isUsedCache && list.isNotEmpty) return;
      setState(() {
        isLoading = true;
      });

      list = await MovieServices.getMovieYears();
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
    return Scaffold(body: _getList());
  }

  Widget _getList() {
    if (isLoading) {
      return Center(child: TLoader.random());
    }
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: [
            Text('List မရှိပါ!....'),
            IconButton(
              onPressed: init,
              icon: Icon(Icons.refresh),
              color: Colors.blue,
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) => _getListItem(list[index]),
    );
  }

  Widget _getListItem(MovieYear item) {
    return ListTile(
      leading: Icon(Icons.calendar_month),
      title: Text(item.year),
      trailing: Text(item.moviesCount.toString()),
      onTap: () => widget.onClicked?.call(item),
    );
  }
}
