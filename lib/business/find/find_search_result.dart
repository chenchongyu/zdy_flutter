import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zdy_flutter/model/list_item_data.dart';
import 'package:zdy_flutter/model/search_result_model.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/business/medicia/medicial_detail.dart';

import 'package:zdy_flutter/business/find/find_result_filter.dart';
import 'package:zdy_flutter/util/utils.dart';
import 'package:zdy_flutter/widget/my_app_bar.dart';

class FindResultStatePage extends StatefulWidget {
  SearchResultModel result;
  String searchType;

  FindResultStatePage(this.result, this.searchType);

  @override
  State<StatefulWidget> createState() {
    print(result.toJson());
    return FindResultState(result, searchType);
  }
}

class FindResultState extends State<FindResultStatePage>
    implements _ExpansionCheckBoxSelect {
  SearchResultModel searchFindResult;
  String searchType;
  int page = 1;
  List<String> originSubmitWords = [];
  List<ListItemData> dataList = [];
  Map<String, dynamic> filterParams = {};
  List<String> clickList = []; //点击过药品的集合，修改点击过药品title颜色

  FindResultState(this.searchFindResult, this.searchType);

  @override
  void initState() {
    super.initState();
    print("initState");
    dataList.addAll(parseData(searchFindResult));
    print(dataList.length);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: MyAppBar(
        "查找药",
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
                return FindResultFilterView(params: filterParams);
              }));
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
        separatorBuilder: (BuildContext context, int index) {
          return Divider(color: Color.fromRGBO(231, 231, 231, 1.0));
        },
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int position) {
          return getRow(dataList[position]);
        });
  }

  void loadData() {
    print("loadData ${searchFindResult.submitWords}");
    Map<String, dynamic> params = {
      "text": searchFindResult.text,
      "rangeField": searchType,
      "medicinalIsInsurance": "",
      "medicinalManufacturingEnterprise": "",
      "medicinalContraindication": "",
      "page": this.page,
      "rows": 30
    }..addAll(filterParams);

    NetUtil.getJson(Api.GET_SEARCH_RESOULT, params).then((data) {
      debugPrint("获取到数据：" + data.toString());
      var sFindResult = SearchResultModel.fromJson(data);
      var list = parseListData(sFindResult);
      setState(() {
        sFindResult.text = searchFindResult.text;
        this.searchFindResult = sFindResult;
        update(list);
      });
    });
  }

  List<ListItemData> parseData(SearchResultModel sFindResult) {
    List<ListItemData> dataList = [];
    dataList.addAll(parseListData(sFindResult));

    return dataList;
  }

  List<ListItemData> parseListData(SearchResultModel sFindResult) {
    List<ListItemData> dataList = [];
    var size = sFindResult.resultlist?.gridModel?.length;
    dataList.add(
        ListItemData(ListItemData.TYPE_ITEM_TITLE, "共有$size个中成药（非处方）推荐给您："));

    List<GridModel> gridList = sFindResult?.resultlist?.gridModel;
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
      case ListItemData.TYPE_ITEM_TITLE:
        return getListTitleView(data.data);
      case ListItemData.TYPE_ITEM:
        return getListItemView(data.data);
    }
  }

  getListTitleView(String data) {
    return Container(
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
    var styleData = TextStyle(
        color: Color.fromRGBO(149, 149, 149, 1.0),
        fontSize: 14,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none);
    var styleTitle = TextStyle(
        color: Color.fromRGBO(3, 3, 140, 1.0),
        fontWeight: FontWeight.bold,
        fontSize: 14,
        decoration: TextDecoration.none);
    var styleTitleSelected = TextStyle(
        color: Color.fromRGBO(200, 80, 230, 1.0),
        fontWeight: FontWeight.bold,
        fontSize: 14,
        decoration: TextDecoration.none);
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
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
                      color: clickList.contains(data.medicinalId)
                          ? Color.fromRGBO(200, 80, 230, 1.0)
                          : Color.fromRGBO(3, 3, 140, 1.0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
  void onChange(bool selected) {
    loadData();
  }

  ///替换'列表'数据
  List<ListItemData> update(List<ListItemData> list) {
    //3表示真正'列表'数据之前的数据，现在有"已输入信息"、返回首页、CheckBox3块区域
    dataList.removeRange(0, dataList.length);
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
      color: Color.fromRGBO(149, 149, 149, 1.0),
      fontSize: 14,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none);
  var styleTitle = TextStyle(
      color: Color.fromRGBO(3, 3, 140, 1.0),
      fontWeight: FontWeight.bold,
      fontSize: 14,
      decoration: TextDecoration.none);
  var styleTitleSelected = TextStyle(
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
  void onChange(bool selected) {}
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
