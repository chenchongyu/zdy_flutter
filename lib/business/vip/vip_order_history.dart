import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zdy_flutter/model/vip_history_order.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/util/utils.dart';
import 'package:zdy_flutter/widget/my_app_bar.dart';

class OrderHistoryView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OrderHistoryState();
  }
}

class _OrderHistoryState extends State<OrderHistoryView> {
  List<OrderItem> dataList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar("购买历史"),
      body: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
          child: Container(
              //设置背景图片
              decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("image/buy_history.png"),
                    fit: BoxFit.fill),
              ),
              child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                  child: _buildBody()))),
    );
  }

  _buildBody() {
    return ListView.separated(
        padding: EdgeInsets.all(0),
        separatorBuilder: (BuildContext context, int index) {
          return new Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Utils.hexToColor("#dfdfdf"), width: 2))),
                child: Row(),
              ));
        },
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int position) {
          return getRow(dataList[position]);
        });
  }

  var styleData = TextStyle(
      fontFamily: "style2",
      color: Color.fromRGBO(149, 149, 149, 1.0),
      fontSize: 16,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none);
  var styleTitle = TextStyle(
      fontFamily: "style2",
      color: Color.fromRGBO(3, 3, 140, 1.0),
      fontWeight: FontWeight.bold,
      fontSize: 16,
      decoration: TextDecoration.none);

  getRow(OrderItem data) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                RichText(
                  overflow: TextOverflow.visible,
                  text: TextSpan(
                      text: "购买套餐：",
                      children: [
                        TextSpan(
                          text: "Vip" + data.pkgName,
                          style: styleData,
                        ),
                      ],
                      style: styleTitle),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                RichText(
                  overflow: TextOverflow.visible,
                  text: TextSpan(
                      text: "价格：",
                      children: [
                        TextSpan(
                          text: data.pkgPrice,
                          style: styleData,
                        ),
                      ],
                      style: styleTitle),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                RichText(
                  overflow: TextOverflow.visible,
                  text: TextSpan(
                      text: "购买日期：",
                      children: [
                        TextSpan(
                          text: formatDate(data.createTime),
                          style: styleData,
                        ),
                      ],
                      style: styleTitle),
                ),
              ],
            )
          ],
        ));
  }

  String formatDate(String date) {
    String temp = date;
    if (date != null && date.length >= 14) {
      temp = date.substring(0, 4) +
          "-" +
          date.substring(4, 6) +
          "-" +
          date.substring(6, 8) +
          " " +
          date.substring(8, 10) +
          ":" +
          date.substring(10, 12) +
          ":" +
          date.substring(12, 14);
    }
    return temp;
  }

  void loadData() {
    NetUtil.getJson(Api.GET_ORDER_LIST, {}).then((data) {
      var order = HistoryOrder.fromJson(data);
      setState(() {
        dataList = order.pkgList;
      });
    });
  }
}
