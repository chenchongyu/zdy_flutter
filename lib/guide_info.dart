import 'package:flutter/material.dart';

import 'main.dart';
import 'util/constant.dart';
import 'util/sp_util.dart';

class PageGuideView extends StatelessWidget {
  var _pageController = new PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemBuilder: (BuildContext context, int index) {
        return index == 0
            ? new Image.asset(
                "image/guide1.png",
                fit: BoxFit.fill,
              )
            : GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MyApp();
                  }));
                  SpUtil.putInt(Constant.KEY_IS_FIRST, 1);
                },
                child: new Image.asset(
                  "image/guide2.png",
                  fit: BoxFit.fill,
                ),
              );
      },
      itemCount: 2,
    );
  }

  void _onPageChanged(int idx) {}
}
