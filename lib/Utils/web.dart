import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SingleWeb extends StatefulWidget {
  final String url;
  final String title;
  SingleWeb({Key key, @required this.url, @required this.title})
      : super(key: key);

  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<SingleWeb> {
  num position = 1;
  String webUrl = "", webTitle = "", url;
  SharedPreferences prefs;
  WebViewController controller;

  final key = UniqueKey();
  
  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SingleWeb oldWidget) {
    if (controller != null)
      setState(() {
        controller.loadUrl(widget.url);
      });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.clearCache();
    super.dispose();
  }

  getInitialData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      webTitle = prefs.getString("title");
      webUrl = prefs.getString("url");
    });
  }

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xffffffff),
      body: IndexedStack(index: position, children: <Widget>[
        WebView(
          onWebViewCreated: (WebViewController webViewController) {
            setState(() {
              controller = webViewController;
            });
          },
          initialUrl: "${widget.url}",
          javascriptMode: JavascriptMode.unrestricted,
          key: key,
          onPageFinished: doneLoading,
          onPageStarted: startLoading,
        ),
        Container(
          color: Colors.white,
          child: Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
            CircularProgressIndicator(),
            Text('Loading Data, please wait...'),
            ]),
            ),
        ),
      ]));
  }
}