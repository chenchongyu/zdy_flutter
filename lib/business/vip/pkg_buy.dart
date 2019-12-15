import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zdy_flutter/model/vip_package.dart';
import 'package:zdy_flutter/widget/my_app_bar.dart';

class BuyPkgView extends StatefulWidget {
  PkgListItem _item;

  BuyPkgView(this._item);

  @override
  State<StatefulWidget> createState() {
    return _BuyPkgState(_item);
  }
}

class _BuyPkgState extends State<BuyPkgView> {
  PkgListItem pkgItem;
  var payType;
  String orderId;
  static const payChannel = const MethodChannel("pay");

  _BuyPkgState(this.pkgItem);

  TextStyle style1 = TextStyle(
    color: Colors.purple,
    fontSize: 20,
    fontFamily: "style1",
  );

  @override
  void initState() {
    // TODO: loadData()
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar("订单支付"),
        body: _buildBody(),
        bottomNavigationBar: BottomAppBar(
          child: Container(
              height: 40,
              margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
              decoration: BoxDecoration(
                color: Colors.orange[600],
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: GestureDetector(
                child: Text(
                  "确认支付  ￥${pkgItem.pkgPrice}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      fontFamily: "style1"),
                ),
                onTap: () => _statPay(pkgItem.pkgPrice),
              )),
        ));
  }

  _buildBody() {
    return Column(
      children: <Widget>[
        _getOrderInfoView(),
        Text(
          "请选择支付方式",
          style: style1,
        ),
        Image.asset(
          "image/line.png",
          fit: BoxFit.fitWidth,
        ),
        _getPayType(1),
        _getPayType(2),
      ],
    );
  }

  _getOrderInfoView() {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color.fromARGB(100, 248, 226, 250),
      ),
      child: Column(
        children: <Widget>[
          _itemView("订单名称", pkgItem.pkgName),
          _itemView("订单金额", pkgItem.pkgPrice),
          Container(
            margin: EdgeInsets.only(top: 20.0),
          ),
          _itemView("待支付金额", pkgItem.pkgPrice),
        ],
      ),
    );
  }

  _itemView(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: style1,
          ),
          Text(value)
        ],
      ),
    );
  }

  _getPayType(int i) {
    String src = i == 1 ? "image/pay_ali.png" : "image/pay_wx.png";
    return Padding(
      padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            src,
            fit: BoxFit.contain,
            width: 50,
          ),
          Radio(
              value: i,
              groupValue: payType,
              onChanged: (data) {
                setState(() {
                  payType = data;
                });
              }),
        ],
      ),
    );
  }

  /**
   * 测试用
   */
  Future<Null> _statPay(String price) async {
    String batteryLevel;
    try {
      print("dart -_statPay" + price); //      在通道上调用此方法
      final int result =
          await payChannel.invokeMethod("start_pay", <String, dynamic>{
        'price': price,
        'order_id': orderId,
      });
      print(result); //      在通道上调用此方法
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to start_pay: '${e.message}'.";
    }
    setState(() {
      print("dart -setState");
    });
  }
}
