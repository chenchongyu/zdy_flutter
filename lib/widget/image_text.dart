import 'package:flutter/material.dart';

class ImageText extends StatelessWidget {
  static const TextStyle defaulstStyle =
      TextStyle(color: Colors.purple, fontSize: 20);

  //todo 支持方向设定
  String _title;
  String _image;

  ImageText(this._title, this._image);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset(
          _image,
          width: 70,
          fit: BoxFit.fitWidth,
        ),
        Text(
          _title,
          style: defaulstStyle,
        )
      ],
    );
  }
}
