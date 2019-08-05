import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zdy_flutter/medicial_detail.dart';
import 'package:zdy_flutter/model/list_item_data.dart';
import 'package:zdy_flutter/model/search_result_model.dart';
import 'package:zdy_flutter/net/netutils.dart';

import 'net/Api.dart';
import 'result_filter.dart';
import 'widget/checkbox_text_view.dart';

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
  List<String> originSubmitWords = [];
  List<String> originSymptomWords = [];
  List<ListItemData> dataList = [];
  Map<String, dynamic> filterParams = {};

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
      appBar: AppBar(
        title: Text("推荐药"),
        actions: <Widget>[
          Center(
              child: GestureDetector(
            child: Text(
              "筛选  ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  fontSize: 20),
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
        backgroundColor: Colors.purple[400],
      ),
      body: getBody(),
    );
  }

  getBody() {
    print("getBody dataList lentth:${dataList.length}");
    return new ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return index > 3
              ? Divider(
                  color: Colors.blue,
                )
              : Divider(
                  color: Colors.white,
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
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Container(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "已输入信息",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontSize: 18),
                ),
                KeyWordView(keyWords, fun),
              ],
            )),
      ),
    );

    return keywordView;
  }

  void loadData() {
    print("loadData ${searchResult.submitWords}");
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
      searchResult.submitWords.remove(word);
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
    var size = sResult.resultlist?.gridModel?.length;
    dataList.add(
        ListItemData(ListItemData.TYPE_ITEM_TITLE, "共有$size个中成药（非处方）推荐给您："));

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
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Image.asset("image/icon_gohome.png"),
        );
      case ListItemData.TYPE_CHECKBOX:
        return _ExpansionView(data.data, searchResult, this);
      case ListItemData.TYPE_ITEM_TITLE:
        return getListTitleView(data.data);
      case ListItemData.TYPE_ITEM:
        return getListItemView(data.data);
    }
  }

  getListTitleView(String data) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: new DecorationImage(
            image: new AssetImage("image/result_title_img.png"),
            fit: BoxFit.fitWidth),
      ),
      alignment: Alignment.center,
      child: Text(
        data,
        style: TextStyle(
            color: Colors.black, fontSize: 12, decoration: TextDecoration.none),
      ),
    );
  }

  getListItemView(GridModel data) {
    var styleTitle = TextStyle(
        color: Colors.black45,
        fontSize: 14,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none);
    var styleData = TextStyle(
        color: Colors.lightBlue, fontSize: 14, decoration: TextDecoration.none);
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: GestureDetector(
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MedicialDetailView(data.medicinalId, data.medicinalName);
          })),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    data.medicinalName,
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 16,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    data.medicinalIsInsurance,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: data.medicinalIsInsurance == "医保"
                            ? Colors.green
                            : Colors.pinkAccent,
                        fontSize: 12),
                  )
                ],
              ),
              _ExpansionItemView("药厂：", data.medicinalManufacturingEnterprise2,
                  data.medicinalManufacturingEnterprise),
              _ExpansionItemView("规格：", data.medicinalSpecification2,
                  data.medicinalSpecification),
              RichText(
                overflow: TextOverflow.visible,
                text: TextSpan(
                    text: "用药禁忌：",
                    children: [
                      TextSpan(
                        text: data.medicinalContraindication,
                        style: styleTitle,
                      ),
                    ],
                    style: styleData),
              ),
              Text(
                "推荐系数：${data.medicinalRecommedKpi}",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                    decoration: TextDecoration.none),
              ),
            ],
          ),
        ));
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

  _ExpansionItemView(this.title, this.text1, this.text2);

  @override
  State<StatefulWidget> createState() {
    return _ExpansionItemState();
  }
}

class _ExpansionItemState extends State<_ExpansionItemView> {
  var styleData = TextStyle(
      color: Colors.black45,
      fontSize: 14,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none);
  var styleTitle = TextStyle(
      color: Colors.lightBlue, fontSize: 14, decoration: TextDecoration.none);

  bool expand = false;

  _ExpansionItemState() : expand = false;

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.visible,
      text: TextSpan(
        text: widget.title,
        style: styleTitle,
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
      list.add(CheckboxTextView(word, isSelect(word), onCheckboxSelect));
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

    return list;
  }

  onCheckboxSelect(bool selected, String word) {
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
            label: Text(word),
            onDeleted: () => delWord(word),
          );
        }).toList());
  }
}
