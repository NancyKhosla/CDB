import 'Utils/web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MaternalMainItem {
  final String icon;
  final String color;
  final String name;
  final String url;
  MaternalMainItem({this.name, this.url, this.icon, this.color});
}

class MaternalMenu extends StatefulWidget {
  final String mname;
  MaternalMenu({Key key, @required this.mname}) : super(key: key);

  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<MaternalMenu> {
  String tit, agr;
  bool _enabled = false;

  List<MaternalMainItem> _maternalDashbaordMenu = [];
  void __maternalDashbaordMenu() {
    var list = <MaternalMainItem>[
      MaternalMainItem(
          icon: 'briefcaseMedical',
          color: 'f3eac2',
          name: 'Maternal Health Edl Detail',
          url:
              'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=NDA=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1'),
      MaternalMainItem(
          icon: 'chartBar',
          color: 'a2d5f2',
          name: 'Stock Detail of Maternal Health',
          url:
              'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mzg=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1'),
      MaternalMainItem(
          icon: 'chartBar',
          color: 'c3aed6',
          name:
              'Rate Contract details for Drugs, with name containing iron or ifa',
          url:
              'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=NDQ=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1'),
    ];
    setState(() {
      _maternalDashbaordMenu = list;
    });
  }

  IconData getIconForName(String iconName) {
    switch (iconName) {
      case 'briefcaseMedical':
        {
          return FontAwesomeIcons.briefcaseMedical;
        }
      case 'solidHandshake':
        {
          return FontAwesomeIcons.solidHandshake;
        }
      case 'balanceScale':
        {
          return FontAwesomeIcons.balanceScale;
        }
      case 'table':
        {
          return FontAwesomeIcons.table;
        }
      case 'exclamationTriangle':
        {
          return FontAwesomeIcons.exclamationTriangle;
        }
      case 'shoppingCart':
        {
          return FontAwesomeIcons.dropbox;
        }
      case 'compress':
        {
          return FontAwesomeIcons.compressAlt;
        }
      case 'chartBar':
        {
          return FontAwesomeIcons.chartBar;
        }
        break;
      default:
        {
          return FontAwesomeIcons.user;
        }
    }
  }

    ScrollController _scrollViewController;
    bool _showAppbar = true; 
    bool isScrollingDown = false;

  @override
  void initState() {
    super.initState();

  // ***** scroll the screen of that the user want to auto hide the menu bar ******// 

  //      _scrollViewController = new ScrollController();
  //     _scrollViewController.addListener(() {
  //   if (_scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
  //     if (!isScrollingDown) {
  //       isScrollingDown = true;
  //       _showAppbar = false;
  //       setState(() {});
  //     }
  //   }

  //   if (_scrollViewController.position.userScrollDirection == ScrollDirection.forward) {
  //     if (isScrollingDown) {
  //       isScrollingDown = false;
  //       _showAppbar = true;
  //       setState(() {});
  //     }
  //   }
  // });
    __maternalDashbaordMenu();
  }

    @override
    void dispose() {
  // _scrollViewController.dispose();
  // _scrollViewController.removeListener(() {});
    super.dispose();
  }

  bool isLoading = true, pressed = false;
  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.green,
        //   title: Text('${widget.mname}'),
        // ),
        body: Column(
          children: [
          AnimatedContainer(
          height: _showAppbar ? 120.0 : 0.0,
          duration: Duration(milliseconds: 500),
            child:
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
                            FontAwesomeIcons.chartPie,
                            size: 25,
                          )),
                        ),
                        Container(
                            width: 100,
                            child: Text(
                              'Maternal Health Dashboard',
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
                          itemCount: _maternalDashbaordMenu.length,
                          itemBuilder: (context, index) {
                            var item = _maternalDashbaordMenu[index];
                            Color bgColor = new Color(int.parse(
                                    item.color.substring(0, 6),
                                    radix: 16) +
                                0xFF000000); 
                            return GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _enabled = true;
                                  agr = '${item.url}';
                                  tit = '${item.name}';
                                });

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => SingleWeb(
                                //           title: '${item.name}',
                                //           url: '${item.url}')),
                                // );
                              },
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
            //   GestureDetector(
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => SingleWeb(
            //                   title: "Demand Procurement Status",
            //                   url:
            //                       "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjM=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1")),
            //         );
            //       },
            //       child: Column(children: [
            //         Container(
            //           height: 50.0,
            //           width: 50.0,
            //           margin: EdgeInsets.all(12.0),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(100.0),
            //             border: Border.all(
            //                 width: 2.0,
            //                 style: BorderStyle.solid,
            //                 color: Color.fromARGB(255, 0, 0, 0)),
            //             color: Colors.blue[100],
            //           ),
            //           child: Center(
            //               child: FaIcon(
            //             FontAwesomeIcons.balanceScale,
            //             size: 25,
            //           )),
            //         ),
            //         Container(
            //             width: 60,
            //             child: Text(
            //               'Demand Procurement Status',
            //               textAlign: TextAlign.center,
            //               overflow: TextOverflow.ellipsis,
            //               maxLines: 2,
            //               style: TextStyle(fontSize: 12),
            //             ))
            //       ])),
            //   GestureDetector(
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => SingleWeb(
            //                   title: 'Common Essential Drugs',
            //                   url:
            //                       "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjQ=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1")),
            //         );
            //       },
            //       child: Column(children: [
            //         Container(
            //           height: 50.0,
            //           width: 50.0,
            //           margin: EdgeInsets.all(12.0),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(100.0),
            //             border: Border.all(
            //                 width: 2.0,
            //                 style: BorderStyle.solid,
            //                 color: Color.fromARGB(255, 0, 0, 0)),
            //             color: Colors.purple[100],
            //           ),
            //           child: Center(
            //               child: FaIcon(
            //             FontAwesomeIcons.table,
            //             size: 25,
            //           )),
            //         ),
            //         Container(
            //             width: 60,
            //             child: Text(
            //               'Common Essential Drugs',
            //               textAlign: TextAlign.center,
            //               overflow: TextOverflow.ellipsis,
            //               maxLines: 2,
            //               style: TextStyle(fontSize: 12),
            //             ))
            //       ])),
            //   GestureDetector(
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => SingleWeb(
            //                   title: "Drug Expiry Details",
            //                   url:
            //                       "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjU=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1")),
            //         );
            //       },
            //       child: Column(children: [
            //         Container(
            //           height: 50.0,
            //           width: 50.0,
            //           margin: EdgeInsets.all(12.0),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(100.0),
            //             border: Border.all(
            //                 width: 2.0,
            //                 style: BorderStyle.solid,
            //                 color: Color.fromARGB(255, 0, 0, 0)),
            //             color: Colors.brown[100],
            //           ),
            //           child: Center(
            //               child: FaIcon(
            //             FontAwesomeIcons.exclamationTriangle,
            //             size: 25,
            //           )),
            //         ),
            //         Container(
            //             width: 60,
            //             child: Text(
            //               'Drug Expiry Details',
            //               textAlign: TextAlign.center,
            //               overflow: TextOverflow.ellipsis,
            //               maxLines: 2,
            //               style: TextStyle(fontSize: 12),
            //             ))
            //       ])),
            //   GestureDetector(
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => SingleWeb(
            //                   title: "Stock Details",
            //                   url:
            //                       "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=NDM=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1")),
            //         );
            //       },
            //       child: Column(children: [
            //         Container(
            //           height: 50.0,
            //           width: 50.0,
            //           margin: EdgeInsets.all(12.0),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(100.0),
            //             border: Border.all(
            //                 width: 2.0,
            //                 style: BorderStyle.solid,
            //                 color: Color.fromARGB(255, 0, 0, 0)),
            //             color: Colors.deepOrange[100],
            //           ),
            //           child: Center(
            //               child: FaIcon(
            //             FontAwesomeIcons.shoppingCart,
            //             size: 25,
            //           )),
            //         ),
            //         Container(
            //             width: 60,
            //             child: Text(
            //               'Stock Details',
            //               textAlign: TextAlign.center,
            //               overflow: TextOverflow.ellipsis,
            //               maxLines: 2,
            //               style: TextStyle(fontSize: 12),
            //             ))
            //       ])),
            //   GestureDetector(
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => SingleWeb(
            //                   title: "State wise RC Expiry Details",
            //                   url:
            //                       "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mjc=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1")),
            //         );
            //       },
            //       child: Column(children: [
            //         Container(
            //           height: 50.0,
            //           width: 50.0,
            //           margin: EdgeInsets.all(12.0),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(100.0),
            //             border: Border.all(
            //                 width: 2.0,
            //                 style: BorderStyle.solid,
            //                 color: Color.fromARGB(255, 0, 0, 0)),
            //             color: Colors.grey[200],
            //           ),
            //           child: Center(
            //               child: FaIcon(
            //             FontAwesomeIcons.compress,
            //             size: 25,
            //           )),
            //         ),
            //         Container(
            //             width: 60,
            //             child: Text(
            //               'State wise RC Expiry Details',
            //               textAlign: TextAlign.center,
            //               overflow: TextOverflow.ellipsis,
            //               maxLines: 2,
            //               style: TextStyle(fontSize: 12),
            //             ))
            //       ])),
            //   GestureDetector(
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => SingleWeb(
            //                   title: "Drugs Excess/Shortage",
            //                   url:
            //                       "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mjg=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1")),
            //         );
            //       },
            //       child: Column(children: [
            //         Container(
            //           height: 50.0,
            //           width: 50.0,
            //           margin: EdgeInsets.all(12.0),
            //           decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(100.0),
            //               border: Border.all(
            //                   width: 2.0,
            //                   style: BorderStyle.solid,
            //                   color: Color.fromARGB(255, 0, 0, 0)),
            //               color: Colors.indigo[100]),
            //           child: Center(
            //               child: FaIcon(
            //             FontAwesomeIcons.chartBar,
            //             size: 25,
            //           )),
            //         ),
            //         Container(
            //             width: 60,
            //             child: Text(
            //               'Drugs Excess/Shortage',
            //               textAlign: TextAlign.center,
            //               overflow: TextOverflow.ellipsis,
            //               maxLines: 2,
            //               style: TextStyle(fontSize: 12),
            //             ))
            //       ])),
            //   GestureDetector(
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => SingleWeb(
            //                   title: "Stock Out Detail V 2.0 old",
            //                   url:
            //                       "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mjk=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1")),
            //         );
            //       },
            //       child: Column(children: [
            //         Container(
            //           height: 50.0,
            //           width: 50.0,
            //           margin: EdgeInsets.all(12.0),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(100.0),
            //             border: Border.all(
            //                 width: 2.0,
            //                 style: BorderStyle.solid,
            //                 color: Color.fromARGB(255, 0, 0, 0)),
            //             color: Color(0xfff7dad9),
            //           ),
            //           child: Center(
            //               child: FaIcon(
            //             FontAwesomeIcons.shoppingCart,
            //             size: 25,
            //           )),
            //         ),
            //         Container(
            //             width: 60,
            //             child: Text(
            //               'Stock Out Detail V 2.0 old',
            //               textAlign: TextAlign.center,
            //               overflow: TextOverflow.ellipsis,
            //               maxLines: 2,
            //               style: TextStyle(fontSize: 12),
            //             ))
            //       ]))
            // ])),
            Expanded(
              // child: SingleChildScrollView(
              //     // padding: EdgeInsets.all(0),
              // controller: _scrollViewController,
              //   child: Container(
              //      height: 1800 ,
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
                        "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mzk=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1",
                    javascriptMode: JavascriptMode.unrestricted,
                    onPageFinished: (finish) {
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                  isLoading
                      ?      Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          children:[
                          CircularProgressIndicator(),
                          Text('Loading Data, please wait...'),
                          ]))
                      : Stack(),
                ],
              ),
                // ))
            )
          ],
        ));
  }
}
