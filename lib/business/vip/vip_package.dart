import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zdy_flutter/business/vip/pkg_buy.dart';
import 'package:zdy_flutter/model/vip_package.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/util/utils.dart';
import 'package:zdy_flutter/widget/my_app_bar.dart';
import 'package:zdy_flutter/util/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VipPackageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VipPackageViewState();
  }
}

class _VipPackageViewState extends State<VipPackageView> {
  List<PkgListItem> _vipPkgList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        "购买套餐",
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  void loadData() {
    NetUtil.getJson(Api.GET_GOODS_LIST, {}).then((data) {
      var vipPackage = VipPackage.fromJson(data);
      setState(() {
        _vipPkgList = vipPackage.pkgList;
        debugPrint("vipPkgList:" + _vipPkgList.toString());
      });
    });
  }

  _buildBody() {
    if (_vipPkgList == null || _vipPkgList.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return _buildContent();
    }
  }

  _buildContent() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("image/vip_pkg_content_bg.png"),
                  fit: BoxFit.fill)),
          child: Column(
            children: _getItems(),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.purple, width: 1.2)),
          child: GestureDetector(
            child: Image.asset(
              "image/vip_o.png",
              width: 130,
            ),
            onTap: () => _showDialog("Vip会员期间可无限次使用本软件的推荐及查找药等所有功能，没有限制。"),
          ),
        ),
      ],
    );
  }

  _getItems() {
    List<Widget> list = [];
    for (var value in _vipPkgList) {
      list.add(Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("image/vip_pkg_item_bg.png"), fit: BoxFit.fill),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
              "image/vip_b.png",
              width: 35,
            ),
            RichText(
              overflow: TextOverflow.visible,
              text: TextSpan(
                  text: "",
                  children: [
                    TextSpan(
                      text: value.pkgName,
                      style: TextStyle(
                          fontFamily: "style1",
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontSize: 18),
                    ),
                  ],
                  style: TextStyle(
                      color: Color.fromRGBO(253, 147, 7, 1.0),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      decoration: TextDecoration.underline)),
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 8),
              child: Text("￥" + value.pkgPrice.toString(),
                  style: TextStyle(
                      fontFamily: "style1",
                      fontWeight: FontWeight.normal,
                      color: Utils.hexToColor("#6d12cd"),
                      decoration: TextDecoration.none,
                      fontSize: 18)),
            ),
            GestureDetector(
              child: Image.asset(
                "image/vip_pkg_buy_btn.png",
                fit: BoxFit.contain,
                width: ScreenUtil().setWidth(70),
                height: ScreenUtil().setWidth(40),
              ),
              onTap: () => _buy(value),
            )
          ],
        ),
      ));
    }
    return list;
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
                            Text(
                              "提示",
                              style: TextStyle(
                                fontFamily: "style1",
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(""),
                            Text(
                              "　　" + content,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "style1",
                                decoration: TextDecoration.none,
                              ),
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

  _buy(PkgListItem pkg) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => BuyPkgView(pkg)));
  }
}
