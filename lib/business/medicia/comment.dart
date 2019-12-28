import 'package:flutter/material.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/widget/checkbox_text_view.dart';
import 'package:zdy_flutter/widget/my_app_bar.dart';
import 'package:zdy_flutter/widget/star_rating_bar.dart';

class CommentPage extends StatefulWidget {
  String mid;

  CommentPage(this.mid); //药品id

  @override
  State<StatefulWidget> createState() {
    return CommentState(mid);
  }
}

class CommentState extends State<CommentPage> {
  String mid;
  int score; // 星级评分
  String scoreText=""; //星级评价说明
  int evaluateTag; //-1:效果不错，-2：效果一般
  var margin = EdgeInsets.all(10);

  ///输入框控制器
  final controller = new TextEditingController();

  CommentState(this.mid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar("药品点评",centerTitle: true,),
      body: getBody(),
    );
  }

  getBody() {
    ///星级评价区域
    Widget header = new Container(
      margin: margin,
      padding: EdgeInsets.all(15),
      width: double.infinity,
      decoration: new BoxDecoration(
        image: new DecorationImage(
            image: new AssetImage("image/comment_context_bg.png"), fit: BoxFit.fill),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "疗效",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "style1",
                    fontWeight: FontWeight.bold),
              ),
              Text(
                scoreText,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "style1"),
              )
            ],
          ),
          RatingBar(
            size: 35,
            clickable: true,
            onValueChangedCallBack: _onValueChange,
          )
        ],
      ),
    );

    ///文字评价区域
    Widget commentView = Container(
        margin: margin,
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("image/find_edit_text_bg.png"),
              fit: BoxFit.fill),
        ),
        child: TextField(
          controller: controller,
          decoration: new InputDecoration(
            hintText: "请填写您对本药品的使用感受",
            contentPadding: const EdgeInsets.all(20.0),
            hintStyle: new TextStyle(color: Colors.grey),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
          maxLines: 6,
          keyboardType: TextInputType.text,
        ));

    ///复选框
    Widget radio1 = Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        width: double.infinity,
        child: CheckboxTextView.noBgHasSize(
            "效果不错，推荐使用", evaluateTag == -1, onCheckBoxSelect, 18, "style1","image/icon_checkbox_default.png",));

    Widget radio2 = Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        width: double.infinity,
        child: CheckboxTextView.noBgHasSize(
            "效果一般", evaluateTag == -2, onCheckBoxSelect, 18, "style1","image/icon_checkbox_default.png",));

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          header,
          commentView,
          radio1,
          radio2,
          Container(
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 2),
            child: ImageBox("image/comment_img.png", 200, 100),
          ),
          GestureDetector(
            child: ImageBox("image/icon_find_submit.png", double.infinity, 80),
            onTap: submitComment,
          ),
        ],
      ),
    );
  }

  void submitComment() {
    Map<String, dynamic> params = {
      "medicinalId": mid,
      "evaluateStar": score,
      "evaluateContent": controller.text,
      "evaluateTags": evaluateTag
    };
    NetUtil.getJson(Api.ADD_EVALUATE, params).then((data) {
      Navigator.of(context).pop(1);
    }).catchError((error) {
      print("请求错误${error.msg}");
    });
  }

  void _onValueChange(double value) {
    this.score = value.floor();
    scoreText = _getText(value.toInt());
    setState(() {});
    print("评分$value");
  }

  onCheckBoxSelect(bool selected, String word, [Map params]) {
    evaluateTag = word == "效果一般" ? -2 : -1;
    setState(() {});
  }

  String _getText(int value) {
    switch(value){
      case 5: return "非常满意";
      case 4: return "比较满意";
      case 3: return "一般";
      case 2: return "不满意";
      case 1: return "很不满意";
      default:
        return "";
    }
  }
}

class ImageBox extends StatelessWidget {
  String image;
  double width;
  double height;

  ImageBox(this.image, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: width,
      height: height,
      padding: EdgeInsets.all(12),
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}
