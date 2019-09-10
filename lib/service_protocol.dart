import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zdy_flutter/main.dart';
import 'package:zdy_flutter/util/constant.dart';
import 'package:zdy_flutter/util/sp_util.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ServiceProtocol extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ServiceState();
  }
}

class _ServiceState extends State<ServiceProtocol> {
  Future<String> _getFile() async {
    return await rootBundle.loadString('files/protocol.html');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getFile(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return WebviewScaffold(
            appBar: AppBar(title: Text("服务协议2",
                style: TextStyle(
                    fontFamily: "style1",
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))),
            withJavascript: true,
            appCacheEnabled: true,
            withLocalUrl: true,
            hidden: true,
            allowFileURLs: true,
            url: new Uri.dataFromString(snapshot.data,
                    mimeType: 'text/html',
                    encoding: Encoding.getByName('utf-8'))
                .toString(),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 70,
                      alignment: Alignment.center,
                      child: GestureDetector(
                          child: Text("同意"),
                          onTap: () async {
                            await SpUtil.putInt(Constant.KEY_HAS_PROTOCOL, 1);
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return MyApp();
                            }), (route) => route == null);
                          }),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 70,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          child: Text("不同意"),
                          onTap: () {
                            exit(0);
                          },
                        ),
                      ))
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("${snapshot.error}"),
            ),
          );
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
