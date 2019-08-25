import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zdy_flutter/model/history_info.dart';
import 'package:zdy_flutter/model/search_result_model.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/business/medicia/search_result.dart';
import 'package:zdy_flutter/business/find/find.dart';
import 'package:zdy_flutter/util/asr_manager.dart';
import 'package:zdy_flutter/util/toast_util.dart';
import 'package:zdy_flutter/widget/checkbox_text_view.dart';
import 'package:zdy_flutter/widget/star_rating_bar.dart';
import 'guide_info.dart';
import 'util/constant.dart';
import 'util/sp_util.dart';

import 'widget/loadding_dialog.dart';
import 'help.dart';
import 'package:zdy_flutter/business/my/my.dart';
import 'package:zdy_flutter/business/my/my_question.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  //路由
  static final home = MyHomePage();
  static final find = FindPage("");
  static final help = HelpPage();
  static final my = MyPage();
  static final question = MyQuestionPage();
  final routes = {
    '/home': (context) => home,
    '/find': (context) => find,
    '/help': (context) => help,
    '/my': (context) => my,
    '/question': (context) => question,
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
    initSP();
    super.initState();
  }

  void initSP() async {
    await SpUtil.getInstance();
    print("init finish.");
    setState(() {});
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
    print("is first?  ${SpUtil.getInt(Constant.KEY_HAS_FIRST, defValue: 0)}");
    if (SpUtil.getInt(Constant.KEY_HAS_FIRST, defValue: 0) == 1) {
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

  bool recording = false;

  void startRecord() {
    if (recording) {
      _speakStop();
    } else {
      AsrManager.start().then((text) {
        print("返回" + text);
        if (text != null && text.length > 0) {
          controller.text = text;
          submit(controller.text);
          setState(() {
            recording = false;
          });
        }
      }).catchError((e) {
        print('识别出错---' + e);
      });
    }

    setState(() {
      recording = !recording;
    });
  }

  _speakStop() {
    AsrManager.stop();
  }

  _speakCancle() {
    AsrManager.cancel();
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

  Future<void> _showErrorDialog(String content) async {
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

    loadHistory();
  }

  Function dismissFunc;

  void _dismiss(Function func) {
    dismissFunc = func;
  }

  void submit(String word) {
    LoadingDialogUtils.showLoading(context, _dismiss);

    NetUtil.getJson(Api.GET_RECOMMEND, {"text": word, "page": 1, "rows": 30})
        .then((data) {
      //关闭loading
      dismissFunc();
      debugPrint("获取到数据：" + data.toString());
      var sResult = SearchResultModel.fromJson(data);

      if (sResult.resultlist == null ||
          sResult.resultlist.gridModel == null ||
          sResult.resultlist.gridModel.isEmpty ||
          sResult.submitWords == null) {
        _showErrorDialog("您的输入超过推荐药范围，建议您进入查找页面。");
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
                    image: recording
                        ? AssetImage("image/icon_mic.gif")
                        : AssetImage("image/icon_mic.png"),
                    width: 70,
                    height: 100,
                  ),
                  onPressed: startRecord),
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

  ///历史推荐评价

  void loadHistory() {
    NetUtil.getJson(Api.GET_EVALUATE_MEDICINAL_HISTORY, {}).then((data) {
      var historyList = HistoryInfo.fromJson(data);
      if (historyList != null && historyList.historyList != null) {
        _showHistoryDialog(historyList);
      }
    });
  }

  Future<void> _showHistoryDialog(HistoryInfo historyInfo) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: _CommentDialogContent(historyInfo),
        );
      },
    );
  }
}

class _CommentDialogContent extends StatefulWidget {
  HistoryInfo historyInfo;

  _CommentDialogContent(this.historyInfo);

  @override
  State<StatefulWidget> createState() {
    return _CommentDialogState();
  }
}

class _CommentDialogState extends State<_CommentDialogContent> {
  List<String> selectMids = []; //评价的药品
  int score; //评价分数
  String content = "非常满意"; //评价内容

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: children(context, widget.historyInfo),
      ),
    );
  }

  List<Widget> children(BuildContext context, HistoryInfo historyInfo) {
    List<Widget> list = [];
    list.add(Text("您选用上一次推荐的中成药了吗？"));
    historyInfo.historyList.forEach((item) {
      list.add(CheckboxTextView.withParams(item.medicinalName, false,
          {"id": item.medicinalId}, onCheckboxSelect));
    });
    list.add(Text("您觉得效果如何？"));
    list.add(RatingBar(
      size: 35,
      value: 3,
      clickable: true,
      onValueChangedCallBack: _onValueChange,
    ));
    list.add(Text(content));
    list.add(MaterialButton(
        color: Colors.blue,
        textColor: Colors.white,
        child: new Text('提交'),
        onPressed: submitComment));
    return list;
  }

  onCheckboxSelect(bool selected, String word, [Map<String, dynamic> params]) {
    if (selected) {
      selectMids.add(params["id"]);
    } else {
      selectMids.remove(params["id"]);
    }
  }

  void _onValueChange(double value) {
    print("当前分数：$value,当前内容：$content");
    score = value.floor();
    switch (score) {
      case 1:
        content = "很不满意";
        break;
      case 2:
        content = "不满意";
        break;
      case 3:
        content = "一般";
        break;
      case 4:
        content = "比较满意";
        break;
      case 5:
        content = "非常满意";
        break;
    }
    print("当前分数：$score,当前内容：$content");
    setState(() {});
  }

  submitComment() {
    if (selectMids.isEmpty) {
      ToastUitl.shortToast("请至少选择1个药品");
      return;
    }
    Map<String, dynamic> params = {
      "medicinalId": selectMids.join(","),
      "evaluateStar": score,
      "evaluateContent": content,
    };
    NetUtil.getJson(Api.ADD_EVALUATE, params).then((data) {
      Navigator.of(context).pop();
    }).catchError((error) {
      ToastUitl.shortToast("网络错误！");
      print("提交评价${error.content}");
    });
  }
}
