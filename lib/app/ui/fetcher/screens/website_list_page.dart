import 'package:cm_app/app/core/extensions/build_context_extensions.dart';
import 'package:cm_app/app/ui/fetcher/screens/fetcher_home_page.dart';
import 'package:cm_app/app/ui/fetcher/services/website_services.dart';
import 'package:cm_app/app/ui/fetcher/types/website.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/extensions/index.dart';

class WebsiteListPage extends StatefulWidget {
  const WebsiteListPage({super.key});

  @override
  State<WebsiteListPage> createState() => _WebsiteListPageState();
}

class _WebsiteListPageState extends State<WebsiteListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  bool isLoading = false;
  List<Website> sites = [];
  Future<void> init() async {
    try {
      if (isLoading) return;
      setState(() {
        isLoading = true;
      });
      sites = await WebsiteServices.instace.getList();
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
      appBar: AppBar(title: Text('Fetcher Websites'), actions: _actions),
      body: RefreshIndicator.adaptive(
        onRefresh: init,
        child: CustomScrollView(
          slivers: [
            if (isLoading)
              SliverFillRemaining(child: Center(child: TLoaderRandom())),

            if (sites.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: RefreshButton(
                    text: Text('List Empty'),
                    onClicked: init,
                  ),
                ),
              )
            else
              _list,
          ],
        ),
      ),
    );
  }

  List<Widget> get _actions => [
    if (TPlatform.isDesktop)
      IconButton(onPressed: init, icon: Icon(Icons.refresh)),
  ];

  Widget get _list => SliverList.builder(
    itemCount: sites.length,
    itemBuilder: (context, index) => _listItem(sites[index]),
  );

  Widget _listItem(Website site) {
    return ListTile(
      title: Text(site.title),
      onTap: () {
        context.goRoute(builder: (context) => FetcherHomePage(website: site));
      },
    );
  }
}
