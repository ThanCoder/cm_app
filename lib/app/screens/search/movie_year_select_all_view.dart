import 'package:cm_app/app/models/movie_year_model.dart';
import 'package:cm_app/app/services/cm_services.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class MovieYearSelectAllView extends StatefulWidget {
  int showLength;
  List<MovieYearModel> list;
  void Function(MovieYearModel year) onClicked;
  void Function(List<MovieYearModel> list)? onLoaded;
  MovieYearSelectAllView({
    super.key,
    this.list = const [],
    required this.onClicked,
    this.showLength = 20,
    this.onLoaded,
  });

  @override
  State<MovieYearSelectAllView> createState() => _MovieYearSelectAllViewState();
}

class _MovieYearSelectAllViewState extends State<MovieYearSelectAllView> {
  @override
  void initState() {
    super.initState();
    list = widget.list;
    if (list.isEmpty) {
      init();
    }
  }

  bool isLoading = false;
  List<MovieYearModel> list = [];
  bool isExpanded = false;

  int getMinLength() {
    return list.take(widget.showLength).length;
  }

  void init() async {
    setState(() {
      isLoading = true;
    });
    list = await CMServices.getYearList(isOverride: true);
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
                  'Year',
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
