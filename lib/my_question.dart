import 'package:flutter/material.dart';
import 'package:zdy_flutter/net/Api.dart';

class MyQuestionPage extends StatefulWidget {
  MyQuestionPage();

  @override
  _MyQuestionPageState createState() => _MyQuestionPageState();
}

class _MyQuestionPageState extends State<MyQuestionPage> {
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
          title: Text("问题反馈"),
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
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Stack(
                              children: <Widget>[
                                Opacity(
                                  opacity: 0.95,
                                  child: Center(
                                    child: Image(
                                      image: new AssetImage(
                                          "image/question_bg.png"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[],
                                )
                              ],
                            ))
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
