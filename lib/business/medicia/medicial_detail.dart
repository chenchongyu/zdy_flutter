import 'package:flutter/material.dart';
import 'package:zdy_flutter/business/medicia/comment.dart';
import 'package:zdy_flutter/model/evaluate_list.dart';
import 'package:zdy_flutter/model/medicial_detail.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/widget/my_app_bar.dart';

class MedicialDetailView extends StatefulWidget {
  String mId;
  String mName;

  MedicialDetailView(this.mId, this.mName);

  @override
  State<StatefulWidget> createState() {
    return _MedicialState();
  }
}

class _MedicialState extends State<MedicialDetailView> {
  MedicialDetail medicialDetail;
  EvaluateList evaluateList;

  ///是否被收藏
  String medicinalCollect = "0";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        widget.mName,
        actions: <Widget>[
          Center(
              child: GestureDetector(
            child: Text(
              medicinalCollect == "0" ? "收藏  " : "取消收藏  ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  fontSize: 20),
            ),
            onTap: () async {
              if (medicinalCollect == "0") {
                collect();
              } else {
                uncollect();
              }
            },
          ))
        ],
      ),
      body: getBody(),
    );
  }

  void loadData() {
    print("loadData");
    Map<String, dynamic> params = {"medicinalId": widget.mId, "rows": 200};

    NetUtil.getJson(Api.GET_MEDICINAL_DETAIL, params).then((data) {
      debugPrint("获取药品详情数据：" + data.toString());
      var sResult = MedicialDetail.fromJson(data);
      setState(() {
        this.medicialDetail = sResult;
        this.medicinalCollect = medicialDetail.medicinal.medicinalCollect;
        print(this.medicinalCollect);
      });

      if (sResult.medicinal.medicinalContraindication != null) {
        //药品禁忌弹窗
        _showContranindicationDialog(sResult);
      }
    });
    NetUtil.getJson(Api.GET_EVALUATE_LIST, params).then((data) {
      debugPrint("获取评价数据：" + data.toString());
      var sResult = EvaluateList.fromJson(data);
      setState(() {
        this.evaluateList = sResult;
      });
    });
  }

  getBody() {
    if (medicialDetail == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[detailInfoView(), commentView(), recommendView()],
        ),
      );
    }
  }

  ///收藏
  void collect() {
    NetUtil.getJson(Api.ADD_COLLECT,
        {"medicinalId": medicialDetail.medicinal.medicinalId}).then((data) {
      debugPrint("获取到数据：" + data.toString());
      setState(() {
        this.medicinalCollect = "1";
      });
    });
  }

  ///取消收藏
  void uncollect() {
    NetUtil.getJson(Api.CANCEL_COLLECT,
        {"medicinalId": medicialDetail.medicinal.medicinalId}).then((data) {
      debugPrint("获取到数据：" + data.toString());
      setState(() {
        this.medicinalCollect = "0";
      });
    });
  }

  //药品详情
  Widget detailInfoView() {
    var styleData = TextStyle(
        color: Color.fromRGBO(149, 149, 149, 1.0),
        fontSize: 14,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none);
    var styleTitle = TextStyle(
        color: Color.fromRGBO(3, 3, 140, 1.0),
        fontWeight: FontWeight.bold,
        fontSize: 14,
        decoration: TextDecoration.none);
    var medicinal = medicialDetail.medicinal;
    var pad = EdgeInsets.fromLTRB(5, 5, 5, 0);
    return new Container(
        alignment: Alignment.topLeft,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border:
              Border.all(color: Color.fromRGBO(202, 234, 245, 1.0), width: 3.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  medicinal.medicinalName,
                  style: styleTitle,
                ),
                medicinal.medicinalIsInsurance == "医保"
                    ? Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: new DecorationImage(
                                  image: new AssetImage("image/yby.png"),
                                  fit: BoxFit.fill),
                            ),
                            child: Text("医保药",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 10))))
                    : Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: new DecorationImage(
                                  image: new AssetImage("image/fyb.png"),
                                  fit: BoxFit.fill),
                            ),
                            child: Text("非医保",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 10))))
              ],
            ),
            Text(
              medicinal.medicinalManufacturingEnterprise,
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  decoration: TextDecoration.none),
            ),
            Divider(
              height: 1,
            ),
            Padding(
              padding: pad,
              child: Text(
                "成分",
                style: styleTitle,
              ),
            ),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.medicinalIngredients,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "性状",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.medicinalCharacter,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "主治功能",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.medicinalFunction,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "规格",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.medicinalSpecification,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "用法用量",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.medicinalUsage,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "不良反应",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.medicinalAdverseReactions,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "用药禁忌",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.medicinalContraindication,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "注意事项",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.medicinalAttentions,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "贮藏",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.medicinalStorage,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "包装",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.medicinalPackage,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "有效期",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.medicinalValidity,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "作用类别",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.zuoyonglb == "" ? "无" : medicinal.zuoyonglb,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "药物相互作用",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.medicinalInteract == ""
                      ? "无"
                      : medicinal.medicinalInteract,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "药物过量",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.yaowugl == "" ? "无" : medicinal.yaowugl,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "药理毒理",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.yaowudl == "" ? "无" : medicinal.yaowudl,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "药代动力学",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.yaodaidlx == "" ? "无" : medicinal.yaodaidlx,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "执行标准",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.medicinalOperativeNorm,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "批准文号",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.medicinalLicenseNumber,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "企业地址",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.medicinalEnterpriseAddress,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "妊娠期妇女及哺乳期妇女用药",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.renchenqyy == "" ? "无" : medicinal.renchenqyy,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "儿童用药",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.ertongyy == "" ? "无" : medicinal.ertongyy,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "老年患者用药",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.laonianyy == "" ? "无" : medicinal.laonianyy,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "临床研究",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.linchuangyy == "" ? "无" : medicinal.linchuangyy,
                  style: styleData,
                )),
            Padding(
                padding: pad,
                child: Text(
                  "警告",
                  style: styleTitle,
                )),
            Padding(
                padding: pad,
                child: Text(
                  medicinal.jinggao == "" ? "无" : medicinal.jinggao,
                  style: styleData,
                )),
          ],
        ));
  }

  //评价列表
  Widget commentView() {
    return Column(
      children: getCommentViews(),
    );
  }

  getCommentViews() {
    if (evaluateList == null ||
        evaluateList.evaluatelist == null ||
        evaluateList.evaluatelist.gridModel == null) {
      return [Text("")];
    }
    var dataList = evaluateList.evaluatelist.gridModel;
    var style = TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontFamily: "style1",
        fontWeight: FontWeight.bold);
    List<Widget> list = [];
    list.add(Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("image/comment_bg.png"), fit: BoxFit.fill),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(6),
              child: Text(
                "用户点评   (${dataList.length})",
                style: style,
              )),
          GestureDetector(
            child: Row(
              children: <Widget>[
                Image.asset(
                  "image/comment_my.png",
                  width: 150,
                  height: 60,
                )
              ],
            ),
            onTap: () async {
              int result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      CommentPage(medicialDetail.medicinal.medicinalId)));
              //点评成功会返回1
              if (result == 1) {
                loadData();
              }
            },
          )
        ],
      ),
    ));

    for (GridModel data in dataList) {
      var date = data.evaluateTime;
      Widget commentItem = Container(
        margin: EdgeInsets.fromLTRB(12, 3, 12, 0),
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //兼容double类型数据
            getStartView(double.parse(data.evaluateStar).floor()),
            Text(data.evaluateContent),
            Divider(
              height: 1,
            ),
            Text("${date.substring(0, 4).toString()}-${date.substring(4, 6)}-"
                "${date.substring(6, 8)} "
                "${date.substring(8, 10)}:"
                "${date.substring(10, 12)}"),
          ],
        ),
      );

      list.add(commentItem);
    }
    return list;
  }

  //药品推荐
  Widget recommendView() {
    List<Widget> list = [];

    var recommendList = medicialDetail.recommendList;
    if (recommendList == null || recommendList.isEmpty) {
      list.add(Text(""));
    } else {
      for (RecommendList item in recommendList) {
        list.add(GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return MedicialDetailView(item.medicinalId, item.medicinalName);
          })),
          child: Text(
            item.medicinalName,
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          ),
        ));
      }
    }

    return Container(
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Color.fromRGBO(238, 238, 238, 1.0),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: EdgeInsets.fromLTRB(6, 8, 6, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "同类药品推荐 (${recommendList.length})",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: "style1",
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(6, 8, 6, 8),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("image/comment_down.png"),
                          fit: BoxFit.fill),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: list,
                    ),
                  ),
                ],
              ),
            )));
  }

  getStartView(int nums) {
    List<Widget> list = [];

    for (var i = 0; i < nums; i++) {
      list.add(Icon(
        Icons.star,
        color: Colors.orangeAccent,
      ));
    }

    return Row(
      children: list,
    );
  }

  Future<void> _showContranindicationDialog(MedicialDetail sResult) {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            content: _ContraninditionDialog(sResult),
          );
        });
  }
}

class _ContraninditionDialog extends StatelessWidget {
  MedicialDetail sResult;

  _ContraninditionDialog(this.sResult);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("image/tip_man.png"),
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                        child: Text(
                          "用药禁忌",
                          style: TextStyle(
                              fontFamily: "style1",
                              fontSize: 18,
                              color: Colors.brown,
                              fontWeight: FontWeight.bold),
                        ),
                        right: 10,
                        top: 130)
                  ],
                ),
                Text(sResult.medicinal.medicinalContraindication),
                Text(""),
                Text("配伍禁忌",
                    style: TextStyle(
                        fontFamily: "style1",
                        fontSize: 18,
                        color: Colors.brown,
                        fontWeight: FontWeight.bold)),
                Text(
                  sResult.medicinal.medicinalIncompatibility,
                  overflow: TextOverflow.clip,
                )
              ],
            ),
          )),
    );
  }
}
