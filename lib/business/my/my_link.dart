import 'package:flutter/material.dart';
import 'package:zdy_flutter/model/link_info.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/url.dart';
import 'package:zdy_flutter/widget/my_app_bar.dart';

class MyLinkPage extends StatefulWidget {
  MyLinkPage(this.linkInfo);

  LinkInfo linkInfo;

  @override
  _MyLinkPageState createState() => _MyLinkPageState();
}

class _MyLinkPageState extends State<MyLinkPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //屏幕分辨率
    MediaQueryData queryData = MediaQuery.of(context);
    //宽
    double screen_width = queryData.size.width;

    ///渲染友情链接
    _buildLink(LinkInfo linkInfo) {
      List<Widget> list = [];
      for (int i = 0; i < linkInfo.linklist.length; i++) {
        Link link = linkInfo.linklist[i];
        list.add(new Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: new Stack(children: <Widget>[
              MaterialButton(
                  child:
                      new Image.network(Api.BaseUrl + "/" + link.descImageUrl),
                  onPressed: () {
                    ///跳转链接
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UrlPage(link.descVisitUrl,link.descTitle)));
                  })
            ])));
      }
      return list;
    }

    List<Widget> lstLink = _buildLink(widget.linkInfo);

    //去友情链接
    return new Scaffold(
        //方式输入法顶掉背景图片
        resizeToAvoidBottomPadding: false,
        appBar: MyAppBar("友情链接"),
        body: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Stack(
            alignment: Alignment.topLeft, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
              Scrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Center(
                    child: Column(
                      //动态创建一个List<Widget>
                      children: lstLink,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
