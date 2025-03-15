import 'package:cm_app/app/models/movie_genres_model.dart';
import 'package:cm_app/app/services/c_m_services.dart';
import 'package:cm_app/app/widgets/index.dart';
import 'package:flutter/material.dart';

class GenresSelectAllView extends StatefulWidget {
  void Function(MovieGenresModel genres) onClicked;
  GenresSelectAllView({
    super.key,
    required this.onClicked,
  });

  @override
  State<GenresSelectAllView> createState() => _GenresSelectAllViewState();
}

class _GenresSelectAllViewState extends State<GenresSelectAllView> {
  @override
  void initState() {
    super.initState();
    init();
  }

  bool isLoading = true;
  List<MovieGenresModel> list = [];
  bool isExpanded = false;

  int getMinLength() {
    return list.take(20).length;
  }

  void init() async {
    setState(() {
      isLoading = true;
    });
    list = await CMServices.instance.getGenresList(isOverride: true);

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
                  'Genres',
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
                      final genres = list[index];
                      return TChip(
                        title: genres.title,
                        onClick: () => widget.onClicked(genres),
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
