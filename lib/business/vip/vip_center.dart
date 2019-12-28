import 'package:flutter/material.dart';
import 'package:zdy_flutter/business/vip/vip_package.dart';
import 'package:zdy_flutter/model/vip_package.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/widget/image_text.dart';
import 'package:zdy_flutter/widget/my_app_bar.dart';
import 'package:zdy_flutter/net/netutils.dart';

class VipCenter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VipCenterState();
}

//todo 请求接口数据
class _VipCenterState extends State<VipCenter> {
  static const TextStyle headTextStyle =
      TextStyle(color: Colors.purple, fontSize: 18);
  String sMonthNum = "--";
  String sLastDate = "--";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    NetUtil.getJson(Api.GET_USER_INFO, {}).then((data) {
      setState(() {
        if (data['result'] == "success") {
          sMonthNum = data["month_num"];
          sLastDate = data["expire_time"];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //屏幕分辨率
    MediaQueryData queryData = MediaQuery.of(context);
    //宽
    double screen_width = queryData.size.width;
    double screen_height = queryData.size.height;

    return Scaffold(
      appBar: MyAppBar("会员中心",centerTitle: true,),
      body: Container(
        width: screen_width,
        height: screen_height,
        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("image/vip_head_bg.png"),
                        fit: BoxFit.fill)),
                child: Row(
                  children: <Widget>[
                    Text(
                      "已购套餐：",
                      style: headTextStyle,
                    ),
                    Text(
                      sMonthNum,
                      style: headTextStyle,
                    ),
                    Text("  "),
                    Text(
                      "剩余天数：",
                      style: headTextStyle,
                    ),
                    Text(
                      sLastDate,
                      style: headTextStyle,
                    ),
                  ],
                ),
              ),
              top: 70,
              left: 80,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Image.asset(
                "image/vip_avatar.png",
                width: 90,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              child: Container(
                width: screen_width - 10,
                padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                margin: EdgeInsets.fromLTRB(5, 35, 5, 0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("image/vip_center_bg.png"),
                        fit: BoxFit.fill)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ImageText("购买套餐", "image/vip_pkg.png", () => _jumpTo(1)),
                    ImageText(
                        "购买历史", "image/vip_buy_history.png", () => _jumpTo(2)),
                    ImageText("会员权益", "image/vip_rights.png", () => _jumpTo(3)),
                  ],
                ),
              ),
              top: 120,
              left: 0,
            )
          ],
        ),
      ),
    );
  }

  _jumpTo(int i) {
    switch (i) {
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => VipPackageView()));
        break;
    }
  }
}
