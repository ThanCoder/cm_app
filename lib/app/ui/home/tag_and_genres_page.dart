import 'package:cm_app/app/core/models/tag_and_genres.dart';
import 'package:cm_app/app/core/services/movie_services.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class TagAndGenresPage extends StatefulWidget {
  final String url;
  final void Function(TagAndGenres item)? onClicked;
  const TagAndGenresPage({super.key, required this.url, this.onClicked});

  @override
  State<TagAndGenresPage> createState() => _TagAndGenresPageState();
}

class _TagAndGenresPageState extends State<TagAndGenresPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  static final Map<String, List<TagAndGenres>> _cache = {};

  List<TagAndGenres> list = [];
  bool isLoading = false;

  Future<void> init({bool isUsedCache = true}) async {
    try {
      final key = widget.url.replaceAll('/', '-');
      if (isUsedCache) {
        if (_cache.containsKey(key)) {
          list = _cache[key]!;
          setState(() {});
          return;
        }
      }

      setState(() {
        isLoading = true;
      });

      list = await MovieServices.getTagAndGenresList(widget.url);
      // set
      _cache[key] = list;
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
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => _getListItem(list[index]),
    );
  }

  Widget _getListItem(TagAndGenres item) {
    return ListTile(
      leading: Icon(Icons.tag),
      title: Text(item.name),
      trailing: Text(item.moviesCount.toString()),
      onTap: () => widget.onClicked?.call(item),
    );
  }
}
