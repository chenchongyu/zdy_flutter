import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zdy_flutter/business/vip/pkg_buy.dart';
import 'package:zdy_flutter/model/vip_package.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/widget/my_app_bar.dart';

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
      appBar: MyAppBar("会员套餐"),
      body: _buildBody(),
    );
  }

  void loadData() {
    NetUtil.getJson(Api.GET_GOODS_LIST, {}).then((data) {
      var vipPackage = VipPackage.fromJson(data);
      setState(() {
        _vipPkgList = vipPackage.pkgList;
        debugPrint("vipPkgList:"+_vipPkgList.toString());
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
          child: Text("Vip会员权益",
              style: TextStyle(
                  fontFamily: "style1",
                  fontWeight: FontWeight.normal,
                  color: Colors.orange,
                  decoration: TextDecoration.underline,
                  fontSize: 18)),
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
            Text(value.pkgName,
                style: TextStyle(
                    fontFamily: "style1",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontSize: 18)),
            Container(
              margin: EdgeInsets.only(left: 40, right: 8),
              child: Text(value.pkgPrice,
                  style: TextStyle(
                      fontFamily: "style1",
                      fontWeight: FontWeight.normal,
                      color: Colors.purple,
                      decoration: TextDecoration.none,
                      fontSize: 18)),
            ),
            GestureDetector(
              child: Image.asset(
                "image/vip_pkg_buy_btn.png",
                fit: BoxFit.contain,
                width: 100,
                height: 50,
              ),
              onTap: () => _buy(value),
            )
          ],
        ),
      ));
    }
    return list;
  }

  _buy(PkgListItem pkg) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => BuyPkgView(pkg)));
  }
}
