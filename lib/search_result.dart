import 'package:flutter/material.dart';
import 'package:zdy_flutter/model/search_result.dart';
import 'package:zdy_flutter/net/netutils.dart';

import 'net/Api.dart';

class SearchResultView extends StatelessWidget {
  String keywords;

  SearchResultView(this.keywords);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("推荐药"),
        actions: <Widget>[Text("筛选")],
        backgroundColor: Colors.purple[400],
      ),
      body: ResultStatePage(keywords),
    );
  }
}

class ResultStatePage extends StatefulWidget {
  String keywords;

  ResultStatePage(this.keywords);

  @override
  State<StatefulWidget> createState() {
    return ResultState(keywords);
  }
}

class ResultState extends State<ResultStatePage> {
  String keywords;
  SearchResult searchResult;
  num page;

  ResultState(this.keywords);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: getBody(),
    );
  }

  getBody() {
    if (searchResult == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return getBodyView();
    }
  }

  Widget getBodyView() {
    var keywordView = new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
            image: new AssetImage("image/keyword_bg.png"), fit: BoxFit.fill),
      ),
      child: Column(
        children: <Widget>[
          Image(
            image: new AssetImage("image/keyword_title.png"),
          ),
          KeyWordView(searchResult.recommedWords),
        ],
      ),
    );

    return Container(
      child: Column(
        children: <Widget>[
          keywordView,
        ],
      ),
    );
  }

  void loadData() {
    NetUtil.get(Api.RecommendSubmit, (result) {
      print("获取到数据：" + result);
      SearchResult sResult = SearchResult.fromJson(result);
      setState(() {
        this.searchResult = sResult;
      });
    }, params: {"text": keywords, "page": this.page, "rows": 10});
  }
}

//关键词view
class KeyWordView extends StatelessWidget {
  final List<String> recommedWords;

  KeyWordView(this.recommedWords);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
        spacing: 5, //主轴上子控件的间距
        runSpacing: 5, //交叉轴上子控件之间的间距
        children: Boxs()); //要显示的子控件集合);
  }

  List<Widget> Boxs() {
    List<Widget> list = [];
    recommedWords.map((word) {
      list.add(new Container(
        decoration: BoxDecoration(color: Colors.white),
        child: RichText(
          text: TextSpan(text: word, children: [
            TextSpan(text: " X", style: TextStyle(color: Colors.red))
          ]),
        ),
      ));
    });

    return list;
  }
}
