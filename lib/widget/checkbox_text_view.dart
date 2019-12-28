import 'package:flutter/material.dart';

class CheckboxTextView extends StatefulWidget {
  String text;
  bool selected;
  bool showBg;
  bool setWidth;
  double dataFontSize = 12;
  String fontFamily = "";
  String checkboxDisableImg = "image/icon_checkbox_disable.png";
  TextStyle textStyle;

  Map<String, dynamic> params; //透传参数
  Function(bool selected, String word, [Map<String, dynamic> params])
      onCheckboxSelect;

  CheckboxTextView(this.text, this.selected, this.onCheckboxSelect,
      {this.dataFontSize})
      : showBg = true,
        setWidth = true;

  CheckboxTextView.noBg(this.text, this.selected, this.onCheckboxSelect)
      : showBg = false,
        setWidth = false;

  CheckboxTextView.noBgBlue(
      this.text, this.selected, this.onCheckboxSelect, this.checkboxDisableImg,
      {this.textStyle})
      : showBg = false,
        setWidth = false;

  CheckboxTextView.noBgHasSize(this.text, this.selected, this.onCheckboxSelect,
      this.dataFontSize, this.fontFamily, this.checkboxDisableImg)
      : showBg = false,
        setWidth = false;

  CheckboxTextView.withParams(
      this.text, this.selected, this.params, this.onCheckboxSelect,{this.dataFontSize})
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
            //#f7faf9
            color: widget.showBg ? Color.fromRGBO(247, 250, 249, 1.0) : null,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: widget.showBg
                ? Border.all(
                    color: Color.fromRGBO(236, 236, 236, 1.0), width: 3.0)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                child: Image.asset(
                  widget.selected
                      ? "image/icon_checkbox_selected_blue.png"
                      : widget.checkboxDisableImg,
                  width: 26,
                  fit: BoxFit.fitWidth,
                ),
                onTap: () {
                  widget.selected = !widget.selected;
                  setState(() {});
                  widget.onCheckboxSelect(
                      widget.selected, widget.text, widget.params);
                },
              ),
              Text(
                widget.text,
                overflow: TextOverflow.ellipsis,
                style: widget.textStyle == null
                    ? TextStyle(
                        fontSize: widget.dataFontSize,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        fontFamily: widget.fontFamily)
                    : widget.textStyle,
              )
            ],
          ),
        ));
  }
}
