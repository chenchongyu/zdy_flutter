import 'package:flutter/material.dart';
import 'package:zdy_flutter/model/vip_history_order.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
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
      body: _buildBody(),
    );
  }

  _buildBody() {
    return ListView.separated(
        padding: EdgeInsets.all(0),
        separatorBuilder: (BuildContext context, int index) {
          return index > 3
              ? Divider(color: Color.fromRGBO(231, 231, 231, 1.0))
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

  getRow(OrderItem data) {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[Text(data.pkgName), Text(data.createTime)],
        ),
        Text(data.pkgPrice)
      ],
    );
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
