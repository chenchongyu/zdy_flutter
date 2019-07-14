import 'package:flutter/material.dart';
import 'package:zdy_flutter/model/list_item_data.dart';
import 'package:zdy_flutter/model/search_result.dart';
import 'package:zdy_flutter/model/user.dart';
import 'package:zdy_flutter/net/netutils.dart';

import 'net/Api.dart';

class SearchResultView extends StatelessWidget {
  String keywords;

  SearchResultView(this.keywords);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("推荐药"),
        actions: <Widget>[Text("筛选")],
        backgroundColor: Colors.purple[400],
      ),
      body: ResultStatePage(keywords),
    );
  }
}

class ResultStatePage extends StatefulWidget {
  String keywords;

  ResultStatePage(this.keywords);

  @override
  State<StatefulWidget> createState() {
    return ResultState();
  }
}

class ResultState extends State<ResultStatePage> {
  SearchResult searchResult;
  int page = 1;
  List<String> submitWords;

  List<ListItemData> dataList = [];

  ResultState();

  @override
  void initState() {
    super.initState();
    loadData();
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
      print("getBody dataList lentth:${dataList[0].data.toString()}");
      return new ListView.builder(
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
        this.submitWords = sResult.submitWords;
        this.searchResult = sResult;
        this.dataList = list;
      });
    });
  }

  String getKeyWords() =>
      searchResult == null ? widget.keywords : submitWords.join(" ");

  _delWord(String word) {
    if (submitWords.contains(word)) {
      submitWords.remove(word);
      loadData();
    }
  }

  List<ListItemData> parseData(SearchResult sResult) {
    List<ListItemData> dataList = [];
    dataList.add(ListItemData(ListItemData.TYPE_HEADER, null));
    dataList.add(ListItemData(ListItemData.TYPE_IMAGE, null));
    dataList
        .add(ListItemData(ListItemData.TYPE_CHECKBOX, sResult.diseaseWords));
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
        return getKeyWordBoxView(submitWords, _delWord);
      case ListItemData.TYPE_IMAGE:
      case ListItemData.TYPE_CHECKBOX:
        //todo 复选框列表
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Image.asset("image/icon_gohome.png"),
        );
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
