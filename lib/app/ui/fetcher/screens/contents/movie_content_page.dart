import 'package:cm_app/app/ui/fetcher/services/fetcher_services.dart';
import 'package:cm_app/app/ui/fetcher/types/content_responses.dart';
import 'package:cm_app/app/ui/fetcher/types/website.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/functions/message_func.dart';
import 'package:t_widgets/widgets/refresh_button.dart';
import 'package:t_widgets/widgets/t_cache_image.dart';
import 'package:than_pkg/than_pkg.dart';

class MovieContentPage extends StatefulWidget {
  final WebsitePageResult result;
  final Website website;
  final String html;
  const MovieContentPage({
    super.key,
    required this.html,
    required this.website,
    required this.result,
  });

  @override
  State<MovieContentPage> createState() => _MovieContentPageState();
}

class _MovieContentPageState extends State<MovieContentPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  bool isLoading = false;
  MovieContentResponse? response;

  Future<void> init() async {
    try {
      if (isLoading) return;
      setState(() {
        isLoading = true;
      });
      response = await FetcherServices.instace.fetchMoviePageContent(
        widget.html,
        website: widget.website,
      );

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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _header,
          SliverToBoxAdapter(child: Divider()),
          if (response == null)
            SliverFillRemaining(
              child: RefreshButton(
                text: Text('Content မရှိပါ'),
                onClicked: init,
              ),
            )
          else
            _resultWidget,
          SliverToBoxAdapter(child: Divider()),
          if (response != null && response!.downloadItems.isNotEmpty)
            _downloadListWidget,
        ],
      ),
      // floatingActionButton: FloatingActionButton(onPressed: init),
    );
  }

  Widget get _header {
    return SliverToBoxAdapter(
      child: Card(
        child: Row(
          spacing: 5,
          children: [
            SizedBox(
              width: 140,
              height: 180,
              child: TCacheImage(url: widget.result.coverUrl),
            ),
            Text(widget.result.title),
          ],
        ),
      ),
    );
  }

  Widget get _resultWidget {
    return SliverToBoxAdapter(child: Text(response!.descText));
  }

  Widget get _downloadListWidget {
    return SliverList.builder(
      itemCount: response!.downloadItems.length,
      itemBuilder: (context, index) =>
          _downloadListItem(response!.downloadItems[index]),
    );
  }

  Widget _downloadListItem(MovieContentDownloadItem item) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () {
        try {
          ThanPkg.platform.launch(item.url);
        } catch (e) {
          showTMessageDialogError(context, e.toString());
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('T: ${item.title}'),
                    Text('Quality: ${item.quality}'),
                    Text('Size: ${item.size}'),
                  ],
                ),
              ),
              Icon(Icons.download),
            ],
          ),
        ),
      ),
    );
  }
}
