import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/find_search_result.dart';
import 'package:zdy_flutter/model/search_result_model.dart';

class FindPage extends StatefulWidget {
  FindPage(this.keywords);

  final String keywords;

  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
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
  final hotWordStyle = TextStyle(color: Colors.black, fontSize: 12);

  static const platform = const MethodChannel("test");

  ///跳转首页面
  gotoHome() {
    Navigator.of(context).pop();
  }

  Widget buildTextField(TextEditingController controller, FocusNode focusNode) {
    return TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
          hintText: "请输入药名",
          contentPadding: const EdgeInsets.all(20.0),
          hintStyle: new TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        maxLines: 4,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        onSubmitted: (val) {
          submit();
        });
  }

  ///输入框焦点
  FocusNode nodeOne;

  ///输入框控制器
  final controller = new TextEditingController();

  ///复选框控制器
  final List<_CheckboxTextState> lstCheckboxTextState =
      new List<_CheckboxTextState>();

  @override
  void initState() {
    nodeOne = FocusNode();
    if (text.length > 0) {
      controller.text = text;
    }
    super.initState();
  }

  void submit() {
    String word = controller.text;
    NetUtil.getJson(Api.GET_SEARCH_RESOULT, {
      "text": word,
      "rangeField": searchType,
      "page": 1,
      "rows": 30
    }).then((data) {
      debugPrint("获取到数据：" + data.toString());
      var sResult = SearchResultModel.fromJson(data);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FindResultStatePage(sResult, searchType)));
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

    ///点击查询类型事件
    onCheckboxSelect(Map<String, dynamic> word, int index, bool selected) {
      print("xieshi3");
      searchType = "";
      if (true == selected) {
        searchType = word["value"];
        print(index);
        for (int i = 0; i < searchTypeWord.length; i++) {
          Map<String, dynamic> temp = searchTypeWord[i];
          _CheckboxTextState checkboxTextState = lstCheckboxTextState[i];
          if (i != index) {
            checkboxTextState.setState(() {
              checkboxTextState.widget.word['selected'] = false;
            });
          }
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
                        MaterialButton(
                            child: Image(
                              image:
                                  new AssetImage("image/icon_find_submit.png"),
                            ),
                            onPressed: submit),
                        MaterialButton(
                            child: Image(
                          image: new AssetImage("image/find_warning_text.png"),
                        ))
                      ],
                    )))));

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
                                fit: BoxFit.fill),
                          ),
                        ),
                        Column(
                          children: <Widget>[search],
                        ),
                        Positioned(
                          bottom: 28,
                          right: 25,
                          child: MaterialButton(
                              child: Image(
                                image:
                                    new AssetImage("image/find_decorate.png"),
                                width: 60,
                              ),
                              onPressed: gotoHome),
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
                left: (screen_width - 80) / 4 - 32,
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
                right: (screen_width - 80) / 4 - 32,
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

///多选框样式
class _CheckboxTextView extends StatefulWidget {
  Map<String, dynamic> word;
  int index;
  Function(Map<String, dynamic>, int index, bool selected) onCheckboxSelect;
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
    print("xieshi1");
    print(widget.lstState.length);
    print(widget.word['selected']);
    return Container(
      width: MediaQuery.of(context).size.width / 3 - 27,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Checkbox(
            value: widget.word['selected'],
            onChanged: (bool value) {
              print("xieshi2");
              setState(() {
                widget.word['selected'] = value;
                widget.onCheckboxSelect(widget.word, widget.index, value);
              });
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
