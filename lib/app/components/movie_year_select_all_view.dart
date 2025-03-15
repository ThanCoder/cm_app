import 'package:cm_app/app/models/movie_year_model.dart';
import 'package:cm_app/app/services/c_m_services.dart';
import 'package:cm_app/app/widgets/index.dart';
import 'package:flutter/material.dart';

class MovieYearSelectAllView extends StatefulWidget {
  void Function(MovieYearModel year) onClicked;
  MovieYearSelectAllView({
    super.key,
    required this.onClicked,
  });

  @override
  State<MovieYearSelectAllView> createState() => _MovieYearSelectAllViewState();
}

class _MovieYearSelectAllViewState extends State<MovieYearSelectAllView> {
  @override
  void initState() {
    super.initState();
    init();
  }

  bool isLoading = true;
  List<MovieYearModel> list = [];
  bool isExpanded = false;

  int getMinLength() {
    return list.take(20).length;
  }

  void init() async {
    setState(() {
      isLoading = true;
    });
    list = await CMServices.instance.getYearList(isOverride: true);

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
                        title: year.title,
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
