import 'package:flutter/material.dart';
import 'package:zdy_flutter/model/evaluate_list.dart';
import 'package:zdy_flutter/net/netutils.dart';

import 'model/medicial_detail.dart';
import 'net/Api.dart';

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
      appBar: AppBar(
        title: Text(widget.mName),
        backgroundColor: Colors.purple[400],
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
    var titleStyle = TextStyle(
      color: Colors.lightBlue,
      fontSize: 18,
      decoration: TextDecoration.none,
    );
    var dataStyle = TextStyle(
        color: Colors.black45,
        fontSize: 16,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none);
    var medicinal = medicialDetail.medicinal;
    var pad = EdgeInsets.fromLTRB(5, 5, 5, 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              medicinal.medicinalName,
              style: titleStyle,
            ),
            Text(
              medicinal.medicinalIsInsurance,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  color: medicinal.medicinalIsInsurance == "医保"
                      ? Colors.green
                      : Colors.pinkAccent,
                  fontSize: 12),
            )
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
            style: titleStyle,
          ),
        ),
        Padding(
            padding: pad,
            child: Text(
              medicinal.medicinalIngredients,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "性状",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.medicinalCharacter,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "主治功能",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.medicinalFunction,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "规格",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.medicinalSpecification,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "用法用量",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.medicinalUsage,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "不良反应",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.medicinalAdverseReactions,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "用药禁忌",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.medicinalContraindication,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "注意事项",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.medicinalAttentions,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "贮藏",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.medicinalStorage,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "包装",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.medicinalPackage,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "有效期",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.medicinalValidity,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "作用类别",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.zuoyonglb == "" ? "无" : medicinal.zuoyonglb,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "药物相互作用",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.medicinalInteract == ""
                  ? "无"
                  : medicinal.medicinalInteract,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "药物过量",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.yaowugl == "" ? "无" : medicinal.yaowugl,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "药理毒理",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.yaowudl == "" ? "无" : medicinal.yaowudl,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "药代动力学",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.yaodaidlx == "" ? "无" : medicinal.yaodaidlx,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "执行标准",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.medicinalOperativeNorm,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "批准文号",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.medicinalLicenseNumber,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "企业地址",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.medicinalEnterpriseAddress,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "妊娠期妇女及哺乳期妇女用药",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.renchenqyy == "" ? "无" : medicinal.renchenqyy,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "儿童用药",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.ertongyy == "" ? "无" : medicinal.ertongyy,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "老年患者用药",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.laonianyy == "" ? "无" : medicinal.laonianyy,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "临床研究",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.linchuangyy == "" ? "无" : medicinal.linchuangyy,
              style: dataStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              "警告",
              style: titleStyle,
            )),
        Padding(
            padding: pad,
            child: Text(
              medicinal.jinggao == "" ? "无" : medicinal.jinggao,
              style: dataStyle,
            )),
      ],
    );
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
    var style = TextStyle(color: Colors.white, fontSize: 20);
    List<Widget> list = [];
    list.add(Container(
      margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("image/comment_bg.png"), fit: BoxFit.fill),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "用户点评(${dataList.length})",
            style: style,
          ),
          Row(
            children: <Widget>[
              Image.asset(
                "image/comment.png",
                width: 25,
                height: 25,
              ),
              Text("我要点评", style: style),
            ],
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
            getStartView(int.parse(data.evaluateStar)),
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
      list.add(Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.purple[400],
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Text(
          "药品推荐(${recommendList.length})",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ));
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
      margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),
    );
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
}
