import 'package:cm_app/app/models/movie.dart';
import 'package:cm_app/app/services/dio_services.dart';
import 'package:flutter/material.dart';
import 'package:t_html_parser/t_html_extensions.dart';
import 'package:t_widgets/t_widgets.dart';

typedef OnFetchedCallback = void Function(String htmlContent);

class HtmlFetcherDialog extends StatefulWidget {
  Movie movie;
  OnFetchedCallback? onMovieFetched;
  OnFetchedCallback? onSeriesFetched;
  bool isUseCacheHtml;
  HtmlFetcherDialog({
    super.key,
    required this.movie,
    this.isUseCacheHtml = true,
    this.onMovieFetched,
    this.onSeriesFetched,
  });

  @override
  State<HtmlFetcherDialog> createState() => _HtmlFetcherDialogState();
}

class _HtmlFetcherDialogState extends State<HtmlFetcherDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  Future<void> init() async {
    try {
      var html = '';
      if (widget.isUseCacheHtml) {
        html = await DioServices.instance.getCacheHtml(
          url: widget.movie.url,
          cacheName: widget.movie.title.replaceAll('/', '--'),
        );
      } else {
        html = await DioServices.instance.getHtml(widget.movie.url);
      }

      if (!mounted) return;
      final ele = html.toHtmlElement;
      if (ele == null) {
        Navigator.pop(context);
        return;
      }
      final tvContetText = ele.getQuerySelectorHtml(selector: '.contenidotv');
      final movieContetText = ele.getQuerySelectorHtml(
        selector: '.entry-content',
      );
      if (movieContetText.isNotEmpty) {
        Navigator.pop(context);
        widget.onMovieFetched?.call(html);
        return;
      }
      if (tvContetText.isNotEmpty) {
        Navigator.pop(context);
        widget.onSeriesFetched?.call(html);
      }
    } catch (e) {
      if (!mounted) return;
      showTMessageDialogError(context, e.toString());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      content: Column(
        spacing: 5,
        children: [
          SizedBox(height: 80, width: 80, child: TLoader.random()),
          Text('ခဏစောင့်ဆိုင်းပေးပါ....'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('ပိတ်မယ်'),
        ),
      ],
    );
  }
}
