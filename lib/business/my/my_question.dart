import 'package:flutter/material.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/util/toast_util.dart';
import 'package:zdy_flutter/util/utils.dart';
import 'package:zdy_flutter/widget/my_app_bar.dart';

class MyQuestionPage extends StatefulWidget {
  MyQuestionPage();

  @override
  _MyQuestionPageState createState() => _MyQuestionPageState();
}

class _MyQuestionPageState extends State<MyQuestionPage> {
  @override
  void initState() {
    nodeOne = FocusNode();
    nodeTwo = FocusNode();
    super.initState();
  }

  ///输入框焦点
  FocusNode nodeOne;

  ///输入框控制器
  final controller = new TextEditingController();

  ///输入框焦点
  FocusNode nodeTwo;

  ///输入框控制器
  final controllerTwo = new TextEditingController();

  void submit() {
    if (controller.text == "") {
      ToastUitl.shortToast("请输入您的问题");
      FocusScope.of(context).requestFocus(nodeOne);
      return;
    }
    if (controllerTwo.text == "") {
      ToastUitl.shortToast("请输入您的联系方式");
      FocusScope.of(context).requestFocus(nodeTwo);
      return;
    }
    NetUtil.getJson(
        Api.ADD_FEEDBACK, {"feedbackContent": controllerTwo.text, "feedbackConcact": controller.text})
        .then((data) {
      debugPrint("获取评价数据：" + data.toString());
      ToastUitl.shortToast("感谢您的反馈");
      Navigator.of(context).pop();
    });
  }

  Widget buildTextField(
      TextEditingController controller, FocusNode focusNode, int lines) {
    return TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
            hintText: "",
            contentPadding: const EdgeInsets.all(10.0),
            hintStyle: new TextStyle(color: Colors.black),
            border: InputBorder.none),
        maxLines: lines,
        keyboardType: TextInputType.text);
  }

  @override
  Widget build(BuildContext context) {
    //屏幕分辨率
    MediaQueryData queryData = MediaQuery.of(context);
    //宽
    double screen_width = queryData.size.width;

    Widget input = new Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: buildTextField(controller, nodeOne, 5),
            )
          ],
        ),
      ),
    );

    //去友情链接
    return new Scaffold(
        //方式输入法顶掉背景图片
        resizeToAvoidBottomPadding: false,
        appBar: MyAppBar("问题反馈",centerTitle: true,),
        body: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.topLeft, //指定未定位或部分定位widget的对齐方式
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Image(
                              image: new AssetImage("image/question_bg.png"),
                            )),
                        Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                child: Image(
                                    image: new AssetImage(
                                        "image/question_text.png"))),
                            input
                          ],
                        )
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 80, 0),
                        child: Image(
                          image: new AssetImage("image/question_img.png"),
                        )),
                    Container(
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 3, color: Utils.hexToColor("#c6f5fb")),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: buildTextField(controllerTwo, nodeTwo, 1)),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                        child: MaterialButton(
                            child: Image(
                              image:
                                  new AssetImage("image/icon_find_submit.png"),
                            ),
                            onPressed: () => submit()))
                  ],
                ))));
  }
}
