import 'package:cm_app/app/models/movie_genres_model.dart';
import 'package:cm_app/app/services/c_m_services.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class MovieGenersSelectAllView extends StatefulWidget {
  int showLength;
  List<MovieGenresModel> list;
  void Function(MovieGenresModel year) onClicked;
  void Function(List<MovieGenresModel> list)? onLoaded;
  MovieGenersSelectAllView({
    super.key,
    this.list = const [],
    required this.onClicked,
    this.showLength = 20,
    this.onLoaded,
  });

  @override
  State<MovieGenersSelectAllView> createState() =>
      _MovieGenersSelectAllViewState();
}

class _MovieGenersSelectAllViewState extends State<MovieGenersSelectAllView> {
  @override
  void initState() {
    super.initState();
    list = widget.list;
    if (list.isEmpty) {
      init();
    }
  }

  bool isLoading = false;
  List<MovieGenresModel> list = [];
  bool isExpanded = false;

  int getMinLength() {
    return list.take(widget.showLength).length;
  }

  void init() async {
    setState(() {
      isLoading = true;
    });
    list = await CMServices.getGenresList(isOverride: true);
    if (widget.onLoaded != null) {
      widget.onLoaded!(list);
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 5,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Geners',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            isLoading
                ? TLoader()
                : Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: List.generate(
                        isExpanded ? list.length : getMinLength(), (index) {
                      final year = list[index];
                      return TChip(
                        title: Text(year.title),
                        onClick: () => widget.onClicked(year),
                      );
                    }),
                  ),
            isLoading
                ? SizedBox.shrink()
                : TextButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(isExpanded ? 'Read Less' : 'Read More'),
                  ),
          ],
        ),
      ),
    );
  }
}
