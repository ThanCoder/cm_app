import 'package:cm_app/app/ui/fetcher/services/fetcher_services.dart';
import 'package:cm_app/app/ui/fetcher/types/website.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class WebsiteContentPage extends StatefulWidget {
  final WebsitePageResult result;
  final Website website;
  const WebsiteContentPage({
    super.key,
    required this.result,
    required this.website,
  });

  @override
  State<WebsiteContentPage> createState() => _WebsiteContentPageState();
}

class _WebsiteContentPageState extends State<WebsiteContentPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  bool isLoading = false;

  Future<void> init() async {
    try {
      if (isLoading) return;
      setState(() {
        isLoading = true;
      });
      await FetcherServices.instace.fetchPageContent(
        widget.result.url,
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
      appBar: AppBar(title: Text(widget.result.title), actions: _actions),
      body: RefreshIndicator.adaptive(
        onRefresh: init,
        child: CustomScrollView(
          slivers: [
            if (isLoading)
              SliverFillRemaining(child: Center(child: TLoaderRandom())),
          ],
        ),
      ),
    );
  }

  List<Widget> get _actions => [
    if (TPlatform.isDesktop)
      IconButton(onPressed: init, icon: Icon(Icons.refresh)),
  ];
}
