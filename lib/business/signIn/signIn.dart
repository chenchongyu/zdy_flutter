import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zdy_flutter/net/Api.dart';
import 'package:zdy_flutter/net/netutils.dart';
import 'package:zdy_flutter/util/toast_util.dart';
import 'package:zdy_flutter/util/constant.dart';
import 'package:zdy_flutter/util/sp_util.dart';
import 'package:zdy_flutter/util/utils.dart';
import 'package:zdy_flutter/widget/my_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  ///是否发送
  var bSend = false;

  ///验证码文字
  String smsCodeText = "获取验证码";

  ///验证码倒计时
  Timer code_timer;

  ///倒计时
  int code_time = 59;

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

  @override
  void dispose() {
    code_timer?.cancel();
    code_timer = null;
    super.dispose();
  }

  ///切换登录注册
  void switchType() {
    setState(() {
      smsCode = "";
      controller_mobile.clear();
      controller_smsCode.clear();
      node_mobile.unfocus();
      node_smsCode.unfocus();
      if (code_time == 59) {
        smsCodeText = "获取验证码";
      }
      if (type == "1") {
        type = "2";
        _showProtocolDialog();
      } else {
        type = "1";
      }
    });
  }

  ///获取验证码
  void getCode() {
    //验证手机号码
    if (!checkMobile()) {
      return;
    }
    //发送获取验证码
    NetUtil.getJson(
            Api.GET_SMS_CODE, {"mobile": controller_mobile.text, "type": type})
        .then((data) {
      debugPrint("获取评价数据：" + data.toString());
      if (null != data['result']) {
        var result = data['result'];
        if ("OK" == result) {
          ToastUitl.shortToast("发送验证码成功");
          setState(() {
            bSend = true;
            if (code_timer != null) {
              return;
            }
            code_timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
              setState(() {
                if (code_time > 0) {
                  code_time--;
                } else {
                  bSend = false;
                  code_time = 59;
                  code_timer.cancel();
                  code_timer = null;
                  smsCodeText = "重新发送验证码";
                }
              });
            });
          });
        } else if ("isSend" == result) {
          ToastUitl.shortToast("已发送验证码,请稍后再试。");
        } else if ("isRegister" == result) {
          ToastUitl.shortToast("该手机号已经注册,请直接登录。");
        } else if ("isNotRegister" == result) {
          ToastUitl.shortToast("该手机号未注册。");
        } else {
          ToastUitl.shortToast("系统错误");
        }
      } else {
        ToastUitl.shortToast("系统错误");
      }
    });
  }

  ///验证手机号码
  checkMobile() {
    var result = RegExp(r"^1\d{10}$").hasMatch(controller_mobile.text);
    if (!result) {
      ToastUitl.shortToast("请输入正确的手机号码");
    }
    return result;
  }

  ///检查验证码
  checkCode() {
    var result = (controller_smsCode.text != "");
    if (!result) {
      ToastUitl.shortToast("请输入验证码");
    }
    return result;
  }

  ///注册
  void register() {
    //验证手机号码和验证码
    if (!checkMobile() || !checkCode()) {
      return;
    }
    NetUtil.getJson(Api.REGISTER, {
      "mobile": controller_mobile.text,
      "code": controller_smsCode.text
    }).then((data) {
      debugPrint("获取评价数据：" + data.toString());
      if (null != data['result']) {
        var result = data['result'];
        var token = data['token'];
        if ("success" == result && "" != token) {
          ToastUitl.shortToast("注册成功");
          SpUtil.putString(Constant.KEY_TOKEN, token);
          SpUtil.putInt(Constant.KEY_IS_SIGN_IN, 1);
          _showDialog(
              "新用户免费使用本软件一周,不限次数使用推荐和查找药功能,一周使用期结束后，每天只可以使用一次本软件的推荐药等所有查询功能。");
        } else if ("fail" == result) {
          ToastUitl.shortToast("注册失败");
        } else if ("isRegister" == result) {
          ToastUitl.shortToast("该手机号已经注册,请直接登录。");
        } else if ("isWrong" == result) {
          ToastUitl.shortToast("验证码不正确");
        } else if ("isExpire" == result) {
          ToastUitl.shortToast("验证码已过期");
        } else {
          ToastUitl.shortToast("系统错误");
        }
      } else {
        ToastUitl.shortToast("系统错误");
      }
    });
  }

  Future<void> _showDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(Constant.DIALOG_PADDING),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Constant.DIALOG_CORNER_RADIUS))),
          content: SingleChildScrollView(
              padding: EdgeInsets.all(1),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple, width: 2),
                        borderRadius: BorderRadius.all(
                            Radius.circular(Constant.DIALOG_CORNER_RADIUS)),
                      ),
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(20),
                              0,
                              ScreenUtil().setWidth(20),
                              0),
                          child: Column(
                            children: <Widget>[
                              Text(""),
                              Text(
                                "提示",
                                style: TextStyle(
                                  fontFamily: "style1",
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(""),
                              Text(
                                "　　" + content,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: "style1",
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Color.fromRGBO(
                                                    203, 106, 247, 1.0),
                                                width: 2))),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: GestureDetector(
                                              child: Text(
                                                '确认',
                                                textAlign: TextAlign.center,
                                              ),
                                              onTap: () {
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        '/home');
                                              }),
                                          width: ScreenUtil().setWidth(80),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          )),
                    ),
                  ),
                  Positioned(
                    child: Image.asset(
                      "image/dialog_img.png",
                      fit: BoxFit.contain,
                      width: 80,
                      height: 80,
                    ),
                    right: 1,
                    top: -20,
                  ),
                ],
              )),
        );
      },
    );
  }

  Future<void> _showProtocolDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0),
          contentPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          content: SingleChildScrollView(
              child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
              decoration: BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("image/dialog_protocol_top.png"),
                    fit: BoxFit.fill),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("image/dialog_protocol_mid.png"),
                    fit: BoxFit.fill),
              ),
              height: ScreenUtil().setHeight(350),
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Center(
                    child: Column(
                      //动态创建一个List<Widget>
                      children: <Widget>[
                        new Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      "    《服务协议》（以下简称“本协议”）由中医药信息研究所科学数据研究室在提供“找对药”软件（以下简称“本软件”）的移动端服务时与使用本软件的用户达成的各项规则、条款和条件。本协议在用户同意应用时生效。"),
                                  Text(
                                      "    您在成为本软件用户前，必须仔细阅读本协议，您可以选择不使用本软件，若使用本软件即被视为接受本协议中所述的所有规则、条款和条件，包括因被提及而纳入的条款和条件。"),
                                  Text("一、用户注册："),
                                  Text(
                                      "    1. 用户注册是指用户登陆本软件，按要求填写相关信息并确认同意履行相关用户协议的过程。"),
                                  Text(
                                      "    2. 本软件的用户必须是具有完全民事行为能力的自然人。无民事行为能力人、限制民事行为能力人不当注册为本软件用户，其与本软件之间的服务协议自始无效，一经发现，本软件有权立即停止与该用户的交易、注销该用户，并追究其使用本软件“服务”的一切法律责任。"),
                                  Text("二、用户的权利和义务："),
                                  Text(
                                      "    1. 用户有权拥有其在本软件的用户名及密码，并有权使用自己的用户名及密码随时登陆本软件。用户不得以任何形式转让或授权他人使用自己的本软件用户名。"),
                                  Text(
                                      "    2. 用户有权根据本协议的规定在本软件上查询药品信息、评价药品、发表反馈信息，以及享受本软件提供的其它信息服务。"),
                                  Text(
                                      "    3. 用户有义务在注册时提供自己的真实资料，并保证诸如电子邮件地址、联系电话、联系地址、邮政编码等内容的有效性及安全性，保证本软件可以通过上述联系方式与用户本人进行联系。同时，用户也有义务在相关资料实际变更时及时更新有关注册资料。用户保证不以他人资料在本软件进行注册行为。"),
                                  Text("三、本软件的权利和义务："),
                                  Text(
                                      "    1.本软件有义务在现有技术上维护整个平台的正常运行，并努力提升和改进技术，使用户查询药品活动得以顺利进行。"),
                                  Text(
                                      "    2.本软件可以在没有特殊通知的情况下自行变更本规则、任何其它条款和条件、规则或用户资格的任何方面。 对这些条款的任何修改将被包含在本软件更新的规则中。如果任何变更被认定为无效、废止或因任何原因不可执行，则该变更是可分割的，且不影响其它变更或条件的有效性或可执行性。在变更这些规则后，用户对本软件的继续使用即构成用户对变更的接受。"),
                                  Text(
                                      "    3. 本软件可以不经通知而自行决定终止全部或部分规则，或终止用户的会员资格。即使本软件没有要求或强制用户严格遵守这些规则，也并不构成对属于北本软件的任何权利的放弃。如果用户在本软件的客户账户被关闭，那么也将丧失相应的会员资格。对于该用户会员资格的丧失，用户对本软件不能主张任何权利或为此索赔。"),
                                  Text("四、不承诺担保和责任限制："),
                                  Text(
                                      "    1.本软件提供给用户的全部信息、内容、材料、药品（包括软件）和服务，或任何包括、经由、连结、下载，或任何与本产品有关服务所获得的推荐、内容或信息（以下统称为“信息”），是由本软件在\"按现状\"和\"按现有\"的基础上提供的。本软件不对以上任何信息作任何形式的、明示或默示的声明或担保（除根据中华人民共和国法律规定的以外），也不对该等信息的更新或改善承担任何义务，对任何因该等信息所产生的任何风险与损害亦不承担任何责任。"),
                                  Text(
                                      "    2. 本软件的用户必须是具有完全民事行为能力的自然人。无民事行为能力人、限制民事行为能力人，其与本软件之间的服务协议自始无效。用户应明确了解并同意自担使用或购买本软件的全部风险，并接受本协议的全部所有规则、条款和条件的约束。本软件对用户的使用或购买决定不承担任何责任。"),
                                  Text(
                                      "    3.本软件针对常见病症提供药品查询和推荐等方面的信息服务，此相关信息只作为建议性内容，仅供参考，不得作为诊断、治疗及用药的依据，也不能替代医疗机构的就诊、检查和诊疗。用户因参考本软件信息自行诊疗与用药所导致的任何风险与损害，本软件不承担任何责任。"),
                                  Text("五、版权声明："),
                                  Text(
                                      "    1. 本软件所提供的服务内容、技术、程序、数据及其他信息（包括文字、图标、图片、照片、音频、视频、图表、色彩组合、版面设计、商标、商号、域名等）的所有权利（包括但不限于著作权、商标权、专利权、商业秘密等相关权利）均属中医药信息研究所科学数据研究室的财产，受中国和国际知识产权法的保护，未经中医药信息研究所科学数据研究室或相关权利人的书面许可，任何人不得复制、转载、摘编、修改、链接、镜像或以其他方式再造上述内容，否则将视为侵权，中医药信息研究所科学数据研究室保留追究其法律责任的权利。"),
                                  Text("六、适用的法律和管辖权："),
                                  Text(
                                      "    用户和本软件之间的契约将适用中华人民共和国的法律，所有的争端将诉诸于本软件所在地的人民法院。"),
                                  Text(
                                      "    中医药信息研究所科学数据研究室保留对上述条款修改权和最终解释的权利。"),
                                  Text("    中医药信息研究所科学数据研究室版权所有。")
                                ]))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
                decoration: BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage("image/dialog_protocol_down.png"),
                      fit: BoxFit.fill),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ])),
        );
      },
    );
  }

  ///登录
  void siginIn() {
    //验证手机号码和验证码
    if (!checkMobile() || !checkCode()) {
      return;
    }
    NetUtil.getJson(Api.SIGN_IN, {
      "mobile": controller_mobile.text,
      "code": controller_smsCode.text
    }).then((data) {
      debugPrint("获取评价数据：" + data.toString());
      if (null != data['result']) {
        var result = data['result'];
        var token = data['token'];
        if ("success" == result && "" != token) {
          ToastUitl.shortToast("登录成功");
          SpUtil.putString(Constant.KEY_TOKEN, token);
          SpUtil.putInt(Constant.KEY_IS_SIGN_IN, 1);
          Navigator.of(context).pushReplacementNamed('/home');
        } else if ("fail" == result) {
          ToastUitl.shortToast("登录失败");
        } else if ("isNotRegister" == result) {
          ToastUitl.shortToast("该手机号未注册");
        } else if ("isWrong" == result) {
          ToastUitl.shortToast("验证码不正确");
        } else if ("isExpire" == result) {
          ToastUitl.shortToast("验证码已过期");
        } else {
          ToastUitl.shortToast("系统错误");
        }
      } else {
        ToastUitl.shortToast("系统错误");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 760, allowFontScaling: false);
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
        fontSize: 10,
        fontWeight: FontWeight.bold);
    final btnStyle = TextStyle(
        fontFamily: "style1",
        color: Color.fromRGBO(0, 0, 0, 1.0),
        fontSize: 16,
        fontWeight: FontWeight.bold);
    final linkStyle = TextStyle(
        fontFamily: "style1",
        color: Color.fromRGBO(250, 179, 30, 1.0),
        fontSize: 24,
        fontWeight: FontWeight.bold);
    final linkStyle2 = TextStyle(
        fontFamily: "style1", fontSize: 24, fontWeight: FontWeight.bold);

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: null,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Center(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 3, color: Utils.hexToColor("#cb73f4")),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          child: Text(
                                            "手机号码：",
                                            textAlign: TextAlign.left,
                                            style: new TextStyle(
                                                fontFamily: "style1",
                                                fontSize:
                                                    ScreenUtil().setSp(20),
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: TextFormField(
                                                  controller: controller_mobile,
                                                  focusNode: node_mobile,
                                                  inputFormatters: [
                                                    WhitelistingTextInputFormatter(
                                                        RegExp("[0-9]")),
                                                    //限制只允许输入字母和数字
                                                  ],
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(20)),
                                                  onSaved: (String value) =>
                                                      smsCode = value,
                                                  validator: (String value) {
                                                    if (value.isEmpty) {
                                                      return '请输入手机号';
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 0)))),
                                        ),
                                      ),
                                    ],
                                  )),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Container(
                                          child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 5,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 15, 0, 0),
                                              child: Text(
                                                "验证码：",
                                                textAlign: TextAlign.left,
                                                style: new TextStyle(
                                                    fontFamily: "style1",
                                                    fontSize:
                                                        ScreenUtil().setSp(20),
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
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
                                                        fontSize: ScreenUtil()
                                                            .setSp(20)),
                                                    onSaved: (String value) =>
                                                        mobile = value,
                                                    validator: (String value) {
                                                      if (value.isEmpty) {
                                                        return '请输入验证码';
                                                      }
                                                    },
                                                  )),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: new BoxDecoration(
                                                border: Border.all(
                                                    width: 2,
                                                    color: Color.fromRGBO(
                                                        95, 30, 154, 1.0)),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: bSend
                                                    ? null
                                                    : Color.fromRGBO(
                                                        236, 217, 234, 1.0),
                                                image: bSend
                                                    ? new DecorationImage(
                                                        image: new AssetImage(
                                                            "image/signin_label_bg_disabled.png"),
                                                        fit: BoxFit.fill)
                                                    : null,
                                              ),
                                              child: bSend
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              5, 10, 5, 10),
                                                      child: Text(
                                                          "等待（${code_time}秒）",
                                                          style: codeStyle))
                                                  : GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .opaque,
                                                      onTap: getCode,
                                                      child: Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  5, 10, 5, 10),
                                                          child: Text(
                                                              smsCodeText,
                                                              style:
                                                                  codeStyle))),
                                            ),
                                          ),
                                        ],
                                      ))),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 55, 0, 0),
                                      child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap:
                                              type == "1" ? siginIn : register,
                                          child: Row(children: <Widget>[
                                            Expanded(flex: 1, child: Text("")),
                                            Expanded(
                                              flex: 10,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    60, 10, 60, 0),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color:
                                                                    Color.fromRGBO(
                                                                        196,
                                                                        144,
                                                                        191,
                                                                        1.0),
                                                                width: 2))),
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 0, 5),
                                                        child: Text(
                                                            type == "1"
                                                                ? "立即登录"
                                                                : "立即注册",
                                                            style: linkStyle2))),
                                              ),
                                            ),
                                            Expanded(flex: 1, child: Text(""))
                                          ]))),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 20, 0, 20),
                                      child: Row(children: <Widget>[
                                        Expanded(
                                          flex: 10,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 10, 0, 10),
                                                child: Row(children: <Widget>[
                                                  Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        type == "1"
                                                            ? "没有账号？"
                                                            : "已有账号？",
                                                        style: btnStyle,
                                                        textAlign:
                                                            TextAlign.end,
                                                      )),
                                                  Expanded(
                                                      flex: 4,
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                                      color: Color.fromRGBO(
                                                                          114, 65, 4, 1.0),
                                                                      width:
                                                                          2))),
                                                          child: Padding(
                                                              padding:
                                                                  EdgeInsets.fromLTRB(
                                                                      0, 0, 0, 5),
                                                              child: GestureDetector(
                                                                  onTap:
                                                                      switchType,
                                                                  child: Text(
                                                                      type == "1" ? "立即注册" : "立即登录",
                                                                      style: linkStyle))))),
                                                  Expanded(
                                                      flex: 3, child: Text("")),
                                                ])),
                                          ),
                                        )
                                      ])),
                                ],
                              )))))
            ],
          ),
          Positioned(
              right: ScreenUtil().setWidth(-10),
              top: ScreenUtil().setHeight(-5),
              child: MaterialButton(
                  child: Image(
                image: AssetImage("image/my_vip.png"),
                width: ScreenUtil().setWidth(40),
                height: ScreenUtil().setWidth(40),
              ))),
        ],
      ),
    );
  }
}
