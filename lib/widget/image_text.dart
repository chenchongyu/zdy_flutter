import 'package:flutter/material.dart';

class ImageText extends StatelessWidget {
  static const TextStyle defaulstStyle =
      TextStyle(color: Colors.purple, fontSize: 20);

  //todo 支持方向设定
  String _title;
  String _image;
  Function _onTap;

  ImageText(this._title, this._image, this._onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Column(
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
        ),
        onTap: () => _onTap != null ? _onTap() : () {});
  }
}
