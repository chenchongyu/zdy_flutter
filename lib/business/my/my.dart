import 'package:flutter/material.dart';
import 'package:zdy_flutter/business/vip/vip_center.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/model/product_info.dart';
import 'package:zdy_flutter/model/link_info.dart';
import 'package:zdy_flutter/model/search_result_model.dart';
import 'my_collect.dart';
import 'my_link.dart';
import 'my_product.dart';
import 'my_us.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyPage extends StatefulWidget {
  MyPage();

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  ///跳转首页面
  gotoHome() {
    Navigator.of(context).pop();
  }

  ///跳转查找药页面
  gotoFind() {
    Navigator.of(context).pushReplacementNamed('/find');
  }

  ///跳转会员中心
  gotoVipCenter() {
    Navigator.of(context).pushNamed("/vip");
  }

  ///跳转我的收藏
  gotoMyCollect() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MyCollectStatePage()));
  }

  ///跳转友情链接
  gotoMyLink() {
    NetUtil.getJson(Api.GET_FRIEND_LINK_LIST, {}).then((data) {
      debugPrint("获取到数据：" + data.toString());
      LinkInfo sResult = LinkInfo.fromJson(data);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MyLinkPage(sResult)));
    });
  }

  ///跳转产品推荐
  gotoMyProduct() {
    NetUtil.getJson(Api.GET_PRODUCT_LIST, {}).then((data) {
      debugPrint("获取到数据：" + data.toString());
      ProductInfo sResult = ProductInfo.fromJson(data);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MyProductPage(sResult)));
    });
  }

  ///跳转关于我们
  gotoMyUs() {
    NetUtil.getJson(Api.GET_ABOUT_US, {}).then((data) {
      debugPrint("获取到数据：" + data.toString());
      Product sResult = Product.fromJson(data['aboutus']);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MyUsPage(sResult)));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 760, allowFontScaling: false);
    //屏幕分辨率
    MediaQueryData queryData = MediaQuery.of(context);
    //宽
    double screen_width = queryData.size.width;
    //高
    double screen_heigth = queryData.size.height;
    //像素比
    double devicePixelRatio = queryData.devicePixelRatio;

    Widget body = new Center(
        child: Padding(
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(40),
                ScreenUtil().setWidth(40), ScreenUtil().setWidth(40), 0),
            child: Column(children: <Widget>[
              Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage("image/my_body_bg.png"),
                        fit: BoxFit.fill),
                  ),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), ScreenUtil().setHeight(10), ScreenUtil().setWidth(10), ScreenUtil().setHeight(10)),
                      child: Column(
                        children: <Widget>[
                          Container(
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    image: new AssetImage(
                                        "image/my_detail_bg.png"),
                                    fit: BoxFit.fill),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), 0, 0, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                "image/my_vip.png"),
                                            width: ScreenUtil().setHeight(40),
                                          ),
                                          MaterialButton(
                                              child: Text(
                                                "会员中心",
                                                textAlign: TextAlign.left,
                                                style: new TextStyle(
                                                    fontFamily: "style1",
                                                    fontSize: ScreenUtil().setSp(20),
                                                    color: Colors.black),
                                              ),
                                              onPressed: gotoVipCenter)
                                        ],
                                      )
                                    ],
                                  ))),
                          Container(
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    image: new AssetImage(
                                        "image/my_detail_bg.png"),
                                    fit: BoxFit.fill),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), 0, 0, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                "image/my_collection.png"),
                                            width: ScreenUtil().setHeight(40),
                                          ),
                                          MaterialButton(
                                              child: Text(
                                                "我的收藏",
                                                textAlign: TextAlign.left,
                                                style: new TextStyle(
                                                    fontFamily: "style1",
                                                    fontSize: ScreenUtil().setSp(20),
                                                    color: Colors.black),
                                              ),
                                              onPressed: gotoMyCollect)
                                        ],
                                      )
                                    ],
                                  ))),
                          Container(
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    image: new AssetImage(
                                        "image/my_detail_bg.png"),
                                    fit: BoxFit.fill),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), 0, 0, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                "image/my_link.png"),
                                            width: ScreenUtil().setHeight(40),
                                          ),
                                          MaterialButton(
                                              child: Text(
                                                "友情链接",
                                                textAlign: TextAlign.left,
                                                style: new TextStyle(
                                                    fontFamily: "style1",
                                                    fontSize: ScreenUtil().setSp(20),
                                                    color: Colors.black),
                                              ),
                                              onPressed: gotoMyLink)
                                        ],
                                      )
                                    ],
                                  ))),
                          Container(
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    image: new AssetImage(
                                        "image/my_detail_bg.png"),
                                    fit: BoxFit.fill),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), 0, 0, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                "image/my_product.png"),
                                            width: ScreenUtil().setHeight(40),
                                          ),
                                          MaterialButton(
                                              child: Text(
                                                "产品推荐",
                                                textAlign: TextAlign.left,
                                                style: new TextStyle(
                                                    fontFamily: "style1",
                                                    fontSize: ScreenUtil().setSp(20),
                                                    color: Colors.black),
                                              ),
                                              onPressed: gotoMyProduct)
                                        ],
                                      )
                                    ],
                                  ))),
                          Container(
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    image: new AssetImage(
                                        "image/my_detail_bg.png"),
                                    fit: BoxFit.fill),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), 0, 0, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                "image/my_question.png"),
                                            width: ScreenUtil().setHeight(40),
                                          ),
                                          MaterialButton(
                                              child: Text(
                                                "问题反馈",
                                                textAlign: TextAlign.left,
                                                style: new TextStyle(
                                                    fontFamily: "style1",
                                                    fontSize: ScreenUtil().setSp(20),
                                                    color: Colors.black),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushNamed('/question');
                                              })
                                        ],
                                      )
                                    ],
                                  ))),
                          Container(
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    image: new AssetImage(
                                        "image/my_detail_bg.png"),
                                    fit: BoxFit.fill),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), 0, 0, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                "image/help.png"),
                                            width: ScreenUtil().setHeight(40),
                                          ),
                                          MaterialButton(
                                              child: Text(
                                                "使用帮助",
                                                textAlign: TextAlign.left,
                                                style: new TextStyle(
                                                    fontFamily: "style1",
                                                    fontSize: ScreenUtil().setSp(20),
                                                    color: Colors.black),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushNamed('/help');
                                              })
                                        ],
                                      )
                                    ],
                                  ))),
                          Container(
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    image: new AssetImage(
                                        "image/my_detail_bg.png"),
                                    fit: BoxFit.fill),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), 0, 0, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                "image/my_us.png"),
                                            width: ScreenUtil().setHeight(40),
                                          ),
                                          MaterialButton(
                                              child: Text(
                                                "关于我们",
                                                textAlign: TextAlign.left,
                                                style: new TextStyle(
                                                    fontFamily: "style1",
                                                    fontSize: ScreenUtil().setSp(20),
                                                    color: Colors.black),
                                              ),
                                              onPressed: gotoMyUs)
                                        ],
                                      )
                                    ],
                                  )))
                        ],
                      )))
            ])));

    return new Scaffold(
        //方式输入法顶掉背景图片
        resizeToAvoidBottomPadding: false,
        appBar: null,
        body: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Stack(
            alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
              Container(
                //设置背景图片
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage("image/home_bg.png"),
                      fit: BoxFit.fill),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(40.0),
                            top: ScreenUtil().setWidth(40.0)),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "我的",
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                                fontFamily: "style3",
                                fontSize: 24,
                                color: Colors.white),
                          ),
                        )),
                    Stack(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.95,
                          child: Center(
                            child: Image(
                              image: new AssetImage("image/my_content_bg.png"),
                              fit: BoxFit.fill,
                              width: ScreenUtil().setWidth(360),
                              height: ScreenUtil().setHeight(580),
                            ),
                          ),
                        ),
                        Column(children: <Widget>[body])
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: MaterialButton(
                    child: Image(
                  image: new AssetImage("image/find_bottom_bg.png"),
                  width: ScreenUtil().setWidth(360),
                )),
              ),
              Positioned(
                bottom: 0,
                left: ScreenUtil().setWidth((360 - 100) / 4 - 45),
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/icon_recommend.png"),
                      width: ScreenUtil().setWidth(100),
                    ),
                    onPressed: gotoHome),
              ),
              Positioned(
                bottom: 0,
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/icon_search.png"),
                      width: ScreenUtil().setWidth(100),
                    ),
                    onPressed: gotoFind),
              ),
              Positioned(
                bottom: 0,
                right: ScreenUtil().setWidth((360 - 100) / 4 - 45),
                child: MaterialButton(
                    child: Image(
                  image: new AssetImage("image/icon_my_mini_select.png"),
                  width: ScreenUtil().setWidth(100),
                )),
              )
            ],
          ),
        ));
  }
}
