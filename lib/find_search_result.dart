import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zdy_flutter/model/list_item_data.dart';
import 'package:zdy_flutter/model/search_result_model.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/medicial_detail.dart';

import 'net/Api.dart';
import 'find_result_filter.dart';

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
      appBar: AppBar(
        title: Text("查找药"),
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
        backgroundColor: Colors.purple[400],
      ),
      body: getBody(),
    );
  }

  getBody() {
    print("getBody dataList lentth:${dataList.length}");
    return new ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.blue,
          );
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
          behavior: HitTestBehavior.opaque,
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
            ],
          ),
        ));
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
