import 'package:flutter/material.dart';
import 'package:zdy_flutter/business/vip/vip_order_history.dart';
import 'package:zdy_flutter/business/vip/vip_package.dart';
import 'package:zdy_flutter/model/vip_package.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/widget/image_text.dart';
import 'package:zdy_flutter/widget/my_app_bar.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/util/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  String sMobile = "--";

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
          if(null!=data["mobile"]){
            sMobile = data["mobile"];
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 760, allowFontScaling: false);
    //屏幕分辨率
    MediaQueryData queryData = MediaQuery.of(context);
    //宽
    double screen_width = queryData.size.width;
    double screen_height = queryData.size.height;

    return Scaffold(
      appBar: MyAppBar(
        "会员中心",
        centerTitle: true,
      ),
      body: Container(
        width: screen_width,
        height: screen_height,
        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "用户：",
                      style: headTextStyle,
                    ),
                    Text(
                      sMobile,
                      style: headTextStyle,
                    ),
                  ],
                ),
              ),
              top: ScreenUtil().setWidth(35),
              left: ScreenUtil().setWidth(80),
            ),
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
              top: ScreenUtil().setWidth(70),
              left: ScreenUtil().setWidth(80),
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
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => OrderHistoryView()));

        break;
      case 3:
        _showDialog(
            "用户通过手机号注册会员后，可免费使用本软件一周，即可不限次使用推荐和查找药功能。一周使用期结束后，每天只可以使用一次本软件的推荐药等所有功能。如超过使用次数，则需充值才能继续使用所有功能。");
        break;
    }
  }

  Future<void> _showDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(Constant.DIALOG_PADDING),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Constant.DIALOG_CORNER_RADIUS))),
          content: SingleChildScrollView(
              padding: EdgeInsets.all(1),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple, width: 2),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Constant.DIALOG_CORNER_RADIUS)),
                        ),
                        child: Column(
                          children: <Widget>[
                            Text("提示"),
                            Text(""),
                            Text(
                              content,
                              textAlign: TextAlign.center,
                            ),
                            Text(""),
                            Text(""),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.topCenter,
                                    child: Row()),
                                Container(
                                  alignment: Alignment.topCenter,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color.fromRGBO(
                                                  203, 106, 247, 1.0),
                                              width: 2))),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: GestureDetector(
                                          child: Text('关闭',
                                              textAlign: TextAlign.center),
                                          onTap: () {
                                            Navigator.of(context).pop(); //关闭弹窗
                                          },
                                        ),
                                        width: ScreenUtil().setWidth(80),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                  Positioned(
                    child: Image.asset(
                      "image/dialog_img.png",
                      fit: BoxFit.contain,
                      width: 80,
                      height: 80,
                    ),
                    right: 1,
                    top: -20,
                  ),
                ],
              )),
        );
      },
    );
  }
}
