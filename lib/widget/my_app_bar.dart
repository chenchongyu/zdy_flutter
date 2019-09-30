import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  MyAppBar(String _title, {List<Widget> actions})
      : super(
            title: Text(
              _title,
              style: new TextStyle(
                  fontFamily: "style1",
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            leading: Builder(builder: (BuildContext context) {
              return MaterialButton(
                  child: Image(
                    image: new AssetImage("image/leading.png"),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  });
            }),
            flexibleSpace: Image.asset('image/app_bar_bg.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity),
            actions: actions);
}
