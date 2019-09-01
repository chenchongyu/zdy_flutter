import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  HelpPage();

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    //屏幕分辨率
    MediaQueryData queryData = MediaQuery.of(context);
    //宽
    double screen_width = queryData.size.width;
    return new Scaffold(
        //方式输入法顶掉背景图片
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            "使用帮助",
            style: new TextStyle(
                fontFamily: "style1",
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          leading: MaterialButton(
              child: Image(
                image: new AssetImage("image/leading.png"),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Stack(
            alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
              Scrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      //动态创建一个List<Widget>
                      children: [
                        Image(
                            image: new AssetImage("image/help.jpg"),
                            width: screen_width)
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
