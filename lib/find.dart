import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zdy_flutter/model/user.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/search_result.dart';
import 'package:zdy_flutter/main.dart';

class FindPage extends StatefulWidget {
  FindPage(this.keywords);

  final String keywords;

  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  String text = "";
  final hotWordStyle = TextStyle(color: Colors.black, fontSize: 14);

  static const platform = const MethodChannel("test");

  ///跳转首页面
  gotoHome() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  Widget buildTextField(TextEditingController controller, FocusNode focusNode) {
    return TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
            hintText: "请输入药名",
            contentPadding: const EdgeInsets.all(20.0),
            hintStyle: new TextStyle(color: Colors.black),
            border: OutlineInputBorder(
                borderSide:
                    new BorderSide(color: Colors.lightBlue, width: 15.0))),
        maxLines: 4,
        textInputAction: TextInputAction.search,
        onSubmitted: (val) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SearchResultView(controller.text)));
        });
  }

  @override
  Widget build(BuildContext context) {
    //屏幕分辨率
    MediaQueryData queryData = MediaQuery.of(context);
    //高
    double screen_width = queryData.size.width;
    //宽
    double screen_heigth = queryData.size.height;
    //像素比
    double devicePixelRatio = queryData.devicePixelRatio;
    print(screen_width);
    print(screen_heigth);
    print(devicePixelRatio);

    FocusNode nodeOne = FocusNode();
    final controller = TextEditingController();
    if (text.length > 0) {
      controller.text = text;
    }
    //输入框添加监听 方便用于查询
    controller.addListener(() {
      if (controller.text.length > 0 &&
          controller.text.indexOf("\n") == controller.text.length - 1) {
        FocusScope.of(context).requestFocus(FocusNode());
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
        //todo 触发查询
        print("输入的数据：" + controller.text);
        if (controller.text.length > 0) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SearchResultView(controller.text)));
        }
      }
    });
    Widget warning = new Center(
        child: Padding(
            padding: EdgeInsets.fromLTRB(40, 50, 40, 0),
            child: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("image/warning_bg.png"),
                    fit: BoxFit.contain),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Image(
                      image: new AssetImage("image/warning_img.png"),
                    ),
                  ),
                  Expanded(
                    child: Image(
                      image: new AssetImage("image/warning_text.png"),
                    ),
                  ),
                ],
              ),
            )));

    Widget input = new Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(40, 20, 40, 30),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: new BoxDecoration(color: Colors.white),
                child: buildTextField(controller, nodeOne),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 15),
                child: MaterialButton(
                    child: Image(
                  image: new AssetImage("image/icon_mic.png"),
                  width: 70,
                )))
          ],
        ),
      ),
    );

    return new Scaffold(
        //方式输入法顶掉背景图片
        resizeToAvoidBottomPadding: false,
        appBar: null,
        body: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Stack(
            alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
              Container(
                //设置背景图片
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage("image/home_bg.png"),
                      fit: BoxFit.fill),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 40.0, top: 40.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "查找",
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        )),
                    Stack(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.95,
                          child: Center(
                            child: Image(
                              image:
                                  new AssetImage("image/find_content_bg.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            warning,
                            input,
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 40),
                                  child: Text("热搜:", style: hotWordStyle),
                                ))
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/find_bottom_bg.png"),
                      width: screen_width,
                    ),
                    onPressed: gotoHome),
              ),
              Positioned(
                bottom: 10.0,
                left: (screen_width-80)/4-32,
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/icon_recommend.png"),
                      width: 80,
                    ),
                    onPressed: gotoHome),
              ),
              Positioned(
                bottom: 10.0,
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/icon_search_select.png"),
                      width: 80,
                    ),
                    onPressed: gotoHome),
              ),
              Positioned(
                bottom: 10.0,
                right: (screen_width-80)/4-32,
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/icon_my_mini.png"),
                      width: 80,
                    ),
                    onPressed: gotoHome),
              )
            ],
          ),
        ));
  }
}
