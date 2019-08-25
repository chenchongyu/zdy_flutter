import 'package:flutter/material.dart';

class CheckboxTextView extends StatefulWidget {
  String text;
  bool selected;
  bool showBg;
  bool setWidth;
  Map<String, dynamic> params; //透传参数
  Function(bool selected, String word, [Map<String, dynamic> params])
      onCheckboxSelect;

  CheckboxTextView(this.text, this.selected, this.onCheckboxSelect)
      : showBg = true,
        setWidth = true;

  CheckboxTextView.noBg(this.text, this.selected, this.onCheckboxSelect)
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
    return Container(
      width: widget.setWidth
          ? MediaQuery.of(context).size.width / 3 - 2
          : double.infinity,
      decoration: BoxDecoration(color: widget.showBg ? Colors.grey[350] : null),
      padding: EdgeInsets.fromLTRB(3, 1, 5, 1),
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
          Text(
            widget.text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12,
                color: Colors.black26,
                decoration: TextDecoration.none),
          )
        ],
      ),
    );
  }
}
