import 'Utils/web.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StockItem {
  final String icon;
  final String color;
  final String name;
  final String url;
  StockItem({this.name, this.url, this.icon, this.color});
}

class StockMenu extends StatefulWidget {
  final String mname;
  StockMenu({Key key, @required this.mname}) : super(key: key);

  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<StockMenu> {
  String tit, agr;
  bool _enabled = false;

  List<StockItem> _stockMenu = [];
  void __stockMenu() {
    var list = <StockItem>[
      StockItem(
        icon: 'chartBar',
        color: 'a2d5f2',
        name: 'Stockout Base Data V 2.0',
        url:
            "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=NzE=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1",
      ),
    ];
    setState(() {
      _stockMenu = list;
    });
  }

  IconData getIconForName(String iconName) {
    switch (iconName) {
      case 'dropbox':
        {
          return FontAwesomeIcons.dropbox;
        }
      default:
        {
          return FontAwesomeIcons.chartBar;
        }
    }
  }

  @override
  void initState() {
    super.initState();
    __stockMenu();
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
            Container(
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
                      GestureDetector(
                           onTap: () async {
                                setState(() {
                                  _enabled = true;
                                  agr = 'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mjk=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1';
                                  tit = "Stockout Details V 2.0";
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
                              color: Colors.green[100]
                              // color: Color(0xfff7dad9),
                              ),
                          child: Center(
                              child: FaIcon(
                            FontAwesomeIcons.dropbox,
                            size: 25,
                          )),
                        ),
                        Container(
                            width: 140,
                            child: Text(
                              'Stockout Details V 2.0',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(fontSize: 12),
                            ))
                      ])),
                      ListView.builder(
                          shrinkWrap: true, // new line
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: _stockMenu.length,
                          itemBuilder: (context, index) {
                            var item = _stockMenu[index];
                            Color bgColor = new Color(int.parse(
                                    item.color.substring(0, 6),
                                    radix: 16) +
                                0xFF000000); 
                            return GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _enabled = true;
                                  agr = "${item.url}";
                                  tit = "${item.name}";
                                });
                              },
                              // onTap: () {

                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => SingleWeb(
                              //             title: '${item.name}',
                              //             url: '${item.url}')),
                              //   );
                              // },
                              child: Column(children: [
                                Container(
                                  height: 50.0,
                                  width: 50.0,
                                  margin: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                    boxShadow: [
                                      // new BoxShadow(
                                      //     color: Color.fromARGB(100, 0, 0, 0),
                                      //     blurRadius: 5.0,
                                      //     offset: Offset(5.0, 5.0))
                                    ],
                                    border: Border.all(
                                        width: 2.0,
                                        style: BorderStyle.solid,
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                    color: bgColor,
                                    // image: DecorationImage(
                                    //     fit: BoxFit.cover,
                                    //     image: NetworkImage(
                                    //         "https://cdn.dribbble.com/users/1368/screenshots/1785863/icons_2x.png"))
                                  ),
                                  child: Center(
                                      child: FaIcon(
                                    getIconForName(item.icon),
                                    size: 25,
                                  )),
                                ),
                                Container(
                                    width: 140,
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
            Expanded(
              child: 
              _enabled
                    ? Container(
                        child: SingleWeb(url: agr, title: tit),
                      ) :
              Stack(
                children: <Widget>[
                  WebView(
                    key: _key,
                    initialUrl:
                        'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mjk=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1',
                    javascriptMode: JavascriptMode.unrestricted,
                    onPageFinished: (finish) {
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                  isLoading
                      ? Center(
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
              ),
            )
          ],
        ));
  }
}
