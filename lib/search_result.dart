import 'package:flutter/material.dart';
import 'package:zdy_flutter/model/search_result.dart';
import 'package:zdy_flutter/model/user.dart';
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
    return ResultState();
  }
}

class ResultState extends State<ResultStatePage> {
  SearchResult searchResult;
  int page = 1;
  List<String> submitWords;

  ResultState();

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
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Container(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "已输入信息",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 18),
                ),
                KeyWordView(submitWords, _delWord),
              ],
            )),
      ),
    );

    return Container(
      child: Column(
        children: <Widget>[
          keywordView,
          //todo otherviews
        ],
      ),
    );
  }

  void loadData() {
    NetUtil.getJson(Api.RecommendSubmit,
        {"text": getKeyWords(), "page": this.page, "rows": 10}).then((data) {
      print("获取到数据：" + data.toString());
      var sResult = SearchResult.fromJson(data);
      setState(() {
        this.submitWords = sResult.submitWords;
        this.searchResult = sResult;
      });
    });
  }

  String getKeyWords() =>
      searchResult == null ? widget.keywords : submitWords.join(" ");

  _delWord(String word) {
    if (submitWords.contains(word)) {
      setState(() {
        submitWords.remove(word);
        loadData();
      });
    }
  }
}

//关键词view
class KeyWordView extends StatelessWidget {
  final List<String> submitWords;
  Function delWord;

  KeyWordView(this.submitWords, this.delWord);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
        spacing: 5, //主轴上子控件的间距
        runSpacing: 5, //交叉轴上子控件之间的间距
        children: Boxs());
  }

  List<Widget> Boxs() {
    List<Widget> list = [];
    for (var word in submitWords) {
      list.add(new GestureDetector(
        onTap: () => delWord(word),
        child: new RichText(
          text: TextSpan(
              text: word,
              style:
                  TextStyle(color: Colors.black, backgroundColor: Colors.white),
              children: [
                TextSpan(text: " X", style: TextStyle(color: Colors.red))
              ]),
        ),
      ));
    }

    return list;
  }
}
