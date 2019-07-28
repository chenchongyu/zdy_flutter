import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class UrlPage extends StatefulWidget {
  UrlPage(this.url);

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
          title: Text("友情链接"),
          backgroundColor: Colors.purple[400],
        ),withZoom: true,);
  }
}
