import 'package:flutter/material.dart';
import 'package:zdy_flutter/model/product_info.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zdy_flutter/url.dart';
import 'package:zdy_flutter/widget/my_app_bar.dart';

class MyProductPage extends StatefulWidget {
  MyProductPage(this.productInfo);

  ProductInfo productInfo;

  @override
  _MyProductPageState createState() => _MyProductPageState();
}

class _MyProductPageState extends State<MyProductPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //屏幕分辨率
    MediaQueryData queryData = MediaQuery.of(context);
    //宽
    double screen_width = queryData.size.width;

    ///渲染友情链接
    _buildProduct(ProductInfo productInfo) {
      List<Widget> list = [];
      for (int i = 0; i < productInfo.productlist.length; i++) {
        Product product = productInfo.productlist[i];
        List<Widget> lstWidget = [];
        lstWidget.add(new Stack(children: <Widget>[
          MaterialButton(
              child:
                  new Image.network(Api.BaseUrl + "/" + product.descImageUrl),
              onPressed: () {
                ///跳转链接
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        UrlPage(product.descVisitUrl, product.descTitle)));
              })
        ]));
        String downloadLink = "";
        if (product.descTitle == '方剂识别助手') {
          downloadLink =
              'http://zhongerp.com/public/tcm-fangjiapp-download.jsp';
        } else if (product.descTitle == '抗菌中药检索助手') {
          downloadLink =
              'http://sjzx-kshzj-kjzhyjs-1.cintcm.ac.cn:8080/searchTool';
        }
        if (downloadLink != "") {
          lstWidget.add(MaterialButton(
              child: new Text("APP下载"),
              onPressed: () {
                ///跳转链接
                launch(downloadLink);
              }));
        }
        list.add(new Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: new Column(children: lstWidget)));
      }
      return list;
    }

    List<Widget> lstProduct = _buildProduct(widget.productInfo);

    //去友情链接
    return new Scaffold(
        //方式输入法顶掉背景图片
        resizeToAvoidBottomPadding: false,
        appBar: MyAppBar("产品推荐"),
        body: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Stack(
            alignment: Alignment.topLeft, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
              Scrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Center(
                    child: Column(
                      //动态创建一个List<Widget>
                      children: lstProduct,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
