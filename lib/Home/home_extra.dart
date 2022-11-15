import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import '../family.dart';
import '../ranking.dart';
import '../stock.dart';
import '../Utils/web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../adminmenu.dart';
import '../Utils/basicAuth.dart';
import '../BarChart/mainchart.dart';
import 'package:flutter/services.dart';
import '../Login/login.dart';
import '../maternal.dart';

class MainItem {
  final String name;
  final String id;

  MainItem({this.name, this.id});
}

class MaternalMainItem {
  final String name;
  final String url;

  MaternalMainItem({this.name, this.url});
}

class DashMenu {
  final String name;
  final String icon;
  DashMenu({this.name, this.icon});
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new GridWidget(),
    );
  }
}

class GridWidget extends StatefulWidget {
  @override
  _GridWidgetState createState() => new _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
//   bool _showAppbar = true; //this is to show app bar
// ScrollController _scrollBottomBarController = new ScrollController(); // set controller on scrolling
// bool isScrollingDown = false;
// bool _show = true;
// double bottomBarHeight = 75; // set bottom bar height
// double _bottomBarOffset = 0;

  String rolename, agr, tit;
  bool _enabled = false;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final key = UniqueKey();

  Future<List<dynamic>> _fetchSuperMenu() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final formData = jsonEncode({
        "primaryKeys": ["363003000000", "10"]
      });
      Response response =
          await ioClient.post(SUPER_MENU_URL, headers: headers, body: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> listid = list["dataValue"];
        return listid;
      } else {
        throw Exception('Failed to load Menu');
      }
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xffffffff),
              title: Text("Please Check your Internet Connection",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xff000000))),
            );
          });
    }
  }

  List<MainItem> _mainitem = List<MainItem>();
  void _populateMainItem() {
    var list = <MainItem>[
      MainItem(
        name: 'Maternal Health Dashboard',
        id: '11',
      ),
      MainItem(name: 'Family Planning Dashboard', id: '13'),
      MainItem(name: 'Stockout V 2.0', id: 'rupee-sign'),
      MainItem(name: 'Monthly State Ranking', id: '14'),
      MainItem(name: 'Admin Dashboard', id: '15'),
      // MainItem(name: '', icon: 'mobile-alt'),
    ];
    setState(() {
      _mainitem = list;
    });
  }

  List<MaternalMainItem> _maternalDashbaordMenu = List<MaternalMainItem>();
  void __maternalDashbaordMenu() {
    var list = <MaternalMainItem>[
      MaternalMainItem(
        name: 'Maternal Healh Dashboard ',
        url:
            'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mzk=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1',
      ),
      MaternalMainItem(
          name: 'Maternal Health Edl Detail',
          url:
              'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=NDA=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1'),
      MaternalMainItem(
          name: 'Stock Detail of Maternal Health',
          url:
              'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mzg=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1'),
      MaternalMainItem(
          name:
              'Rate Contract details for Drugs, with name containing iron or ifa',
          url:
              'https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=NDQ=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1'),
    ];
    setState(() {
      _maternalDashbaordMenu = list;
    });
  }

  List<MainItem> _adminDashbaordMenu = List<MainItem>();
  void __adminDashbaordMenu() {
    var list = <MainItem>[
      MainItem(
        name: 'State DVDMS Performance Report ',
        id: '11',
      ),
      MainItem(name: 'State Rank(Daily)', id: '13'),
      MainItem(name: 'Functional Facilities ', id: 'rupee-sign'),
      MainItem(name: 'Consolidated State Performance', id: '14'),
    ];
    setState(() {
      _adminDashbaordMenu = list;
    });
  }

  // List text = _mainitem.map((f){ return f.name;}).toList();
  ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollViewController = new ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
    });
    setState(() {
      loadData();
    });
    _populateMainItem();
     _dashboardmenufun();
    int value = null;
    int valueI = 1;

    if (value == null) {
      value = valueI;
    }
    int resutsss = value ??= valueI;
    print('teena result: $value');
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _scrollViewController.removeListener(() {});
    super.dispose();
   
  }

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rolename = (prefs.getString('uname') ?? "");
      print('rolename == $rolename');
    });
  }

  bool isLoading = true;
  final _key = UniqueKey();

  List<DashMenu> _dashboardmenu = [];
  void _dashboardmenufun() {
    var list = <DashMenu>[
      DashMenu(name: 'EDL Details',icon: 'briefcaseMedical'),
      DashMenu(name: 'Rate Contract', icon: 'solidHandshake'),
      DashMenu(name: 'Demand Procurement Status', icon: 'balanceScale'),
      DashMenu(name: 'Common Essential Drugs', icon: 'table'),
      DashMenu(name: 'Drug Expiry Details', icon: 'exclamationTriangle'),
      DashMenu(name: 'Stock Details', icon: 'shoppingCart'),
      DashMenu(name: 'State wise RC Expiry Details', icon: 'compress'),
      DashMenu(name: 'Drugs Excess/Shortage', icon: 'chartBar'),
      DashMenu(name: 'Stock Out Detail V 2.0 old', icon: 'shoppingCart'),
      
    ];
    setState(() {
      _dashboardmenu = list;
    });
  }

  IconData getIconForName(String iconName) {
    switch (iconName) {
      case 'briefcaseMedical':
        {
          return FontAwesomeIcons.briefcaseMedical;
        }
        break;
      case 'solidHandshake':
        {
          return FontAwesomeIcons.solidHandshake;
        }
        break;
      case 'balanceScale':
        {
          return FontAwesomeIcons.balanceScale;
        }
        break;
      case 'table':
        {
          return FontAwesomeIcons.table;
        }
        break;
      case 'exclamationTriangle':
        {
          return FontAwesomeIcons.exclamationTriangle;
        }
        break;
      case 'shoppingCart':
        {
          return FontAwesomeIcons.shoppingCart;
        }
        break;
      case 'compress':
        {
          return FontAwesomeIcons.compress;
        }
        break;
      case 'chartBar':
        {
          return FontAwesomeIcons.chartBar;
        }
        break;
        
      default:
        {
          return FontAwesomeIcons.mobileAlt;
        }
    }
  }

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 60.0,
                    child: DrawerHeader(
                        child: Text("Welcome, $rolename",
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.white)),
                        decoration: BoxDecoration(color: Colors.black)),
                  ),
                  ListTile(
                    title: Text("Maternal Health Dashboard"),
                    trailing: Icon(Icons.keyboard_arrow_right_sharp),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MaternalMenu(
                                mname: 'Maternal Health Dashboard'))),
                  ),
                  ListTile(
                    title: Text("Family Planning Dashboard"),
                    trailing: Icon(Icons.keyboard_arrow_right_sharp),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FammilyMenu(
                                mname: 'Family Planning Dashboard'))),
                  ),
                  ListTile(
                    title: Text("Stockout v2.0"),
                    trailing: Icon(Icons.keyboard_arrow_right_sharp),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StockMenu(mname: 'Stockout v2.0'))),
                  ),
                  ListTile(
                    title: Text("Monthly State Ranking"),
                    trailing: Icon(Icons.keyboard_arrow_right_sharp),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RankMenu(mname: 'Monthly State Ranking'))),
                  ),
                  ListTile(
                    title: Text("Admin Dashboard"),
                    trailing: Icon(Icons.keyboard_arrow_right_sharp),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AdminMenu(mname: 'Admin Dashboard'))),
                  ),
                  ListTile(
                    title: Text("Logout"),
                    trailing: Icon(Icons.keyboard_arrow_right_sharp),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove("username");
                      prefs.remove("password");
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new LoginPage()));
                    },
                  ),
                ],
              ),
            ),
            body: SafeArea(
                child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 2,
                  shadowColor: Colors.red[100],
                  iconTheme: IconThemeData(color: Colors.black),
                  pinned: false,
                  expandedHeight: 200,
                  backgroundColor: Color(0xffccf2f4),
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(top: 45),
                    centerTitle: true,
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Container(
                              margin: EdgeInsets.only(top:5),
                              child: Text(
                                'CENTRAL DASHBAORD',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
                              )),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(top:10),
                            height: 130.0,
                            child:  ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: _dashboardmenu.length,
                                  itemBuilder: (context, index) {
                                    var obj = _dashboardmenu[index];
                                    print('bharti $obj');
                                    return Column(children: [
                                      Container(
                                        width: 30.0,
                                        height: 30.0,
                                        margin: EdgeInsets.fromLTRB(8,5,8,5),
                                        padding: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(200.0),
                                          border: Border.all(
                                              width: 1.0,
                                              style: BorderStyle.solid,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                          color: Colors.red[100],
                                        ),
                                        child: Center(
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                            iconSize: 11,
                                            icon: Icon(
                                                getIconForName(obj.icon),
                                                color: Color(0xff000000)),
                                            onPressed: () async {}),),
                                      ),
                                      Container(
                                          width: 40,
                                          child: Text(
                                            obj.name,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 9,
                                                color: Colors.black),
                                          ))
                                    ]);
                                  },
                                )),
                          ),
                          
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Container(height: 1300.0, margin: EdgeInsets.only(top:10), child: Chart()))
              ],
            ))));
    // appBar: AppBar(
    //   backgroundColor: Colors.green,
    //   title: Text('Central Dashboard')),
    // drawer: Drawer(
    //   child: ListView(
    //     // padding: EdgeInsets.zero,
    //     children: <Widget>[
    //       Container(
    //         width: MediaQuery.of(context).size.width * 0.85,
    //         height: 120,
    //         child: DrawerHeader(
    //           decoration: BoxDecoration(color: Color(0xff2d0e3e)),
    //           child: Text("Welcome, $rolename",
    //               style: TextStyle(
    //                   color: Colors.white,
    //                   fontFamily: 'Open Sans',
    //                   fontWeight: FontWeight.w600,
    //                   fontSize: 18)),
    //         ),
    //       ),
    //       Container(
    //           child: SizedBox(
    //               height: 300,
    //               child: ListView.builder(
    //                   physics: ClampingScrollPhysics(),
    //                   itemCount: _mainitem.length,
    //                   itemBuilder: (context, index) {
    //                     var item = _mainitem[index];
    //                     return ListTile(
    //                       onTap: () {
    //                         if (item.name == 'Maternal Health Dashboard') {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) => MaternalMenu(
    //                                       mname: '${item.name}')));
    //                         } else if (item.name ==
    //                             'Family Planning Dashboard') {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) => FammilyMenu(
    //                                       mname: '${item.name}')));
    //                         } else if (item.name == 'Stockout V 2.0') {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) => StockMenu(
    //                                       mname: '${item.name}')));
    //                         } else if (item.name ==
    //                             'Monthly State Ranking') {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) =>
    //                                       RankMenu(mname: '${item.name}')));
    //                         } else {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) => AdminMenu(
    //                                       mname: '${item.name}')));
    //                         }
    //                       },
    //                       title: Text(item.name,
    //                           style: TextStyle(color: Colors.black)),
    //                     );
    //                   }))),
    //       ListTile(
    //         leading: Icon(Icons.exit_to_app, color: Color(0xff2d0e3e)),
    //         title: Text('Logout',
    //             style: TextStyle(
    //                 color: Color(0xff2d0e3e),
    //                 fontSize: 16,
    //                 fontFamily: 'Open Sans',
    //                 fontWeight: FontWeight.w600)),
    //         onTap: () async {
    //           SharedPreferences prefs =
    //               await SharedPreferences.getInstance();
    //           prefs.remove("username");
    //           prefs.remove("password");
    //           Navigator.push(
    //               context,
    //               new MaterialPageRoute(
    //                   builder: (context) => new LoginPage()));
    //         },
    //       )
    //     ],
    //   ),
    // ),
    // body: Column(
    //   children: [
    //     AnimatedContainer(
    //       height: _showAppbar ? 130.0 : 0.0,
    //       duration: Duration(milliseconds: 500),
    //       child: Container(
    //           // height: 120,
    //           decoration: new BoxDecoration(
    //             gradient: LinearGradient(colors: [
    //               Colors.red[200],
    //               Colors.red[200].withOpacity(.7)
    //             ]),
    //           ),
    //           child: ListView(scrollDirection: Axis.horizontal,
    //               // padding: EdgeInsets.all(5.0),
    //               children: [
    //                 GestureDetector(
    //                   onTap: () async {
    //                     setState(() {
    //                       _enabled = true;
    //                       agr =
    //                           "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjE=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1";
    //                       tit = "EDL Details";
    //                     });
    //                   },
    //                   child: Column(children: [
    //                     Container(
    //                       key: Key('eld'),
    //                       height: 50.0,
    //                       width: 50.0,
    //                       margin: EdgeInsets.all(12.0),
    //                       decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(100.0),
    //                         boxShadow: [
    //                           // new BoxShadow(
    //                           //     color: Color.fromARGB(100, 0, 0, 0),
    //                           //     blurRadius: 5.0,
    //                           //     offset: Offset(5.0, 5.0))
    //                         ],
    //                         border: Border.all(
    //                             width: 2.0,
    //                             style: BorderStyle.solid,
    //                             color: Color.fromARGB(255, 0, 0, 0)),
    //                         color: Colors.green[100],
    //                         // image: DecorationImage(
    //                         //     fit: BoxFit.cover,
    //                         //     image: NetworkImage(
    //                         //         "https://cdn.dribbble.com/users/1368/screenshots/1785863/icons_2x.png"))
    //                       ),
    //                       child: Center(
    //                           child: FaIcon(
    //                         FontAwesomeIcons.briefcaseMedical,
    //                         size: 25,
    //                       )),
    //                     ),
    //                     Container(
    //                         width: 60,
    //                         child: Text(
    //                           'EDL Details',
    //                           textAlign: TextAlign.center,
    //                           overflow: TextOverflow.ellipsis,
    //                           maxLines: 2,
    //                           style: TextStyle(fontSize: 12),
    //                         ))
    //                   ]),
    //                 ),
    //                 GestureDetector(
    //                     // onTap: () {
    //                     onTap: () async {
    //                       setState(() {
    //                         _enabled = true;
    //                         agr =
    //                             "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjI=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1";
    //                         tit = "Rate Contract";
    //                       });
    //                       // Navigator.popAndPushNamed(context, '/home');

    //                       //                                 },
    //                       // Navigator.push(
    //                       //   context,
    //                       //   MaterialPageRoute(
    //                       //       builder: (context) => SingleWeb(
    //                       //           title: "Rate Contract",
    //                       //           url:
    //                       //               "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjI=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1")),
    //                       // );
    //                     },
    //                     child: Column(children: [
    //                       Container(
    //                         height: 50.0,
    //                         width: 50.0,
    //                         margin: EdgeInsets.all(12.0),
    //                         decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.circular(100.0),
    //                             border: Border.all(
    //                                 width: 2.0,
    //                                 style: BorderStyle.solid,
    //                                 color: Color.fromARGB(255, 0, 0, 0)),
    //                             color: Colors.amber[100]
    //                             // color: Color(0xfff7dad9),
    //                             ),
    //                         child: Center(
    //                             child: FaIcon(
    //                           FontAwesomeIcons.solidHandshake,
    //                           size: 25,
    //                         )),
    //                       ),
    //                       Container(
    //                           width: 60,
    //                           child: Text(
    //                             'Rate Contract',
    //                             textAlign: TextAlign.center,
    //                             overflow: TextOverflow.ellipsis,
    //                             maxLines: 2,
    //                             style: TextStyle(fontSize: 12),
    //                           ))
    //                     ])),
    //                 GestureDetector(
    //                     onTap: () async {
    //                       setState(() {
    //                         _enabled = true;
    //                         agr =
    //                             "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjM=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1";
    //                         tit = "Demand Procurement Status";
    //                       });
    //                     },
    //                     // onTap: () {
    //                     //   Navigator.push(
    //                     //     context,
    //                     //     MaterialPageRoute(
    //                     //         builder: (context) => SingleWeb(
    //                     //             title: "Demand Procurement Status",
    //                     //             url:
    //                     //                 "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjM=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1")),
    //                     //   );
    //                     // },
    //                     child: Column(children: [
    //                       Container(
    //                         height: 50.0,
    //                         width: 50.0,
    //                         margin: EdgeInsets.all(12.0),
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(100.0),
    //                           border: Border.all(
    //                               width: 2.0,
    //                               style: BorderStyle.solid,
    //                               color: Color.fromARGB(255, 0, 0, 0)),
    //                           color: Colors.blue[100],
    //                         ),
    //                         child: Center(
    //                             child: FaIcon(
    //                           FontAwesomeIcons.balanceScale,
    //                           size: 25,
    //                         )),
    //                       ),
    //                       Container(
    //                           width: 60,
    //                           child: Text(
    //                             'Demand Procurement Status',
    //                             textAlign: TextAlign.center,
    //                             overflow: TextOverflow.ellipsis,
    //                             maxLines: 2,
    //                             style: TextStyle(fontSize: 12),
    //                           ))
    //                     ])),
    //                 GestureDetector(
    //                     onTap: () async {
    //                       setState(() {
    //                         _enabled = true;
    //                         agr =
    //                             "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjQ=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1";
    //                         tit = "Common Essential Drugs";
    //                       });
    //                     },
    //                     // onTap: () {
    //                     //   Navigator.push(
    //                     //     context,
    //                     //     MaterialPageRoute(
    //                     //         builder: (context) => SingleWeb(
    //                     //             title: 'Common Essential Drugs',
    //                     //             url:
    //                     //                 "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjQ=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1")),
    //                     //   );
    //                     // },
    //                     child: Column(children: [
    //                       Container(
    //                         height: 50.0,
    //                         width: 50.0,
    //                         margin: EdgeInsets.all(12.0),
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(100.0),
    //                           border: Border.all(
    //                               width: 2.0,
    //                               style: BorderStyle.solid,
    //                               color: Color.fromARGB(255, 0, 0, 0)),
    //                           color: Colors.purple[100],
    //                         ),
    //                         child: Center(
    //                             child: FaIcon(
    //                           FontAwesomeIcons.table,
    //                           size: 25,
    //                         )),
    //                       ),
    //                       Container(
    //                           width: 60,
    //                           child: Text(
    //                             'Common Essential Drugs',
    //                             textAlign: TextAlign.center,
    //                             overflow: TextOverflow.ellipsis,
    //                             maxLines: 2,
    //                             style: TextStyle(fontSize: 12),
    //                           ))
    //                     ])),
    //                 GestureDetector(
    //                     onTap: () async {
    //                       setState(() {
    //                         _enabled = true;
    //                         agr =
    //                             "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjU=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1";
    //                         tit = "Drug Expiry Details";
    //                       });
    //                     },
    //                     // onTap: () {
    //                     //   Navigator.push(
    //                     //     context,
    //                     //     MaterialPageRoute(
    //                     //         builder: (context) => SingleWeb(
    //                     //             title: "Drug Expiry Details",
    //                     //             url:
    //                     //                 "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjU=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1")),
    //                     //   );
    //                     // },
    //                     child: Column(children: [
    //                       Container(
    //                         height: 50.0,
    //                         width: 50.0,
    //                         margin: EdgeInsets.all(12.0),
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(100.0),
    //                           border: Border.all(
    //                               width: 2.0,
    //                               style: BorderStyle.solid,
    //                               color: Color.fromARGB(255, 0, 0, 0)),
    //                           color: Colors.brown[100],
    //                         ),
    //                         child: Center(
    //                             child: FaIcon(
    //                           FontAwesomeIcons.exclamationTriangle,
    //                           size: 25,
    //                         )),
    //                       ),
    //                       Container(
    //                           width: 60,
    //                           child: Text(
    //                             'Drug Expiry Details',
    //                             textAlign: TextAlign.center,
    //                             overflow: TextOverflow.ellipsis,
    //                             maxLines: 2,
    //                             style: TextStyle(fontSize: 12),
    //                           ))
    //                     ])),
    //                 GestureDetector(
    //                     onTap: () async {
    //                       setState(() {
    //                         _enabled = true;
    //                         agr =
    //                             "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=NDM=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1";
    //                         tit = "Stock Details";
    //                       });
    //                     },
    //                     // onTap: () {
    //                     //   Navigator.push(
    //                     //     context,
    //                     //     MaterialPageRoute(
    //                     //         builder: (context) => SingleWeb(
    //                     //             title: "Stock Details",
    //                     //             url:
    //                     //                 "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=NDM=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1")),
    //                     //   );
    //                     // },
    //                     child: Column(children: [
    //                       Container(
    //                         height: 50.0,
    //                         width: 50.0,
    //                         margin: EdgeInsets.all(12.0),
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(100.0),
    //                           border: Border.all(
    //                               width: 2.0,
    //                               style: BorderStyle.solid,
    //                               color: Color.fromARGB(255, 0, 0, 0)),
    //                           color: Colors.deepOrange[100],
    //                         ),
    //                         child: Center(
    //                             child: FaIcon(
    //                           FontAwesomeIcons.shoppingCart,
    //                           size: 25,
    //                         )),
    //                       ),
    //                       Container(
    //                           width: 60,
    //                           child: Text(
    //                             'Stock Details',
    //                             textAlign: TextAlign.center,
    //                             overflow: TextOverflow.ellipsis,
    //                             maxLines: 2,
    //                             style: TextStyle(fontSize: 12),
    //                           ))
    //                     ])),
    //                 GestureDetector(
    //                     onTap: () async {
    //                       setState(() {
    //                         _enabled = true;
    //                         agr =
    //                             "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mjc=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1";
    //                         tit = "State wise RC Expiry Details";
    //                       });
    //                     },
    //                     // onTap: () {
    //                     //   Navigator.push(
    //                     //     context,
    //                     //     MaterialPageRoute(
    //                     //         builder: (context) => SingleWeb(
    //                     //             title: "State wise RC Expiry Details",
    //                     //             url:
    //                     //                 "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mjc=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1")),
    //                     //   );
    //                     // },
    //                     child: Column(children: [
    //                       Container(
    //                         height: 50.0,
    //                         width: 50.0,
    //                         margin: EdgeInsets.all(12.0),
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(100.0),
    //                           border: Border.all(
    //                               width: 2.0,
    //                               style: BorderStyle.solid,
    //                               color: Color.fromARGB(255, 0, 0, 0)),
    //                           color: Colors.grey[200],
    //                         ),
    //                         child: Center(
    //                             child: FaIcon(
    //                           FontAwesomeIcons.compress,
    //                           size: 25,
    //                         )),
    //                       ),
    //                       Container(
    //                           width: 60,
    //                           child: Text(
    //                             'State wise RC Expiry Details',
    //                             textAlign: TextAlign.center,
    //                             overflow: TextOverflow.ellipsis,
    //                             maxLines: 2,
    //                             style: TextStyle(fontSize: 12),
    //                           ))
    //                     ])),
    //                 GestureDetector(
    //                     onTap: () async {
    //                       setState(() {
    //                         _enabled = true;
    //                         agr =
    //                             "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mjg=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1";
    //                         tit = "Drugs Excess/Shortage";
    //                       });
    //                     },
    //                     // onTap: () {
    //                     //   Navigator.push(
    //                     //     context,
    //                     //     MaterialPageRoute(
    //                     //         builder: (context) => SingleWeb(
    //                     //             title: "Drugs Excess/Shortage",
    //                     //             url:
    //                     //                 "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mjg=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1")),
    //                     //   );
    //                     // },
    //                     child: Column(children: [
    //                       Container(
    //                         height: 50.0,
    //                         width: 50.0,
    //                         margin: EdgeInsets.all(12.0),
    //                         decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.circular(100.0),
    //                             border: Border.all(
    //                                 width: 2.0,
    //                                 style: BorderStyle.solid,
    //                                 color: Color.fromARGB(255, 0, 0, 0)),
    //                             color: Colors.indigo[100]),
    //                         child: Center(
    //                             child: FaIcon(
    //                           FontAwesomeIcons.chartBar,
    //                           size: 25,
    //                         )),
    //                       ),
    //                       Container(
    //                           width: 60,
    //                           child: Text(
    //                             'Drugs Excess/Shortage',
    //                             textAlign: TextAlign.center,
    //                             overflow: TextOverflow.ellipsis,
    //                             maxLines: 2,
    //                             style: TextStyle(fontSize: 12),
    //                           ))
    //                     ])),
    //                 GestureDetector(
    //                     onTap: () async {
    //                       setState(() {
    //                         _enabled = true;
    //                         agr =
    //                             "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mjk=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1";
    //                         tit = "Stock Out Detail V 2.0 old";
    //                       });
    //                     },
    //                     // onTap: () {
    //                     //   Navigator.push(
    //                     //     context,
    //                     //     MaterialPageRoute(
    //                     //         builder: (context) => SingleWeb(
    //                     //             title: "Stock Out Detail V 2.0 old",
    //                     //             url:
    //                     //                 "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=Mjk=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1")),
    //                     //   );
    //                     // },
    //                     child: Column(children: [
    //                       Container(
    //                         height: 50.0,
    //                         width: 50.0,
    //                         margin: EdgeInsets.all(12.0),
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(100.0),
    //                           border: Border.all(
    //                               width: 2.0,
    //                               style: BorderStyle.solid,
    //                               color: Color.fromARGB(255, 0, 0, 0)),
    //                           color: Color(0xfff7dad9),
    //                         ),
    //                         child: Center(
    //                             child: FaIcon(
    //                           FontAwesomeIcons.shoppingCart,
    //                           size: 25,
    //                         )),
    //                       ),
    //                       Container(
    //                           width: 60,
    //                           child: Text(
    //                             'Stock Out Detail V 2.0 old',
    //                             textAlign: TextAlign.center,
    //                             overflow: TextOverflow.ellipsis,
    //                             maxLines: 2,
    //                             style: TextStyle(fontSize: 12),
    //                           ))
    //                     ]))
    //               ])),
    //     ),
    //     Expanded(
    //         child: SingleChildScrollView(
    //             // padding: EdgeInsets.all(0),
    //             controller: _scrollViewController,
    //             child: Container(
    //                 height: 500,
    //                 // child: _enabled
    //                 //     ? Container(
    //                 //         child: SingleWeb(url: agr, title: tit),
    //                 //       )
    //                     // :
    //                      child: Chart()
    //                   //   Stack(
    //                   //     children: [
    //                   //       WebView(
    //                   //         // controller: scrollcontroller
    //                   //         initialUrl:
    //                   //             "https://cdashboard.dcservices.in/HISUtilities/dashboard/dashBoardACTION.cnt?groupId=MjE=&dashboardFor=Q0VOVFJBTCBEQVNIQk9BUkQ=&hospitalCode=998&seatId=10001&isGlobal=1",
    //                   //         javascriptMode: JavascriptMode.unrestricted,
    //                   //         key: key,
    //                   //         onWebViewCreated:
    //                   //             (WebViewController webViewController) {
    //                   //           _controller.complete(webViewController);
    //                   //           // ignore: unnecessary_statements
    //                   //           //  scrollcontroller;
    //                   //         },
    //                   //         onPageStarted: (String url) {},
    //                   //         onPageFinished: (finish) {
    //                   //           setState(() {
    //                   //             isLoading = false;
    //                   //           });
    //                   //         },
    //                   //         gestureNavigationEnabled: true,
    //                   //       ),
    //                   //       isLoading
    //                   //           ?
    //                   //          Center(child: Column(
    //                   //   mainAxisAlignment: MainAxisAlignment.center,
    //                   //   crossAxisAlignment: CrossAxisAlignment.center,
    //                   // children:[
    //                   // CircularProgressIndicator(),
    //                   // Text('Loading Data, please wait...'),
    //                   // ]))
    //                   //           : Stack(),
    //                   //     ])
    //                       )
    //                       ))
    //   ],
    // ));
  }
}
