import 'package:flutter/material.dart';
import 'package:zdy_flutter/util/utils.dart';
import 'package:zdy_flutter/widget/checkbox_text_view.dart';
import 'package:zdy_flutter/widget/my_app_bar.dart';

class ResultFilterView extends StatefulWidget {
  List<String> diseases;
  Map<String, dynamic> params;

  ResultFilterView(this.diseases, {this.params});

  @override
  State<StatefulWidget> createState() {
    return ResultFilterState();
  }
}

class ResultFilterState extends State<ResultFilterView> {
  static const String INSURANCE = "医保";
  static const String PAYSELF = "非医保";
  static const TEXT_STYLE = TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.black,
      decoration: TextDecoration.none,
      fontSize: 16);
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  List<String> insuranceList = List();
  List<String> selectDiseases = List();

  @override
  void initState() {
    super.initState();

    if (widget.params != null && widget.params.isNotEmpty) {
      print("参数：${widget.params}");
      controller1.text = widget.params["contraindication"];
      controller2.text = widget.params["medicinalManufacturingEnterprise"];
      selectDiseases = widget.params["diseases"]?.split("~~");
      insuranceList = widget.params["medicinalIsInsurance"]?.split("~~");
      print("参数：${selectDiseases}  ${insuranceList}");
      if (insuranceList == null) {
        insuranceList = [];
      }

      if (selectDiseases == null) {
        selectDiseases = [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar("筛选"),
      body: getBody(),
      bottomNavigationBar: BottomAppBar(
          child: new Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                child: GestureDetector(
                    child: Image.asset(
                      "image/img_reset.png",
                      fit: BoxFit.fitHeight,
                    ),
                    onTap: () {
                      widget.params.clear();
                      controller1.clear();
                      controller2.clear();
                      selectDiseases.clear();
                      insuranceList.clear();
                      setState(() {});
                    }),
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  child: GestureDetector(
                    child: Image.asset(
                      "image/img_ok.png",
                      fit: BoxFit.fitHeight,
                    ),
                    onTap: () {
                      Navigator.of(context).pop({
                        "medicinalIsInsurance": listToStr(insuranceList),
                        "contraindication": controller1.text,
                        "medicinalManufacturingEnterprise": controller2.text,
                        "diseases": listToStr(selectDiseases)
                      });
                    },
                  ),
                ))
          ],
        ),
      )),
    );
  }

  String listToStr(List list) {
    //删除空元素
    list.remove("");
    return list.length == 1 ? list[0] : list.join("~~");
  }

  getBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getChildrens(),
      ),
    );
  }

  getInsuranceBox() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: _ImgCheckBox(
                  "image/insurance.png",
                  insuranceList.contains(INSURANCE),
                  INSURANCE,
                  _onInsuranceChange),
              flex: 1,
            ),
            Expanded(
              child: _ImgCheckBox("image/payself.png",
                  insuranceList.contains(PAYSELF), PAYSELF, _onInsuranceChange),
              flex: 1,
            ),
          ],
        ),
      ],
    );
  }

  _onInsuranceChange(check, type) {
    if (check) {
      insuranceList.add(type);
    } else {
      insuranceList.remove(type);
    }
  }

  getDiseases() {
    List<Widget> list = [];
    widget.diseases.forEach((String s) {
      list.add((new Padding(
          padding: EdgeInsets.fromLTRB(30, 5, 0, 5),
          child: CheckboxTextView.noBgBlue(s, selectDiseases.contains(s),
              _onCheckBoxChange, "image/icon_checkbox_default.png"))));
    });

    return list;
  }

  _onCheckBoxChange(bool selected, String word, [Map params]) {
    selected ? selectDiseases.add(word) : selectDiseases.remove(word);
    print(selectDiseases);
  }

  getChildrens() {
    List<Widget> widgets = [];
    widgets.add(new Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)));
    widgets.add(PaddingView(Text(
      "  药物是否纳入医保",
      style: TEXT_STYLE,
    )));

    widgets.add(PaddingView(Image.asset("image/text_underline.png")));
    widgets.add(getInsuranceBox());
    widgets.add(PaddingView(Text(
      "  请填写既往病史；多个病史，用空格分开",
      style: TEXT_STYLE,
    )));

    widgets.add(PaddingView(Image.asset("image/text_underline.png")));
    widgets.add(PaddingView(TextField(
      controller: controller1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10.0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: Utils.hexToColor("#c6f5fb"),
                width: 2.0,
                style: BorderStyle.solid)),
      ),
    )));
    widgets.add(PaddingView(Text(
      "  是否有心仪的药品厂家",
      style: TEXT_STYLE,
    )));
    widgets.add(PaddingView(Image.asset("image/text_underline.png")));
    widgets.add(PaddingView(TextField(
      controller: controller2,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                  color: Utils.hexToColor("#c6f5fb"),
                  width: 2.0,
                  style: BorderStyle.solid))),
    )));
    widgets.add(PaddingView(Text(
      "  或许您知道得了什么病？",
      style: TEXT_STYLE,
    )));

    widgets.addAll(getDiseases());

    return widgets;
  }
}

class PaddingView extends StatelessWidget {
  Widget child;

  PaddingView(this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 3, 10, 3),
      child: this.child,
    );
  }
}

class _ImgCheckBox extends StatefulWidget {
  String _img;
  bool _check;
  Function onChange;
  String type;

  _ImgCheckBox(this._img, this._check, this.type, this.onChange);

  @override
  State<StatefulWidget> createState() {
    return _ImgCheckBoxState(_img, _check, onChange);
  }
}

class _ImgCheckBoxState extends State<_ImgCheckBox> {
  String _img;
  bool _check;
  Function onChange;

  _ImgCheckBoxState(this._img, this._check, this.onChange);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            _check
                ? "image/icon_checkbox_selected_blue"
                    ".png"
                : "image/icon_checkbox_default.png",
            width: 26,
            fit: BoxFit.fitWidth,
          ),
          Image.asset(
            _img,
            width: 90,
            fit: BoxFit.fitHeight,
          )
        ],
      ),
      onTap: () => _onChange(!_check),
    );
  }

  void _onChange(bool value) {
    setState(() {
      _check = value;
    });
    onChange(value, widget.type);
  }
}
