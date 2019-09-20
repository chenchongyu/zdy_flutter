import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/model/search_result_model.dart';

class SignInPage extends StatefulWidget {
  SignInPage();

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  ///页面类型 1登录 2注册
  String type = "1";

  ///手机号码
  String mobile = "";

  ///验证码
  String smsCode = "";

  ///输入框手机号码控制器
  final controller_mobile = new TextEditingController();

  ///输入框验证码控制器
  final controller_smsCode = new TextEditingController();

  ///输入框手机号码焦点
  FocusNode node_mobile = FocusNode();

  ///输入框验证码焦点
  FocusNode node_smsCode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  ///切换登录注册
  void switchType() {
    setState(() {
      mobile = "";
      smsCode = "";
      controller_mobile.clear();
      controller_smsCode.clear();
      node_mobile.unfocus();
      node_smsCode.unfocus();
      if (type == "1") {
        type = "2";
      } else {
        type = "1";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
        color: Color.fromRGBO(88, 7, 170, 1.0),
        fontSize: 24,
        fontWeight: FontWeight.bold);
    final inputStyle = TextStyle(
        color: Color.fromRGBO(88, 7, 170, 1.0),
        fontSize: 24,
        fontWeight: FontWeight.bold);
    final codeStyle = TextStyle(
        color: Color.fromRGBO(88, 7, 170, 1.0),
        fontSize: 14,
        fontWeight: FontWeight.bold);
    final btnStyle = TextStyle(
        fontFamily: "style1",
        color: Color.fromRGBO(255, 255, 255, 1.0),
        fontSize: 24,
        fontWeight: FontWeight.bold);
    final linkStyle = TextStyle(
        fontFamily: "style1",
        color: Color.fromRGBO(250, 179, 30, 1.0),
        fontSize: 24,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
        decorationColor: Color.fromRGBO(246, 179, 127, 1.0),
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: 2);

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          type == "1" ? "用户登录" : "用户注册",
          style: new TextStyle(
              fontFamily: "style1",
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: null,
        flexibleSpace: Image.asset('image/app_bar_bg.png',
            fit: BoxFit.cover, width: double.infinity, height: double.infinity),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Center(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Container(
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                                image: new AssetImage("image/signin_bg.png"),
                                fit: BoxFit.fill),
                          ),
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 2,
                                            color: Color.fromRGBO(
                                                179, 226, 249, 1.0)),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 6,
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              decoration: new BoxDecoration(
                                                image: new DecorationImage(
                                                    image: new AssetImage(
                                                        "image/signin_label_bg.png"),
                                                    fit: BoxFit.fill),
                                              ),
                                              child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 5, 30, 5),
                                                  child: Text("手机号码",
                                                      style: labelStyle)),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 7,
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 0, 10, 5),
                                                  child: TextFormField(
                                                      controller:
                                                          controller_mobile,
                                                      focusNode: node_mobile,
                                                      inputFormatters: [
                                                        WhitelistingTextInputFormatter(
                                                            RegExp("[0-9]")),
                                                        //限制只允许输入字母和数字
                                                      ],
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                      onSaved: (String value) =>
                                                          smsCode = value,
                                                      validator:
                                                          (String value) {
                                                        if (value.isEmpty) {
                                                          return '请输入手机号';
                                                        }
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromRGBO(
                                                                    146,
                                                                    69,
                                                                    215,
                                                                    1.0),
                                                            width: 2,
                                                            style: BorderStyle
                                                                .solid),
                                                      )))),
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Container(
                                          decoration: new BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 2,
                                                color: Color.fromRGBO(
                                                    179, 226, 249, 1.0)),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 6,
                                                child: Container(
                                                  alignment: Alignment.topLeft,
                                                  decoration: new BoxDecoration(
                                                    image: new DecorationImage(
                                                        image: new AssetImage(
                                                            "image/signin_label_bg.png"),
                                                        fit: BoxFit.fill),
                                                  ),
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 5, 30, 5),
                                                      child: Text("验  证  码",
                                                          style: labelStyle)),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 0, 10, 5),
                                                      child: TextFormField(
                                                        controller:
                                                            controller_smsCode,
                                                        focusNode: node_smsCode,
                                                        inputFormatters: [
                                                          WhitelistingTextInputFormatter(
                                                              RegExp("[0-9]")),
                                                          //限制只允许输入字母和数字
                                                        ],
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                        onSaved:
                                                            (String value) =>
                                                                mobile = value,
                                                        validator:
                                                            (String value) {
                                                          if (value.isEmpty) {
                                                            return '请输入手机号';
                                                          }
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                                enabledBorder:
                                                                    UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      146,
                                                                      69,
                                                                      215,
                                                                      1.0),
                                                              width: 2,
                                                              style: BorderStyle
                                                                  .solid),
                                                        )),
                                                      )),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Container(
                                                  alignment: Alignment.topLeft,
                                                  decoration: new BoxDecoration(
                                                    border: Border.all(
                                                        width: 2,
                                                        color: Color.fromRGBO(
                                                            95, 30, 154, 1.0)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    image: new DecorationImage(
                                                        image: new AssetImage(
                                                            "image/signin_label_bg.png"),
                                                        fit: BoxFit.fill),
                                                  ),
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              5, 5, 5, 5),
                                                      child: Text("重新发送验证码",
                                                          style: codeStyle)),
                                                ),
                                              ),
                                            ],
                                          ))),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 55, 0, 0),
                                      child: Row(children: <Widget>[
                                        Expanded(flex: 2, child: Text("")),
                                        Expanded(
                                          flex: 8,
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: new BoxDecoration(
                                              image: new DecorationImage(
                                                  image: new AssetImage(
                                                      "image/signin-btn-bg.png"),
                                                  fit: BoxFit.fill),
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 10, 0, 10),
                                                child: Text(
                                                    type == "1"
                                                        ? "立即登录"
                                                        : "立即注册",
                                                    style: btnStyle)),
                                          ),
                                        ),
                                        Expanded(flex: 2, child: Text(""))
                                      ])),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 20, 0, 20),
                                      child: Row(children: <Widget>[
                                        Expanded(flex: 2, child: Text("")),
                                        Expanded(
                                          flex: 8,
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            decoration: new BoxDecoration(
                                              image: new DecorationImage(
                                                  image: new AssetImage(
                                                      "image/signin-btn-bg.png"),
                                                  fit: BoxFit.fill),
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 0, 10),
                                                child: Row(children: <Widget>[
                                                  Text(
                                                      type == "1"
                                                          ? "没有账号？"
                                                          : "已有账号？",
                                                      style: btnStyle),
                                                  GestureDetector(
                                                      onTap: switchType,
                                                      child: Text(
                                                          type == "1"
                                                              ? "立即注册"
                                                              : "立即登录",
                                                          style: linkStyle))
                                                ])),
                                          ),
                                        ),
                                        Expanded(flex: 2, child: Text(""))
                                      ])),
                                ],
                              )))))
            ],
          )
        ],
      ),
    );
  }
}
