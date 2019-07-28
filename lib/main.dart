import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zdy_flutter/model/search_result_model.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/search_result.dart';
import 'package:zdy_flutter/find.dart';
import 'guide_info.dart';
import 'util/constant.dart';
import 'util/sp_util.dart';

import 'widget/loadding_dialog.dart';
import 'help.dart';
import 'my.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  //路由
  static final home = MyHomePage();
  static final find = FindPage("");
  static final help = HelpPage();
  static final my = MyPage();
  final routes = {
    '/home': (context) => home,
    '/find': (context) => find,
    '/help': (context) => help,
    '/my': (context) => my,
  };

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SpUtil.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      routes: widget.routes,
      home: getHome(),
    );
  }

  getHome() {
    print("is first?  ${SpUtil.getInt(Constant.KEY_IS_FIRST, defValue: 0)}");
    if (SpUtil.getInt(Constant.KEY_IS_FIRST, defValue: 0) == 1) {
      return MyApp.home;
    } else {
      return PageGuideView();
    }
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> hotWord = ["感冒", "咳嗽", "发烧", "头痛", "嗓子疼"];
  String text = "";
  final hotWordStyle = TextStyle(color: Colors.black, fontSize: 14);

  static const platform = const MethodChannel("test");

  ///测试用
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

  ///跳转查找药页面
  gotoFind() {
    Navigator.of(context).pushNamed('/find');
  }

  ///跳转查找药页面
  gotoHelp() {
    Navigator.of(context).pushNamed('/help');
  }

  ///跳转查找药页面
  gotoMy() {
    Navigator.of(context).pushNamed('/my');
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
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        onSubmitted: (val) {
          submit(val);
        });
  }

  ///输入框焦点
  FocusNode nodeOne;

  ///输入框控制器
  final controller = new TextEditingController();

  Future<void> _showDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('查找药'),
              onPressed: () {
                Navigator.of(context).pop(); //关闭弹窗
                gotoFind();
              },
            ),
            FlatButton(
              child: Text('重新输入'),
              onPressed: () {
                controller.clear();
                Navigator.of(context).pop(); //关闭弹窗
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    nodeOne = FocusNode();
    super.initState();
  }

  void submit(String word) {
    LoadingDialogUtils.showLoading(context, "加载中");
    NetUtil.getJson(Api.GET_RECOMMEND, {"text": word, "page": 1, "rows": 30})
        .then((data) {
      //关闭loading
      Navigator.of(context).pop();
      debugPrint("获取到数据：" + data.toString());
      var sResult = SearchResultModel.fromJson(data);

      if (sResult.resultlist == null ||
          sResult.resultlist.gridModel == null ||
          sResult.resultlist.gridModel.isEmpty ||
          sResult.submitWords == null) {
        _showDialog("您的输入超过推荐药范围，建议您进入查找页面。");
        return;
      }
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ResultStatePage(sResult)));
    });
  }

  @override
  Widget build(BuildContext context) {
    //屏幕分辨率
    MediaQueryData queryData = MediaQuery.of(context);
    //宽
    double screen_width = queryData.size.width;
    //高
    double screen_heigth = queryData.size.height;
    //像素比
    double devicePixelRatio = queryData.devicePixelRatio;
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
        list.add(GestureDetector(
          child: new Padding(
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
              )),
          onTap: () => submit(word),
        ));
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
                bottom: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.95,
                  child: Center(
                    child: Image(
                      image: new AssetImage("image/help_bg.png"),
                      width: screen_width / 1.5,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 30.0,
                right: 160.0,
                child: MaterialButton(
                    child: Image(
                  image: new AssetImage("image/icon_ recommend_select.png"),
                  width: 80,
                )),
              ),
              Positioned(
                bottom: 70.0,
                right: 80.0,
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/icon_search.png"),
                      width: 80,
                    ),
                    onPressed: gotoFind),
              ),
              Positioned(
                bottom: 110.0,
                right: 0,
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/icon_my.png"),
                      width: 80,
                    ),
                    onPressed: gotoMy),
              ),
              Positioned(
                bottom: 25.0,
                right: 5,
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/help.png"),
                      width: 40,
                    ),
                    onPressed: gotoHelp),
              ),
            ],
          ),
        ));
  }
}
