import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zdy_flutter/business/medicia/medicial_detail.dart';
import 'package:zdy_flutter/model/list_item_data.dart';
import 'package:zdy_flutter/model/search_result_model.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/util/utils.dart';
import 'package:zdy_flutter/widget/checkbox_text_view.dart';

import 'package:zdy_flutter/business/medicia/result_filter.dart';
import 'package:zdy_flutter/widget/my_app_bar.dart';

class ResultStatePage extends StatefulWidget {
  SearchResultModel result;

  ResultStatePage(this.result);

  @override
  State<StatefulWidget> createState() {
    return ResultState(result);
  }
}

class ResultState extends State<ResultStatePage>
    implements _ExpansionCheckBoxSelect {
  SearchResultModel searchResult;
  int page = 1;
  List<String> originSubmitWords = []; //原始 submitWord，展示关键词
  List<String> originSymptomWords = []; //原始SymptomWord，用于参数提交
  List<ListItemData> dataList = [];
  Map<String, dynamic> filterParams = {};
  List<String> clickList = []; //点击过药品的集合，修改点击过药品title颜色

  ResultState(this.searchResult);

  @override
  void initState() {
    super.initState();
    print("initState");
    originSubmitWords.addAll(searchResult.submitWords);
    originSymptomWords.addAll(searchResult.submitWords);
    dataList.addAll(parseData(searchResult));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: MyAppBar(
        "推荐药",
        actions: <Widget>[
          Center(
              child: GestureDetector(
            child: Text(
              "筛选  ",
              style: new TextStyle(
                  fontFamily: "style2", fontSize: 24, color: Colors.white),
            ),
            onTap: () async {
              filterParams = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return ResultFilterView(
                  searchResult.diseaseWords,
                  params: filterParams,
                );
              }));
              filterParams = filterParams == null ? Map() : filterParams;
              if (filterParams.isNotEmpty) {
                print("得到参数：$filterParams");
                loadData();
              }
            },
          ))
        ],
      ),
      body: getBody(),
    );
  }

  getBody() {
    print("getBody dataList lentth:${dataList.length}");
    return new ListView.separated(
        padding: EdgeInsets.all(0),
        separatorBuilder: (BuildContext context, int index) {
          return index > 3
              ? new Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Container(
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Utils.hexToColor("#dfdfdf"), width: 2))),
                    child: Row(),
                  ))
              : Divider(
                  color: Colors.white,
                  height: 0,
                );
        },
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int position) {
          return getRow(dataList[position]);
        });
  }

  Widget getKeyWordBoxView(List<String> keyWords, Function fun) {
    var keywordView = new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
            image: new AssetImage("image/keyword_bg.png"), fit: BoxFit.fill),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Container(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
//                Text(
//                  "已输入信息",
//                  style: TextStyle(
//                      fontFamily: "style1",
//                      fontWeight: FontWeight.normal,
//                      color: Colors.black,
//                      decoration: TextDecoration.none,
//                      fontSize: 16),
//                ),
                KeyWordView(keyWords, fun),
              ],
            )),
      ),
    );

    return keywordView;
  }

  void loadData() {
    print("loadData ${searchResult.submitWords}");
    if (searchResult.text == null || searchResult.text == "") {
      Navigator.of(context).pop();
      return;
    }
    Map<String, dynamic> params = {
      "text": searchResult.text,
      "symptomWords": originSymptomWords.join("~~"),
      "page": this.page,
      "rows": 30
    }..addAll(filterParams);

    NetUtil.getJson(Api.GET_RECOMMEND_FILTER, params).then((data) {
      debugPrint("获取到数据：" + data.toString());
      var sResult = SearchResultModel.fromJson(data);
      var list = parseListData(sResult);
      setState(() {
        //保留疾病数据
        sResult.diseaseWords = searchResult.diseaseWords;
        this.searchResult = sResult;
        update(list);
      });
    });
  }

  _delWord(String word) {
    if (searchResult.text.contains(word)) {
      searchResult.text = searchResult.text.replaceAll(word, "").trim();
      originSubmitWords.remove(word);
      originSymptomWords.remove(word);
      loadData();
    }
  }

  List<ListItemData> parseData(SearchResultModel sResult) {
    List<ListItemData> dataList = [];
    dataList.add(ListItemData(ListItemData.TYPE_HEADER, null));
    dataList.add(ListItemData(ListItemData.TYPE_IMAGE, null));
    dataList
        .add(ListItemData(ListItemData.TYPE_CHECKBOX, sResult.recommedWords));

    dataList.addAll(parseListData(sResult));

    return dataList;
  }

  List<ListItemData> parseListData(SearchResultModel sResult) {
    List<ListItemData> dataList = [];
    var size = sResult.resultlist?.records;
    dataList.add(
        ListItemData(ListItemData.TYPE_ITEM_TITLE, "共有-$size-个中成药（非处方）推荐给您："));

    List<GridModel> gridList = sResult?.resultlist?.gridModel;
    print("gridList length ${gridList.length}");
    gridList.forEach((gridModel) {
      gridModel.medicinalManufacturingEnterprise2 =
          getTopThree(gridModel.medicinalManufacturingEnterprise);
      gridModel.medicinalSpecification2 =
          getTopThree(gridModel.medicinalSpecification);
      dataList.add(ListItemData(ListItemData.TYPE_ITEM, gridModel));
    });

    return dataList;
  }

  getRow(ListItemData data) {
    switch (data.type) {
      case ListItemData.TYPE_HEADER:
        return getKeyWordBoxView(originSubmitWords, _delWord);
      case ListItemData.TYPE_IMAGE:
        return new Container(
          alignment: Alignment.topLeft,
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage("image/search_result_comment.png"),
                fit: BoxFit.fill),
          ),
          height: 45,
        );
      case ListItemData.TYPE_CHECKBOX:
        return new Container(
            alignment: Alignment.topLeft,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                  color: Color.fromRGBO(202, 234, 245, 1.0), width: 3.0),
            ),
            child: _ExpansionView(data.data, searchResult, this));
      case ListItemData.TYPE_ITEM_TITLE:
        return getListTitleView(data.data);
      case ListItemData.TYPE_ITEM:
        return getListItemView(data.data);
    }
  }

  getListTitleView(String data) {
    var textStyle = TextStyle(
        color: Colors.black, fontSize: 14, decoration: TextDecoration.none);
    var textRed = TextStyle(
        color: Colors.red, fontSize: 14, decoration: TextDecoration.none);
    var array = data.split("-");
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: new DecorationImage(
            image: new AssetImage("image/result_title_img.png"),
            fit: BoxFit.fitWidth),
      ),
      alignment: Alignment.center,
      child: RichText(
          text: TextSpan(text: array[0], style: textStyle, children: [
        TextSpan(text: array[1], style: textRed),
        TextSpan(text: array[2], style: textStyle),
      ])),
    );
  }

  getListItemView(GridModel data) {
    var styleData = TextStyle(
        fontFamily: "style1",
        color: Color.fromRGBO(149, 149, 149, 1.0),
        fontSize: 14,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none);
    var styleTitle = TextStyle(
        fontFamily: "style1",
        color: Color.fromRGBO(3, 3, 140, 1.0),
        fontWeight: FontWeight.bold,
        fontSize: 14,
        decoration: TextDecoration.none);
    var styleTitleSelected = TextStyle(
        fontFamily: "style1",
        color: Color.fromRGBO(200, 80, 230, 1.0),
        fontWeight: FontWeight.bold,
        fontSize: 14,
        decoration: TextDecoration.none);

    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => gotoDetail(data),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    data.medicinalName,
                    style: TextStyle(
                      fontFamily: "style1",
                      fontWeight: FontWeight.bold,
                      color: clickList.contains(data.medicinalId)
                          ? Color.fromRGBO(200, 80, 230, 1.0)
                          : Color.fromRGBO(3, 3, 140, 1.0),
                      fontSize: 18,
//                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  data.medicinalIsInsurance == "医保"
                      ? Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                image: new DecorationImage(
                                    image: new AssetImage("image/yby.png"),
                                    fit: BoxFit.fill),
                              ),
                              child: Text("医保药",
                                  style: TextStyle(
                                      fontFamily: "style1",
                                      decoration: TextDecoration.none,
                                      fontSize: 10))))
                      : Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                image: new DecorationImage(
                                    image: new AssetImage("image/fyb.png"),
                                    fit: BoxFit.fill),
                              ),
                              child: Text("非医保",
                                  style: TextStyle(
                                      fontFamily: "style1",
                                      decoration: TextDecoration.none,
                                      fontSize: 10))))
                ],
              ),
              _ExpansionItemView(
                  "药厂：",
                  data.medicinalManufacturingEnterprise2,
                  data.medicinalManufacturingEnterprise,
                  clickList.contains(data.medicinalId)),
              _ExpansionItemView(
                  "规格：",
                  data.medicinalSpecification2,
                  data.medicinalSpecification,
                  clickList.contains(data.medicinalId)),
              RichText(
                overflow: TextOverflow.visible,
                text: TextSpan(
                    text: "用药禁忌：",
                    children: [
                      TextSpan(
                        text: data.medicinalContraindication,
                        style: styleData,
                      ),
                    ],
                    style: clickList.contains(data.medicinalId)
                        ? styleTitleSelected
                        : styleTitle),
              ),
              Text(
                "推荐系数：${data.medicinalRecommedKpi}",
                style: TextStyle(
                    fontFamily: "style1",
                    color: Utils.hexToColor("#f89a17"),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              ),
            ],
          ),
        ));
  }

  Future gotoDetail(GridModel data) {
    clickList.add(data.medicinalId);
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MedicialDetailView(data.medicinalId, data.medicinalName);
    }));
  }

  @override
  void onChange(bool selected, String word) {
    selected ? originSymptomWords.add(word) : originSymptomWords.remove(word);
    loadData();
  }

  ///替换'列表'数据
  List<ListItemData> update(List<ListItemData> list) {
    ///3表示真正'列表'数据之前的数据，现在有"已输入信息"、返回首页、CheckBox3块区域
    dataList.removeRange(3, dataList.length);
//    print("删除后列表 ${dataList}");
    dataList.addAll(list);
  }

  String getTopThree(String s) {
    var ss = s.split(";");
    if (ss.length <= 3)
      return s;
    else
      return ss.sublist(0, 3).join(";") + "...";
  }
}

class _ExpansionItemView extends StatefulWidget {
  String title;
  String text1;
  String text2;
  var bTitleSelected;

  _ExpansionItemView(this.title, this.text1, this.text2, this.bTitleSelected);

  @override
  State<StatefulWidget> createState() {
    return _ExpansionItemState();
  }
}

class _ExpansionItemState extends State<_ExpansionItemView> {
  var styleData = TextStyle(
      //969696
      fontFamily: "style1",
      color: Color.fromRGBO(150, 150, 150, 1.0),
      fontSize: 14,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none);
  var styleTitle = TextStyle(
      //03038c
      fontFamily: "style1",
      color: Color.fromRGBO(3, 3, 140, 1.0),
      fontWeight: FontWeight.bold,
      fontSize: 14,
      decoration: TextDecoration.none);
  var styleTitleSelected = TextStyle(
      //c850e6
      fontFamily: "style1",
      color: Color.fromRGBO(200, 80, 230, 1.0),
      fontWeight: FontWeight.bold,
      fontSize: 14,
      decoration: TextDecoration.none);

  bool expand = false;

  _ExpansionItemState() : expand = false;

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.visible,
      text: TextSpan(
        text: widget.title,
        style: widget.bTitleSelected ? styleTitleSelected : styleTitle,
        children: [
          TextSpan(
              text: expand ? widget.text2 : widget.text1,
              style: styleData,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    expand = !expand;
                  });
                }),
        ],
      ),
    );
  }
}

class _ExpansionCheckBoxSelect {
  void onChange(bool selected, String word) {}
}

class _ExpansionView extends StatefulWidget {
  List<String> recommendWords;
  SearchResultModel searchResult;

  _ExpansionCheckBoxSelect fun;

  _ExpansionView(this.recommendWords, this.searchResult, this.fun);

  @override
  State<StatefulWidget> createState() {
    return _ExpansionState();
  }
}

class _ExpansionState extends State<_ExpansionView> {
  bool isExpand;

  _ExpansionState() : isExpand = false;

  bool isSelect(String recommendWord) {
    return widget.searchResult.submitWords.contains(recommendWord);
  }

  @override
  Widget build(BuildContext context) {
    print("_ExpansionState ${widget.recommendWords.length}");
    return Column(
      children: _buildExpansionView(widget.recommendWords),
    );
  }

  ///生成查询类型列列表
  _buildSearchTypeWord(List<String> dataList) {
    List<Widget> list = [];
    for (String word in dataList) {
      list.add(CheckboxTextView(word, isSelect(word), onCheckboxSelect,
          dataFontSize: 14));
    }
    return list;
  }

  ///生成查询类型行列表
  _buildExpansionView(List<String> dataList) {
    int rowCount = 3;
    var start = 0;
    int rowLine = (dataList.length / rowCount).toInt();
    rowLine = dataList.length % rowCount == 0 ? rowLine : rowLine++;
    rowLine = rowLine == 0 ? 1 : rowLine;
    rowLine = isExpand ? rowLine : 1;

    List<Widget> list = [];
    if (dataList.length > 0) {
      for (var i = 0; i < rowLine; i++) {
        start = i * rowCount;
        list.add(new Padding(
            padding: EdgeInsets.only(top: 3),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _buildSearchTypeWord(
                    dataList.sublist(start, start + rowCount)))));
      }
      list.add(GestureDetector(
          child: Icon(
              isExpand ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
          onTap: () => setState(() {
                isExpand = !isExpand;
              })));
    }

    return list;
  }

  onCheckboxSelect(bool selected, String word, [Map params]) {
    print("onCheckboxSelect $selected   $word");
//    SearchResultModel searchResult = widget.searchResult;
//    if (selected) {
//      searchResult.submitWords.add(word);
//    } else {
//      searchResult.submitWords.remove(word);
//    }

    widget.fun.onChange(selected, word);
  }
}

//关键词view
class KeyWordView extends StatelessWidget {
  final List<String> keyWords;
  Function delWord;

  KeyWordView(this.keyWords, this.delWord);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
        spacing: 5, //主轴上子控件的间距
        runSpacing: 5, //交叉轴上子控件之间的间距
        children: keyWords.map<Widget>((String word) {
          return Chip(
            label: Text(
              word,
              style: TextStyle(
                  fontFamily: "style1",
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 14),
            ),
            onDeleted: () => delWord(word),
          );
        }).toList());
  }
}
