import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class UrlPage extends StatefulWidget {
  UrlPage(this.url, this.title);

  String title;
  String url;

  @override
  _UrlPageState createState() => _UrlPageState();
}

class _UrlPageState extends State<UrlPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //去友情链接
    return new WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.purple[400],
      ),
      withZoom: true,
    );
  }
}
