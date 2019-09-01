import 'package:flutter/material.dart';

class FindResultFilterView extends StatefulWidget {
  Map<String, dynamic> params;

  FindResultFilterView({this.params});

  @override
  State<StatefulWidget> createState() {
    return FindResultFilterState();
  }
}

class FindResultFilterState extends State<FindResultFilterView> {
  static const String INSURANCE = "医保";
  static const String PAYSELF = "自费";
  static const TEXT_STYLE = TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.black,
      decoration: TextDecoration.none,
      fontSize: 18);
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  List<String> insuranceList = [];
  List<String> selectDiseases = [];

  @override
  void initState() {
    super.initState();

    if (widget.params != null && widget.params.isNotEmpty) {
      print("参数：${widget.params}");
      controller1.text = widget.params["contraindication"];
      controller2.text = widget.params["medicinalManufacturingEnterprise"];
      selectDiseases = widget.params["diseases"]?.split("~~");
      insuranceList = widget.params["medicinalIsInsurance"]?.split("~~");

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
      appBar: AppBar(
        title: Text(
          "筛选",
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: GestureDetector(
                  child: Image.asset("image/img_reset.png"),
                  onTap: () {
                    widget.params.clear();
                    controller1.clear();
                    controller2.clear();
                    selectDiseases.clear();
                    insuranceList.clear();
                    setState(() {});
                  }),
            ),
            Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Image.asset("image/img_ok.png"),
                  onTap: () {
                    Navigator.of(context).pop({
                      "medicinalIsInsurance": insuranceList.join("~~"),
                      "contraindication": controller1.text,
                      "medicinalManufacturingEnterprise": controller2.text,
                      "diseases": selectDiseases.join("~~")
                    });
                  },
                ))
          ],
        ),
      ),
    );
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
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("image/insurance_bg.png"), fit: BoxFit.fill)),
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: new BoxDecoration(
              color: Color.fromARGB(100, 245, 221, 250),
            ),
            padding: EdgeInsets.fromLTRB(10, 25, 10, 25),
            child: Text(
              "  药物是否纳入医保",
              style: TEXT_STYLE,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: insuranceList.contains(INSURANCE)
                      ? Image.asset(
                          "image/insurance.png",
                        )
                      : Image.asset(
                          "image/insurance_disable.png",
                        ),
                  onTap: () {
                    setState(() {
                      insuranceList.contains(INSURANCE)
                          ? insuranceList.remove(INSURANCE)
                          : insuranceList.add(INSURANCE);
                    });
                  },
                ),
                flex: 1,
              ),
              Expanded(
                child: GestureDetector(
                  child: insuranceList.contains(PAYSELF)
                      ? Image.asset("image/payself.png")
                      : Image.asset("image/payself_disable.png"),
                  onTap: () {
                    setState(() {
                      insuranceList.contains(PAYSELF)
                          ? insuranceList.remove(PAYSELF)
                          : insuranceList.add(PAYSELF);
                    });
                  },
                ),
                flex: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  getChildrens() {
    List<Widget> widgets = [];

    widgets.add(getInsuranceBox());
    widgets.add(PaddingView(Text(
      "  用药禁忌",
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
                color: Colors.green, width: 2.0, style: BorderStyle.solid)),
      ),
    )));
    widgets.add(PaddingView(Text(
      "  药品厂家",
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
                  color: Colors.green, width: 2.0, style: BorderStyle.solid))),
    )));

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
