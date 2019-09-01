import 'package:flutter/material.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/widget/checkbox_text_view.dart';
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
  int evaluateTag; //-1:效果不错，-2：效果一般
  var margin = EdgeInsets.all(10);

  ///输入框控制器
  final controller = new TextEditingController();

  CommentState(this.mid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "药品点评",
          style: new TextStyle(
              fontFamily: "style1",
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        leading: MaterialButton(
            child: Image(
              image: new AssetImage("image/leading.png"),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        flexibleSpace: Image.asset('image/app_bar_bg.png',
            fit: BoxFit.cover, width: double.infinity, height: double.infinity),
      ),
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
            image: new AssetImage("image/question_bg.png"), fit: BoxFit.fill),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "疗效",
            style: TextStyle(color: Colors.black, fontSize: 18),
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
        margin: margin,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("image/comment_bg.png"), fit: BoxFit.fill),
        ),
        child: CheckboxTextView.noBg(
            "效果不错，推荐使用", evaluateTag == -1, onCheckBoxSelect));

    Widget radio2 = Container(
        margin: margin,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("image/comment_bg.png"), fit: BoxFit.fill),
        ),
        child:
            CheckboxTextView.noBg("效果一般", evaluateTag == -2, onCheckBoxSelect));

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
            child: ImageBox("image/comment_submit.png", double.infinity, 80),
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
    print("评分$value");
  }

  onCheckBoxSelect(bool selected, String word, [Map params]) {
    evaluateTag = word == "效果一般" ? -2 : -1;
    setState(() {});
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
