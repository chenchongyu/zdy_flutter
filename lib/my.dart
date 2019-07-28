import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/model/link_info.dart';
import 'my_link.dart';

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
  ///跳转友情链接
  gotoMyLink() {
    NetUtil.getJson(Api.GET_FRIEND_LINK_LIST, {}).then((data) {
      debugPrint("获取到数据：" + data.toString());
      LinkInfo sResult = LinkInfo.fromJson(data);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MyLinkPage(sResult)));
    });
  }

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
    //高
    double screen_heigth = queryData.size.height;
    //像素比
    double devicePixelRatio = queryData.devicePixelRatio;

    Widget body = new Center(
        child: Padding(
            padding: EdgeInsets.fromLTRB(40, 60, 40, 0),
            child: Column(children: <Widget>[
              Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage("image/my_body_bg.png"),
                        fit: BoxFit.fill),
                  ),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                "image/my_collection.png"),
                                            width: 30,
                                          ),
                                          MaterialButton(
                                              child: Image(
                                            image: new AssetImage(
                                              "image/my_collection_text.png",
                                            ),
                                            width: 80,
                                          ))
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                "image/my_link.png"),
                                            width: 30,
                                          ),
                                          MaterialButton(
                                              child: Image(
                                                image: new AssetImage(
                                                  "image/my_link_text.png",
                                                ),
                                                width: 80,
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                "image/my_product.png"),
                                            width: 30,
                                          ),
                                          MaterialButton(
                                              child: Image(
                                            image: new AssetImage(
                                              "image/my_product_text.png",
                                            ),
                                            width: 80,
                                          ))
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                "image/my_question.png"),
                                            width: 30,
                                          ),
                                          MaterialButton(
                                              child: Image(
                                            image: new AssetImage(
                                              "image/my_question_text.png",
                                            ),
                                            width: 80,
                                          ))
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                "image/help.png"),
                                            width: 30,
                                          ),
                                          MaterialButton(
                                              child: Image(
                                            image: new AssetImage(
                                              "image/my_help_text.png",
                                            ),
                                            width: 80,
                                          ))
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Image(
                                            image: new AssetImage(
                                                "image/my_us.png"),
                                            width: 30,
                                          ),
                                          MaterialButton(
                                              child: Image(
                                            image: new AssetImage(
                                              "image/my_us_text.png",
                                            ),
                                            width: 80,
                                          ))
                                        ],
                                      )
                                    ],
                                  )))
                        ],
                      ))),
              Image(
                image: new AssetImage("image/my_welcome.png"),
              )
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
                        padding: EdgeInsets.only(left: 40.0, top: 40.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "我的",
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        )),
                    Stack(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.95,
                          child: Center(
                            child: Image(
                              image:
                                  new AssetImage("image/find_content_bg.png"),
                              fit: BoxFit.fill,
                              height: 550,
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
                  width: screen_width,
                )),
              ),
              Positioned(
                bottom: 10.0,
                left: (screen_width - 80) / 4 - 32,
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/icon_recommend.png"),
                      width: 80,
                    ),
                    onPressed: gotoHome),
              ),
              Positioned(
                bottom: 10.0,
                child: MaterialButton(
                    child: Image(
                      image: new AssetImage("image/icon_search_mini.png"),
                      width: 80,
                    ),
                    onPressed: gotoFind),
              ),
              Positioned(
                bottom: 10.0,
                right: (screen_width - 80) / 4 - 32,
                child: MaterialButton(
                    child: Image(
                  image: new AssetImage("image/icon_my_mini_select.png"),
                  width: 80,
                )),
              )
            ],
          ),
        ));
  }
}
