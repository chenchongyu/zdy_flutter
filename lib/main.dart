import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zdy_flutter/model/history_info.dart';
import 'package:zdy_flutter/model/search_result_model.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/business/medicia/search_result.dart';
import 'package:zdy_flutter/business/find/find.dart';
import 'package:zdy_flutter/service_protocol.dart';
import 'package:zdy_flutter/util/asr_manager.dart';
import 'package:zdy_flutter/util/toast_util.dart';
import 'package:zdy_flutter/util/utils.dart';
import 'package:zdy_flutter/widget/checkbox_text_view.dart';
import 'package:zdy_flutter/widget/star_rating_bar.dart';
import 'business/vip/buy_success.dart';
import 'business/vip/vip_center.dart';
import 'guide_info.dart';
import 'util/constant.dart';
import 'util/sp_util.dart';

import 'widget/loadding_dialog.dart';
import 'help.dart';
import 'package:zdy_flutter/business/my/my.dart';
import 'package:zdy_flutter/business/my/my_question.dart';
import 'package:zdy_flutter/business/signIn/signIn.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  //路由
  static final home = MyHomePage();
  static final find = FindPage("");
  static final help = HelpPage();
  static final my = MyPage();
  static final question = MyQuestionPage();
  static final buySuccess = BuySuccessView();
  static final vip = VipCenter();
  final routes = {
    '/home': (context) => home,
    '/find': (context) => find,
    '/help': (context) => help,
    '/my': (context) => my,
    '/question': (context) => question,
    '/buySuccess': (context) => buySuccess,
    '/vip': (context) => vip,
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
    ///初始化查询历史
    List<String> lstSearchWord =
        SpUtil.getStringList(Constant.KEY_MAIN_SEARCH_LIST);
    if (null == lstSearchWord) {
      lstSearchWord = new List<String>();
      SpUtil.putObjectList(Constant.KEY_MAIN_SEARCH_LIST, lstSearchWord);
    }
    SpUtil.putStringList(Constant.KEY_MAIN_SEARCH_LIST, lstSearchWord);
    print(
        "KEY_HAS_PROTOCOL?  ${SpUtil.getInt(Constant.KEY_HAS_PROTOCOL, defValue: 0)}");
    print(
        "KEY_HAS_FIRST?  ${SpUtil.getInt(Constant.KEY_HAS_FIRST, defValue: 0)}");
    print(
        "KEY_IS_SIGN_IN?  ${SpUtil.getInt(Constant.KEY_IS_SIGN_IN, defValue: 0)}");
//    if (SpUtil.getInt(Constant.KEY_HAS_PROTOCOL, defValue: 0) == 0) {
//      return ServiceProtocol();
//    } else
//    if (SpUtil.getInt(Constant.KEY_HAS_FIRST, defValue: 0) == 0) {
//      return PageGuideView();
//    }
     if (SpUtil.getInt(Constant.KEY_IS_SIGN_IN, defValue: 0) == 0) {
      ///是否没有登录
      return SignInPage();
    }
//    else {
//    }
    return MyApp.home;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ///是否为热搜
  var bHotWord = true;
  List<String> hotWord = [];
  String text = "";
  final hotWordTitleStyle = TextStyle(
      color: Colors.black,
      fontFamily: "style1",
      fontSize: 14,
      fontWeight: FontWeight.bold);
  final hotWordStyle =
      TextStyle(color: Colors.black, fontFamily: "style1", fontSize: 14);

  bool recording = false;

  void startRecord() {
    if (recording) {
      _speakStop();
    } else {
      AsrManager.start().then((text) {
        print("返回" + text);
        if (text != null && text.length > 0) {
          controller.text = text;
          submit(controller.text, "");
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

  ///切换历史查询
  void switchHistory() {
    setState(() {
      bHotWord = false;
      List<String> lstSearchWord =
          SpUtil.getStringList(Constant.KEY_MAIN_SEARCH_LIST);
      hotWord = lstSearchWord;
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

  ///跳转vip页面
  gotoVip() {
    Navigator.of(context).pushNamed('/vip');
  }

  Widget buildTextField(TextEditingController controller, FocusNode focusNode) {
    return TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
            hintText: "请输入您有什么不舒服（1-3个词语即可，中间不需要用间隔号分开，如伤风头疼）",
            contentPadding: const EdgeInsets.all(20.0),
            hintStyle: new TextStyle(color: Colors.black),
            border: InputBorder.none),
        maxLines: 4,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        onSubmitted: (val) {
          submit(val, "");
        });
  }

  ///输入框焦点
  FocusNode nodeOne;

  ///输入框控制器
  final controller = new TextEditingController();

  Future<void> _showErrorDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(Constant.DIALOG_PADDING),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Constant.DIALOG_CORNER_RADIUS))),
          content: SingleChildScrollView(
              padding: EdgeInsets.all(1),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple, width: 2),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Constant.DIALOG_CORNER_RADIUS)),
                        ),
                        child: Column(
                          children: <Widget>[
                            Text("提示"),
                            Text(""),
                            Text(
                              content,
                              textAlign: TextAlign.center,
                            ),
                            Text(""),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                  child: Text(
                                    '查找药',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop(); //关闭弹窗
                                    gotoFind();
                                  },
                                ),
                                GestureDetector(
                                  child: Text(
                                    '重新输入',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                  onTap: () {
                                    controller.clear();
                                    Navigator.of(context).pop(); //关闭弹窗
                                  },
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                  Positioned(
                    child: Image.asset(
                      "image/dialog_img.png",
                      fit: BoxFit.contain,
                      width: 80,
                      height: 80,
                    ),
                    right: 1,
                    top: -20,
                  ),
                ],
              )),
        );
      },
    );
  }

  Future<void> _showSerachDialog(String content, String word) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(Constant.DIALOG_PADDING),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Constant.DIALOG_CORNER_RADIUS))),
          content: SingleChildScrollView(
              padding: EdgeInsets.all(1),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple, width: 2),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Constant.DIALOG_CORNER_RADIUS)),
                        ),
                        child: Column(
                          children: <Widget>[
                            Text("提示"),
                            Text(""),
                            Text(
                              content,
                              textAlign: TextAlign.center,
                            ),
                            Text(""),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                  child: Text(
                                    '继续',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop(); //关闭弹窗
                                    submit(word, "1");
                                  },
                                ),
                                GestureDetector(
                                  child: Text(
                                    '取消',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop(); //关闭弹窗
                                  },
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                  Positioned(
                    child: Image.asset(
                      "image/dialog_img.png",
                      fit: BoxFit.contain,
                      width: 80,
                      height: 80,
                    ),
                    right: 1,
                    top: -20,
                  ),
                ],
              )),
        );
      },
    );
  }

  Future<void> _showVipDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(Constant.DIALOG_PADDING),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Constant.DIALOG_CORNER_RADIUS))),
          content: SingleChildScrollView(
              padding: EdgeInsets.all(1),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple, width: 2),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Constant.DIALOG_CORNER_RADIUS)),
                        ),
                        child: Column(
                          children: <Widget>[
                            Text("提示"),
                            Text(""),
                            Text(
                              content,
                              textAlign: TextAlign.center,
                            ),
                            Text(""),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                  child: Text(
                                    '去充值',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop(); //关闭弹窗
                                    gotoVip();
                                  },
                                ),
                                GestureDetector(
                                  child: Text(
                                    '取消',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop(); //关闭弹窗
                                  },
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                  Positioned(
                    child: Image.asset(
                      "image/dialog_img.png",
                      fit: BoxFit.contain,
                      width: 80,
                      height: 80,
                    ),
                    right: 1,
                    top: -20,
                  ),
                ],
              )),
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

  ///同步历史
  void syncHistoty(String word) {
    List<String> lstSearchWord =
        SpUtil.getStringList(Constant.KEY_MAIN_SEARCH_LIST);
    lstSearchWord.insert(0, word);
    for (int i = 1; i < lstSearchWord.length; i++) {
      String temp = lstSearchWord[i];
      if (word == temp) {
        lstSearchWord.removeAt(i);
        break;
      }
    }
    if (lstSearchWord.length > 10) {
      lstSearchWord.removeRange(10, lstSearchWord.length);
    }
    SpUtil.putStringList(Constant.KEY_MAIN_SEARCH_LIST, lstSearchWord);
    if (!bHotWord) {
      switchHistory();
    }
  }

  void submit(String word, String skip) {
    syncHistoty(word);
    LoadingDialogUtils.showLoading(context, _dismiss);

    NetUtil.getJson(Api.GET_RECOMMEND,
        {"text": word, "skip": skip, "page": 1, "rows": 30}).then((data) {
      //关闭loading
      dismissFunc();
      debugPrint("获取到数据：" + data.toString());
      var sResult = SearchResultModel.fromJson(data);
      if (data['errorCode'] == "2") {
        _showSerachDialog("您今天只有一次查询机会，是否继续？", word);
        return;
      } else if (data['errorCode'] == "1") {
        _showVipDialog("您今天只查询机会已用完，是否充值？");
        return;
      }
      if (sResult.resultlist == null ||
          sResult.resultlist.gridModel == null ||
          sResult.resultlist.gridModel.isEmpty ||
          sResult.submitWords == null) {
        _showErrorDialog("您的输入超过推荐药范围，建议您进入查找页面。");
        return;
      }
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ResultStatePage(sResult)));
    }).catchError((e) {
      //关闭loading
      dismissFunc();
      ToastUitl.shortToast("网络错误~");
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
            padding: EdgeInsets.fromLTRB(40, 40, 40, 0),
            child: Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage("image/warning_bg.png"),
                      fit: BoxFit.contain),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
                ))));

    Widget input = new Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(40, 20, 40, 30),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 3, color: Utils.hexToColor("#c6f5fb")),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: buildTextField(controller, nodeOne)),
            ),
            MaterialButton(
                child: Image(
                  image: recording
                      ? AssetImage("image/icon_mic.gif")
                      : AssetImage("image/icon_mic.png"),
                  width: 70,
                  height: 100,
                ),
                onPressed: startRecord),
          ],
        ),
      ),
    );

    _buildHotWord(List<String> dataList) {
      List<Widget> list = [];
      for (String word in dataList) {
        list.add(GestureDetector(
          child: new Padding(
              padding: EdgeInsets.only(right: 10),
              child: Container(
                child: new Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Text(
                      word,
                      style: hotWordStyle,
                    )),
                decoration: new BoxDecoration(
                  color: Utils.hexToColor("#d2d2d2"),
                  borderRadius: new BorderRadius.all(
                    const Radius.circular(6.0),
                  ),
                ),
              )),
          onTap: () => submit(word, ""),
        ));
      }
      return list;
    }

    _buildHotWordRow(List<String> dataList) {
      var rowCount = 4;
      var start = 0;
      var rowLine = (hotWord.length - 4) > 0
          ? (hotWord.length / 4).toInt() + (hotWord.length % 4 > 0 ? 1 : 0)
          : 1;
      //多少行

      List<Widget> list = [];
      if (hotWord.length > 0) {
        for (var i = 0; i < rowLine; i++) {
          if (rowLine == (i + 1)) {
            rowCount = hotWord.length % 4;
          }
          list.add(new Padding(
              padding: EdgeInsets.only(top: 3),
              child: new Row(
                  children: _buildHotWord(
                      hotWord.sublist(start, start + rowCount)))));
          start += rowCount;
        }
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
                                fontFamily: "style3",
                                fontSize: 24,
                                color: Colors.white),
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
                                  child: Text(bHotWord ? "热搜:" : "历史检索：",
                                      style: hotWordTitleStyle),
                                )),
                            _hotWordBox(),
                          ],
                        ),
                        Positioned(
                            left: 10,
                            bottom: 35,
                            child: MaterialButton(
                                child: Image(
                                  image: AssetImage("image/history.png"),
                                  width: 70,
                                  height: 70,
                                ),
                                onPressed: switchHistory)),
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
                bottom: 10.0,
                right: 160.0,
                child: MaterialButton(
                    child: Image(
                  image: new AssetImage("image/icon_ recommend_select.png"),
                  width: 100,
                )),
              ),
              Positioned(
                bottom: 60.0,
                right: 80.0,
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/icon_search.png"),
                      width: 100,
                    ),
                    onPressed: gotoFind),
              ),
              Positioned(
                bottom: 100.0,
                right: 0,
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/icon_my.png"),
                      width: 100,
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
      if (historyList != null &&
          historyList.historyList != null &&
          historyList.historyList.length > 0) {
        _showHistoryDialog(historyList);
      }
    });
    NetUtil.getJson(Api.GET_HOT_WORD, {}).then((data) {
      List<String> hotWordTemp = [];
      if (data != null &&
          data['hotWordList'] != null &&
          data['hotWordList'].length > 0) {
        for (var word in data['hotWordList']) {
          hotWordTemp.add(word);
        }
      }
      setState(() {
        hotWord = hotWordTemp;
      });
    });
  }

  Future<void> _showHistoryDialog(HistoryInfo historyInfo) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(Constant.DIALOG_PADDING),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Constant.DIALOG_CORNER_RADIUS))),
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
  double score = 0; //评价分数
  String content = "非常满意"; //评价内容

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(15, 25, 15, 50),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple, width: 2),
            borderRadius: BorderRadius.all(
                Radius.circular(Constant.DIALOG_CORNER_RADIUS)),
          ),
          child: ListBody(
            children: children(context, widget.historyInfo),
          ),
        ),
        Positioned(
          child: Image.asset(
            "image/dialog_img.png",
            fit: BoxFit.cover,
            width: 50,
            height: 50,
          ),
          right: 0,
          top: -2,
        )
      ],
    ));
  }

  List<Widget> children(BuildContext context, HistoryInfo historyInfo) {
    List<Widget> list = [];
    list.add(Text("您选用上一次推荐\n的中成药了吗？"));
    historyInfo.historyList.forEach((item) {
      list.add(Padding(
        padding: EdgeInsets.all(5),
        child: CheckboxTextView.withParams(
            item.medicinalName,
            selectMids.contains(item.medicinalId),
            {"id": item.medicinalId},
            onCheckboxSelect),
      ));
    });
    list.add(Text("您觉得效果如何？"));
    list.add(RatingBar(
      size: 35,
      value: score,
      clickable: true,
      onValueChangedCallBack: _onValueChange,
    ));
//    list.add(Text(content));
    list.add(Text("")); //空行
    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GestureDetector(
          child: Text(
            "关闭",
            style:
                TextStyle(fontSize: 15, decoration: TextDecoration.underline),
          ),
          onTap: () => Navigator.of(context).pop(),
        ),
        GestureDetector(
          child: Text(
            "提交",
            style:
                TextStyle(fontSize: 15, decoration: TextDecoration.underline),
          ),
          onTap: submitComment,
        )
      ],
    ));

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
    score = value;
    switch (score.floor()) {
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
