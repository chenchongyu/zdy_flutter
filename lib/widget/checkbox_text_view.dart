import 'package:flutter/material.dart';

class CheckboxTextView extends StatefulWidget {
  String text;
  bool selected;
  bool showBg;
  bool setWidth;
  double dataFontSize = 12;
  String fontFamily = "";
  Map<String, dynamic> params; //透传参数
  Function(bool selected, String word, [Map<String, dynamic> params])
      onCheckboxSelect;

  CheckboxTextView(this.text, this.selected, this.onCheckboxSelect)
      : showBg = true,
        setWidth = true;

  CheckboxTextView.noBg(this.text, this.selected, this.onCheckboxSelect)
      : showBg = false,
        setWidth = false;

  CheckboxTextView.noBgHasSize(this.text, this.selected, this.onCheckboxSelect,
      this.dataFontSize, this.fontFamily)
      : showBg = false,
        setWidth = false;

  CheckboxTextView.withParams(
      this.text, this.selected, this.params, this.onCheckboxSelect)
      : showBg = false,
        setWidth = false;

  @override
  State<StatefulWidget> createState() => _CheckboxTextState();
}

class _CheckboxTextState extends State<CheckboxTextView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            widget.showBg ? EdgeInsets.fromLTRB(5, 1, 5, 1) : EdgeInsets.all(0),
        child: Container(
          width: widget.setWidth
              ? (MediaQuery.of(context).size.width - 30) / 3 - 2
              : double.infinity,
          decoration: BoxDecoration(
            color: widget.showBg ? Color.fromRGBO(248, 248, 248, 1.0) : null,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: widget.showBg
                ? Border.all(
                    color: Color.fromRGBO(236, 236, 236, 1.0), width: 3.0)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                  value: widget.selected,
                  onChanged: (bool value) {
                    setState(() {
                      widget.selected = value;
                    });
                    widget.onCheckboxSelect(value, widget.text, widget.params);
                  }),
              "" != widget.fontFamily
                  ? Text(
                      widget.text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: widget.dataFontSize,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontFamily: widget.fontFamily),
                    )
                  : Text(
                      widget.text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: widget.dataFontSize,
                          decoration: TextDecoration.none),
                    )
            ],
          ),
        ));
  }
}
