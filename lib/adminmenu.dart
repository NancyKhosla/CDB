import 'Utils/basicAuth.dart';
import 'Utils/web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AdminMenu extends StatefulWidget {
  final String mname;
  AdminMenu({
    Key key,
    @required this.mname,
  }) : super(key: key);

  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<AdminMenu> {
  String tit, agr;
  bool _enabled = false;

  List<AdminItem> _adminMenu = [];
  void __adminMenu() {
    var list = <AdminItem>[
      AdminItem(
          icon: 'chartBar',
          color: 'ffc1f3',
          name: 'State DVDMS Performance Report (Last month)',
          url:
              'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=NDU=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1'),
      AdminItem(
          icon: 'chartBar',
          color: 'f3eac2',
          name: 'State DVDMS Performance Report 3.0',
          url:
              'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MTI0&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1'),
      AdminItem(
          icon: 'chartBar',
          color: 'a2d5f2',
          name: 'State Rank(Daily)',
          url:
              'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=NTI=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1'),
      AdminItem(
          icon: 'chartLine',
          color: 'c3aed6',
          name: 'Monthly State Rank',
          url:
              'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MzY=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1'),
      AdminItem(
          icon: 'chartBar',
          color: 'a2d5f2',
          name: 'Functional Facilities',
          url:
              'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Nzc=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1'),
      AdminItem(
          icon: 'chartBar',
          color: 'ad9d9d',
          name: 'Consolidated State Performance',
          url:
              'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=ODQ=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1'),
      AdminItem(
          icon: 'chartBar',
          color: 'a2d5f2',
          name: 'Consolidated State Performance 2.0',
          url:
              'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MTI1&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1'),
    ];
    setState(() {
      _adminMenu = list;
    });
  }

  IconData getIconForName(String iconName) {
    switch (iconName) {
      case 'table':
        {
          return FontAwesomeIcons.solidHandshake;
        }
      case 'table':
        {
          return FontAwesomeIcons.table;
        }
      case 'chartLine':
        {
          return FontAwesomeIcons.chartLine;
        }
      default:
        {
          return FontAwesomeIcons.chartBar;
        }
    }
  }

ScrollController _scrollViewController;
bool _showAppbar = true; 
bool isScrollingDown = false;

@override
  void initState() {
    super.initState();
     __adminMenu();
  }

@override
  void dispose() {
    _scrollViewController.dispose();
    _scrollViewController.removeListener(() {});
    super.dispose();
    }

  bool isLoading = true, pressed = false;
  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('${widget.mname}'),
        ),
        body: Column(
          children: [
          AnimatedContainer(
          height: _showAppbar ? 120.0 : 0.0,
          duration: Duration(milliseconds: 500),
            child: Container(
                height: 120,
                decoration: new BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.red[200],
                    Colors.red[200].withOpacity(.7)
                  ]),
                ),
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(5.0),
                    children: [
                      ListView.builder(
                      shrinkWrap: true, // new line
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: _adminMenu.length,
                      itemBuilder: (context, index) {
                        var item = _adminMenu[index];
                        Color bgColor = new Color(int.parse(
                                item.color.substring(0, 6),
                                radix: 16) +
                            0xFF000000); 
                        return GestureDetector(
                          onTap: () async {
                            setState(() {
                              _enabled = true;
                              agr = '${item.url}';
                              tit = "${item.name}";
                            });
                          },
                          child: Column(children: [
                          Container(
                            height: 50.0,
                            width: 50.0,
                            margin: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              border: Border.all(
                                  width: 2.0,
                                  style: BorderStyle.solid,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                              color: bgColor,
                                ),
                                  child: Center(
                                      child: FaIcon(
                                    getIconForName(item.icon),
                                    size: 25,
                                  )),
                                ),
                                Container(
                                    width: 100,
                                    child: Text(
                                      item.name,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(fontSize: 12),
                                    ))
                              ]),
                            );
                          }),
                    ])),
             ),
            Expanded(
            child: _enabled
              ? Container(
                  child: SingleWeb(url: agr, title: tit),
                ) : 
              Stack(
                children: <Widget>[
                  WebView(
                    key: _key,
                    initialUrl:
                        "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=NDU=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1",
                    javascriptMode: JavascriptMode.unrestricted,
                    onPageFinished: (finish) {
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                  isLoading
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Container(
                            margin: EdgeInsets.only(top:20),
                          child:CircularProgressIndicator())])
                      : Stack(),
                ],
              ),
            )
          ],
        ));
  }
}
