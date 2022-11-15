import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart'; 

class RankMenu extends StatefulWidget {
  final String mname;
  RankMenu({Key key, @required this.mname}) : super(key: key);

  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<RankMenu> {
  bool isLoading = true, pressed = false;
  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('${widget.mname}'),
        ),
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl:
                "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MzY=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1",
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? 
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                CircularProgressIndicator(),
                Text('Loading Data, please wait...'),
              ]),
            )
            : Stack(),
          ],
        ));
  }
}
