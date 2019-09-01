import 'package:flutter/material.dart';
import 'package:zdy_flutter/model/list_item_data.dart';
import 'package:zdy_flutter/model/search_result_model.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/business/medicia/medicial_detail.dart';


class MyCollectStatePage extends StatefulWidget {
  MyCollectStatePage();

  @override
  State<StatefulWidget> createState() {
    return MyCollectState();
  }
}

class MyCollectState extends State<MyCollectStatePage> {
  Resultlist result;
  String searchType;
  int page = 1;
  List<String> originSubmitWords = [];
  List<ListItemData> dataList = [];
  Map<String, dynamic> filterParams = {};

  MyCollectState();

  @override
  void initState() {
    super.initState();
    loadData();
    print("initState");
    print(dataList.length);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          "我的收藏",
          style: new TextStyle(
              fontFamily: "style1",
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        leading: MaterialButton(
            child: Image(
              image: new AssetImage("image/leading.png"),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        flexibleSpace: Image.asset('image/app_bar_bg.png',
            fit: BoxFit.cover, width: double.infinity, height: double.infinity),
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
    NetUtil.getJson(Api.GET_COLLECT_LIST, {}).then((data) {
      debugPrint("获取到数据：" + data.toString());
      Resultlist resultlist = Resultlist.fromJson(data["collectlist"]);
      setState(() {
        dataList = [];
        this.result = resultlist;
        dataList.addAll(parseData(result));
      });
    });
  }

  List<ListItemData> parseData(Resultlist collectList) {
    List<ListItemData> dataList = [];
    dataList.addAll(parseListData(collectList));

    return dataList;
  }

  List<ListItemData> parseListData(Resultlist collectList) {
    List<ListItemData> dataList = [];

    List<GridModel> gridList = collectList.gridModel;
    print("gridList length ${gridList.length}");
    gridList.forEach((gridModel) {
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

  ///收藏
  ///取消收藏
  void uncollect(medicinalId) {
    NetUtil.getJson(Api.CANCEL_COLLECT, {"medicinalId": medicinalId})
        .then((data) {
      debugPrint("获取到数据：" + data.toString());
      loadData();
    });
  }

  getListItemView(GridModel data) {
    var styleData = TextStyle(
        color: Colors.black, fontSize: 14, decoration: TextDecoration.none);
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MedicialDetailView(data.medicinalId, data.medicinalName);
            }));
            loadData();
          },
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        data.medicinalName,
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 16,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                          child: Text(
                            "删除",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          onPressed: () => uncollect(data.medicinalId)),
                    ),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
                RichText(
                  overflow: TextOverflow.visible,
                  text:
                      TextSpan(text: data.medicinalFunction, style: styleData),
                ),
              ]),
        ));
  }
}
