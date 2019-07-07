import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zdy_flutter/model/user.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/search_result.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> hotWord = ["感冒", "咳嗽", "发烧", "头痛", "嗓子疼"];
  final hotWordStyle = TextStyle(color: Colors.black, fontSize: 14);

  static const platform = const MethodChannel("test");

  /**
   * 测试用
   */
  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      print("dart -_getBatteryLevel"); //      在通道上调用此方法
      final int result = await platform.invokeMethod("getBatteryLevel");
      print(result); //      在通道上调用此方法
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
    setState(() {
      print("dart -setState");
    });
  }

  Widget buildTextField(TextEditingController controller, FocusNode focusNode) {
    return TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
            hintText: "请输入您有什么不舒服（1-3个词语即可，中间不需要用间隔号分开，如伤风头疼）",
            contentPadding: const EdgeInsets.all(20.0),
            hintStyle: new TextStyle(color: Colors.black),
            border: OutlineInputBorder(
                borderSide:
                    new BorderSide(color: Colors.lightBlue, width: 15.0))),
        maxLines: 4,
        textInputAction: TextInputAction.search,
        onEditingComplete: () {
          print("点击了键盘上的动作按钮");
        },
        onSubmitted: (val) {
          print("onSubmitted--》" + val);
        });
  }

  @override
  Widget build(BuildContext context) {
    FocusNode nodeOne = FocusNode();
    final controller = TextEditingController();
    //输入框添加监听 方便用于查询
    controller.addListener(() {
      if (controller.text.indexOf("\n") == controller.text.length - 1) {
        FocusScope.of(context).requestFocus(FocusNode());
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
        //todo 触发查询
        print("输入的数据："+controller.text);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SearchResultView(controller.text)
        ));
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
                  ),
                  onPressed: _getBatteryLevel),
            )
          ],
        ),
      ),
    );

    _buildHotWord(List<String> dataList) {
      List<Widget> list = [];
      for (String word in dataList) {
        list.add(new Padding(
            padding: EdgeInsets.only(right: 3),
            child: Container(
              child: Text(
                word,
                style: hotWordStyle,
              ),
              decoration: new BoxDecoration(
                color: Colors.grey,
                borderRadius: new BorderRadius.all(
                  const Radius.circular(6.0),
                ),
              ),
            )));
      }
      return list;
    }

    _buildHotWordRow(List<String> dataList) {
      var rowCount = 4;
      var start = 0;
      var rowLine =
          (hotWord.length - 4) > 0 ? ((hotWord.length - 4) / 3).toInt() + 2 : 1;
      //多少行

      List<Widget> list = [];

      for (var i = 0; i < rowLine; i++) {
        list.add(new Padding(
            padding: EdgeInsets.only(top: 3),
            child: new Row(
                children:
                    _buildHotWord(hotWord.sublist(start, start + rowCount)))));
        var left = hotWord.length - rowCount * (i + 1);
        start += rowCount;
        rowCount = left > 3 ? 3 : left;
      }

      return list;
    }

    Widget _hotWordBox() {
      return new Padding(
          padding: EdgeInsets.only(left: 40),
          child: new Column(
            children: _buildHotWordRow(hotWord),
          ));
    }

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
                            "推荐",
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
                              image: new AssetImage("image/content_bg.png"),
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
                                )),
                            _hotWordBox()
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 10.0,
                right: 160.0,
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/icon_ recommend_select.png"),
                      width: 80,
                    ),
                    onPressed: _getBatteryLevel),
              ),
              Positioned(
                bottom: 50.0,
                right: 80.0,
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/icon_search.png"),
                      width: 80,
                    ),
                    onPressed: _getBatteryLevel),
              ),
              Positioned(
                bottom: 90.0,
                right: 0,
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/icon_my.png"),
                      width: 80,
                    ),
                    onPressed: _getBatteryLevel),
              )
            ],
          ),
        ));
  }
}
