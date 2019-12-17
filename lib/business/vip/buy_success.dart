import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zdy_flutter/model/vip_package.dart';
import 'package:zdy_flutter/widget/my_app_bar.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';

class BuySuccessView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BuySuccessState();
  }
}

class _BuySuccessState extends State<BuySuccessView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar("支付成功"),
      body: Column(children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(40, 100, 40, 0),
            child: Center(
                child: Image.asset(
              "image/pay_text.png",
              fit: BoxFit.contain,
              width: 250,
              height: 250,
            ))),
        Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Center(
                child: MaterialButton(
                    child: Image.asset(
                      "image/pay_button.png",
                      fit: BoxFit.contain,
                      width: 250,
                      height: 250,
                    ),
                    onPressed: _backVip)))
      ]),
    );
  }

  void _backVip() {
    Navigator.of(context).pushNamedAndRemoveUntil('/vip', ModalRoute.withName('/my'));
  }
}
