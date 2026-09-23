import 'package:flutter/material.dart';

class WebsiteProvider {
  final String title;
  final String hostUrl;

  const WebsiteProvider({required this.title, required this.hostUrl});
}

class WebsiteProviderScreen extends StatefulWidget {
  const new({super.key, required this.childBuilder});
  final Widget Function(WebsiteProvider provider) childBuilder;

  @override
  State<WebsiteProviderScreen> createState() => _WebsiteProviderScreenState();
}

class _WebsiteProviderScreenState extends State<WebsiteProviderScreen> {
  WebsiteProvider? provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: provider != null ? null : AppBar(title: Text('Website Provider')),
      body: _body,
    );
  }

  Widget get _body {
    if (provider != null) {
      return widget.childBuilder(provider!);
    }
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          ListTile(
            title: Text('Movie One'),
            onTap: () {
              provider = .new(title: 'CM', hostUrl: 'https://www.homietv.com');
              setState(() {});
            },
          ),
          ListTile(
            title: Text('Movie Two'),
            onTap: () {
              provider = .new(title: 'CM', hostUrl: 'https://www.ysflix.com');
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
