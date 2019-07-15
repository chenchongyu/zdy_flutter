import 'package:flutter/material.dart';
import 'package:zdy_flutter/model/list_item_data.dart';
import 'package:zdy_flutter/model/search_result_model.dart';
import 'package:zdy_flutter/model/user.dart';
import 'package:zdy_flutter/net/netutils.dart';

import 'net/Api.dart';

class SearchResultView extends StatelessWidget {
  SearchResult result;

  SearchResultView(this.result);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("推荐药"),
        actions: <Widget>[Text("筛选")],
        backgroundColor: Colors.purple[400],
      ),
      body: ResultStatePage(result),
    );
  }
}

class ResultStatePage extends StatefulWidget {
  SearchResult result;

  ResultStatePage(this.result);

  @override
  State<StatefulWidget> createState() {
    return ResultState(result);
  }
}

class ResultState extends State<ResultStatePage> {
  SearchResult searchResult;
  int page = 1;

  List<ListItemData> dataList = [];

  ResultState(this.searchResult) {
    dataList.addAll(parseData(searchResult));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: getBody(),
    );
  }

  getBody() {
    if (searchResult == null) {
      return Center(child: CircularProgressIndicator());
    } else {
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
  }

  Widget getKeyWordBoxView(List<String> submitWords, Function fun) {
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
                KeyWordView(submitWords, fun),
              ],
            )),
      ),
    );

    return keywordView;
  }

  void loadData() {
    NetUtil.getJson(Api.GET_RECOMMEND,
        {"text": getKeyWords(), "page": this.page, "rows": 10}).then((data) {
      debugPrint("获取到数据：" + data.toString());
      var sResult = SearchResult.fromJson(data);
      var list = parseData(sResult);
      setState(() {
        this.searchResult = sResult;
        this.dataList = list;
      });
    });
  }

  String getKeyWords() => searchResult.submitWords.join(" ");

  _delWord(String word) {
    if (searchResult.submitWords.contains(word)) {
      searchResult.submitWords.remove(word);
      loadData();
    }
  }

  List<ListItemData> parseData(SearchResult sResult) {
    List<ListItemData> dataList = [];
    dataList.add(ListItemData(ListItemData.TYPE_HEADER, null));
    dataList.add(ListItemData(ListItemData.TYPE_IMAGE, null));
    dataList
        .add(ListItemData(ListItemData.TYPE_CHECKBOX, sResult.recommedWords));
    var size = sResult.resultlist?.gridModel?.length;
    print("共有$size个中成药（非处方）推荐给您");
    dataList.add(
        ListItemData(ListItemData.TYPE_ITEM_TITLE, "共有$size个中成药（非处方）推荐给您："));

    List<GridModel> gridList = sResult?.resultlist?.gridModel;
    print("gridList length ${gridList.length}");
    gridList.forEach((gridModel) {
      dataList.add(ListItemData(ListItemData.TYPE_ITEM, gridModel));
    });

    return dataList;
  }

  getRow(ListItemData data) {
    print("getRow ->${data.data}  ${data.type}");
    switch (data.type) {
      case ListItemData.TYPE_HEADER:
        return getKeyWordBoxView(searchResult.submitWords, _delWord);
      case ListItemData.TYPE_IMAGE:
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Image.asset("image/icon_gohome.png"),
        );
      case ListItemData.TYPE_CHECKBOX:
        return _ExpansionView(data.data, searchResult);
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
    return Column(
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
        RichText(
          overflow: TextOverflow.visible,
          text: TextSpan(
              text: "药厂：",
              children: [
                TextSpan(
                  text: data.medicinalManufacturingEnterprise,
                  style: styleTitle,
                ),
              ],
              style: styleData),
        ),
        RichText(
          overflow: TextOverflow.visible,
          text: TextSpan(
              text: "规格：",
              children: [
                TextSpan(
                  text: data.medicinalSpecification,
                  style: styleTitle,
                ),
              ],
              style: styleData),
        ),
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
    );
  }
}

class _ExpansionView extends StatefulWidget {
  List<String> recommendWords;
  SearchResult searchResult;

  _ExpansionView(this.recommendWords, this.searchResult);

  @override
  State<StatefulWidget> createState() {
    return _ExpansionState();
  }
}

class _ExpansionState extends State<_ExpansionView> {
  bool isExpand;

  _ExpansionState() : isExpand = false;

  bool isSelect(String recommendWord) {
    return widget.searchResult.diseaseWords.contains(recommendWord);
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
      list.add(_CheckboxTextView(word, isSelect(word), onCheckboxSelect));
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
    //todo 设置参数，刷新数据
  }
}

class _CheckboxTextView extends StatefulWidget {
  String text;
  bool selected;
  Function(bool selected, String word) onCheckboxSelect;

  _CheckboxTextView(this.text, this.selected, this.onCheckboxSelect);

  @override
  State<StatefulWidget> createState() => _CheckboxTextState();
}

class _CheckboxTextState extends State<_CheckboxTextView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3 - 2,
      decoration: BoxDecoration(color: Colors.grey[350]),
      padding: EdgeInsets.fromLTRB(3, 1, 5, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Checkbox(
              value: widget.selected,
              onChanged: (bool value) {
                setState(() {
                  widget.selected = value;
                });
                widget.onCheckboxSelect(widget.selected, widget.text);
              }),
          Text(
            widget.text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12,
                color: Colors.black26,
                decoration: TextDecoration.none),
          )
        ],
      ),
    );
  }
}

//关键词view
class KeyWordView extends StatelessWidget {
  final List<String> submitWords;
  Function delWord;

  KeyWordView(this.submitWords, this.delWord);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
        spacing: 5, //主轴上子控件的间距
        runSpacing: 5, //交叉轴上子控件之间的间距
        children: submitWords.map<Widget>((String word) {
          return Chip(
            label: Text(word),
            onDeleted: () => delWord(word),
          );
        }).toList());
  }

  List<Widget> Boxs() {
    List<Widget> list = [];
    for (var word in submitWords) {
      list.add(new GestureDetector(
        onTap: () => delWord(word),
        child: new RichText(
          text: TextSpan(
              text: word,
              style:
                  TextStyle(color: Colors.black, backgroundColor: Colors.white),
              children: [
                TextSpan(text: " X", style: TextStyle(color: Colors.red))
              ]),
        ),
      ));
    }

    return list;
  }
}
