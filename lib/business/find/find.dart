import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/business/find/find_search_result.dart';
import 'package:zdy_flutter/model/search_result_model.dart';
import 'package:zdy_flutter/util/utils.dart';
import 'package:zdy_flutter/util/sp_util.dart';
import 'package:zdy_flutter/util/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FindPage extends StatefulWidget {
  FindPage(this.keywords);

  final String keywords;

  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  List<String> hotWord = [];
  List<Map<String, dynamic>> searchTypeWord = [
    {"text": "药品名称", "value": "1", "selected": false},
    {"text": "功能主治", "value": "3", "selected": false},
    {"text": "药品成分", "value": "6", "selected": false},
    {"text": "企业名称", "value": "7", "selected": false},
    {"text": "药品分类", "value": "8", "selected": false},
    {"text": "综合检索", "value": "9", "selected": false},
  ];

  ///查询内容
  String text = "";

  ///查询类型
  String searchType = "";
  ///提示语
  String hintText= "请您勾选相应条件进行检索";
  final hotWordStyle = TextStyle(color: Colors.black, fontSize: 12);

  static const platform = const MethodChannel("test");

  ///跳转首页面
  gotoHome() {
    Navigator.of(context).pop();
  }

  ///跳转查找药页面
  gotoMy() {
    Navigator.of(context).pushReplacementNamed('/my');
  }

  ///跳转vip页面
  gotoVip() {
    Navigator.of(context).pushNamed('/vip');
  }
  ///更改提示语
  getHintText() {
    String text = "请您勾选相应条件进行检索";
    print(searchType);
    switch (searchType) {
      case "1":
        text = "请输入您想查找的药品名称，如清咽片";
        break;
      case "3":
        text = "请输入您想查找的功能主治，如清咽、咽痒、慢性咽炎";
        break;
      case "6":
        text = "请输入您想查找的药品成分，如麦冬、板蓝根";
        break;
      case "7":
        text = "请输入您想查找的企业名称，如同仁堂";
        break;
      case "8":
        text = "请输入您想查找的药品分类，如解表、安神、清热";
        break;
      case "9":
        text = "";
        break;
    }
    setState(() {
      hintText = text;
    });
  }

  Widget buildTextField(TextEditingController controller, FocusNode focusNode) {
    return TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.all(20.0),
          hintStyle: new TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        maxLines: 4,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        onSubmitted: (val) {
          submit(controller.text, "");
        });
  }

  ///输入框焦点
  FocusNode nodeOne;

  ///输入框控制器
  final controller = new TextEditingController();

  ///复选框控制器
  final List<_CheckboxTextState> lstCheckboxTextState =
      new List<_CheckboxTextState>();

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
    ///初始化查询历史
    List<String> lstSearchWord =
        SpUtil.getStringList(Constant.KEY_FIND_SEARCH_LIST);
    if (null == lstSearchWord) {
      lstSearchWord = new List<String>();
      SpUtil.putObjectList(Constant.KEY_FIND_SEARCH_LIST, lstSearchWord);
    }
    SpUtil.putStringList(Constant.KEY_FIND_SEARCH_LIST, lstSearchWord);
    nodeOne = FocusNode();
    if (text.length > 0) {
      controller.text = text;
    }
    hotWord = lstSearchWord;
    super.initState();
  }

  ///同步历史
  void syncHistoty(String word) {
    List<String> lstSearchWord =
        SpUtil.getStringList(Constant.KEY_FIND_SEARCH_LIST);
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
    SpUtil.putStringList(Constant.KEY_FIND_SEARCH_LIST, lstSearchWord);
    setState(() {
      hotWord = lstSearchWord;
    });
  }

  //清理历史
  void clearHistory() {
    SpUtil.putStringList(Constant.KEY_FIND_SEARCH_LIST, []);
    setState(() {
      hotWord = [];
    });
  }

  void submit(String word, String skip) {
    syncHistoty(word);
    NetUtil.getJson(Api.GET_SEARCH_RESOULT, {
      "text": word,
      "skip": skip,
      "rangeField": searchType,
      "page": 1,
      "rows": 30
    }).then((data) {
      debugPrint("获取到数据：" + data.toString());
      if (data['errorCode'] == "2") {
        _showSerachDialog("您今天只有一次查询机会，是否继续？", word);
        return;
      } else if (data['errorCode'] == "1") {
        _showVipDialog("您今天只查询机会已用完，是否充值？");
        return;
      }
      var sResult = SearchResultModel.fromJson(data);
      sResult.text = word;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FindResultStatePage(sResult, searchType)));
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 760, allowFontScaling: false);
    //屏幕分辨率
    MediaQueryData queryData = MediaQuery.of(context);
    //宽
    double screen_width = queryData.size.width;
    //高
    double screen_heigth = queryData.size.height;
    //像素比
    double devicePixelRatio = queryData.devicePixelRatio;

    ///点击查询类型事件
    onCheckboxSelect(Map<String, dynamic> word, int index) {
      if (searchType != word["value"]) {
        searchType = word["value"];
      } else {
        searchType = "";
      }
      getHintText();
      for (int i = 0; i < searchTypeWord.length; i++) {
        Map<String, dynamic> temp = searchTypeWord[i];
        _CheckboxTextState checkboxTextState = lstCheckboxTextState[i];
        if (temp["value"] == searchType) {
          checkboxTextState.setState(() {
            checkboxTextState.widget.word['selected'] = true;
          });
        } else {
          checkboxTextState.setState(() {
            checkboxTextState.widget.word['selected'] = false;
          });
        }
      }
    }

    ///生成查询类型列列表
    _buildSearchTypeWord(List<Map<String, dynamic>> dataList, int start) {
      List<Widget> list = [];
      for (int i = 0; i < dataList.length; i++) {
        Map<String, dynamic> word = dataList[i];
        list.add(_CheckboxTextView(
            word, start + i, onCheckboxSelect, lstCheckboxTextState));
      }
      return list;
    }

    ///生成查询类型行列表
    _buildSearchTypeWordRow(List<Map<String, dynamic>> dataList) {
      int rowCount = 3;
      var start = 0;
      int rowLine = (searchTypeWord.length / rowCount).toInt();
      rowLine = searchTypeWord.length % rowCount == 0 ? rowLine : rowLine++;
      rowLine = rowLine == 0 ? 1 : rowLine;

      List<Widget> list = [];

      for (var i = 0; i < rowLine; i++) {
        start = i * rowCount;
        list.add(new Padding(
            padding: EdgeInsets.only(top: 3),
            child: new Row(
                children: _buildSearchTypeWord(
                    dataList.sublist(start, start + rowCount), start))));
      }

      return list;
    }

    ///查询类型列表
    Widget _SearchTypeWordBox() {
      return new Padding(
          padding: EdgeInsets.only(left: 0),
          child: new Column(
            children: _buildSearchTypeWordRow(searchTypeWord),
          ));
    }

    Widget search = new Center(
        child: Padding(
            padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
            child: Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage("image/find_edit_bg.png"),
                      fit: BoxFit.fill),
                ),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      children: <Widget>[
                        Container(
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                  image: new AssetImage(
                                      "image/find_edit_text_bg.png"),
                                  fit: BoxFit.fill),
                            ),
                            child: buildTextField(controller, nodeOne)),
                        _SearchTypeWordBox(),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: MaterialButton(
                                child: Image(
                                  image: new AssetImage(
                                      "image/icon_find_submit.png"),
                                ),
                                onPressed: () => submit(controller.text, ""))),
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: MaterialButton(
                                child: Image(
                              image:
                                  new AssetImage("image/find_warning_text.png"),
                            )))
                      ],
                    )))));

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
                            "查找",
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
                                image:
                                    new AssetImage("image/find_content_bg.png"),
                                fit: BoxFit.fill),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            search,
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: MaterialButton(
                                      child: Image(
                                          image: AssetImage(
                                              "image/find_history.png"),
                                          width: 140,
                                          height: 16,
                                          fit: BoxFit.fill),
                                      onPressed: clearHistory),
                                )),
                            _hotWordBox(),
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
                  width: ScreenUtil().setWidth(360),
                )),
              ),
              Positioned(
                bottom: 0,
                left: ScreenUtil().setWidth((360 - 100) / 4 - 45),
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/icon_recommend.png"),
                      width: ScreenUtil().setWidth(100),
                    ),
                    onPressed: gotoHome),
              ),
              Positioned(
                bottom: 0,
                child: MaterialButton(
                    child: Image(
                  image: new AssetImage("image/icon_search_select.png"),
                  width: ScreenUtil().setWidth(100),
                )),
              ),
              Positioned(
                bottom: 0,
                right: ScreenUtil().setWidth((360 - 100) / 4 - 45),
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/icon_my_mini.png"),
                      width: ScreenUtil().setWidth(100),
                    ),
                    onPressed: gotoMy),
              )
            ],
          ),
        ));
  }
}

///多选框样式
class _CheckboxTextView extends StatefulWidget {
  Map<String, dynamic> word;
  int index;
  Function(Map<String, dynamic>, int index) onCheckboxSelect;
  List<_CheckboxTextState> lstState;

  _CheckboxTextView(
      this.word, this.index, this.onCheckboxSelect, this.lstState);

  @override
  State<StatefulWidget> createState() {
    _CheckboxTextState temp = _CheckboxTextState();
    lstState.add(temp);
    return temp;
  }
}

class _CheckboxTextState extends State<_CheckboxTextView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3 - 27,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: Image.asset(
              widget.word['selected']
                  ? "image/icon_checkbox_selected_blue"
                      ".png"
                  : "image/icon_checkbox_default.png",
              width: 26,
              fit: BoxFit.fitWidth,
            ),
            onTap: () => widget.onCheckboxSelect(widget.word, widget.index),
          ),
          Text(
            widget.word["text"],
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black, fontSize: 12),
          )
        ],
      ),
    );
  }
}
