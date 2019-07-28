import 'package:flutter/material.dart';
import 'package:zdy_flutter/model/product_info.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'url.dart';

class MyUsPage extends StatefulWidget {
  MyUsPage(this.product);

  Product product;

  @override
  _MyUsPageState createState() => _MyUsPageState();
}

class _MyUsPageState extends State<MyUsPage> {
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

    //去友情链接
    return new Scaffold(
        //方式输入法顶掉背景图片
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("友情链接"),
          backgroundColor: Colors.purple[400],
        ),
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
                      children: <Widget>[
                        new Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: new Column(children: <Widget>[
                              new Image.network(Api.BaseUrl +
                                  "/" +
                                  widget.product.descImageUrl),
                              new Text(widget.product.descContent)
                            ]))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
