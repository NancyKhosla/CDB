
import 'dart:convert';
import 'dart:ffi';


import 'package:centraldashboardversion4/DynamicFlow/url.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart';

import '../family.dart';
import '../ranking.dart';
import '../stock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../adminmenu.dart';
import '../BarChart/mainchart.dart';
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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Central Dashboard',
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
  String rolename, agr, tit;
  final key = UniqueKey();
  bool isScrollingDown = false;
  bool _enabled = false;
  List<dynamic> dashboardConfigData= [];
  @override
  void initState() {
    super.initState();
    setState(() {
      loadData();
    });
    _dashboardmenufun();
    _getDashboardConfifuration();
    tit = 'EDL Details';
  }

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rolename = (prefs.getString('uname') ?? "");
    });
  }

  Future<dynamic> _getDashboardConfifuration() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      final formData = jsonEncode({"primaryKeys" : ['$dashboard_id']});
      Response response = await ioClient.post(DASHBOARD_CONFIG, headers: headers, body: formData);
      print(formData);
      print(DASHBOARD_CONFIG);
      print(response.statusCode);
      if(response.statusCode == 200){
        Map<String, dynamic> list = json.decode(response.body);
        print(list);
        dashboardConfigData = list["dataValue"];
        if( list["dataValue"] != null){

          print("dashboardConfigData length..." + dashboardConfigData.length.toString());
          print(dashboardConfigData[0]);

        } else {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Color(0xffffffff),
                  title: Text("Dashboard configrations not valid!", textAlign: TextAlign.center, style: TextStyle(fontSize:13, color: Color(0xff000000))),
                  actions: <Widget>[
                    new TextButton(
                      child: new Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );});
        }
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xffffffff),
              title: Text("Please Check your Internet Connection", textAlign: TextAlign.center,  style: TextStyle(fontSize:16, color: Color(0xff000000))),
            );});
    }
  }





  bool isLoading = true;

  List<DashMenu> _dashboardmenu = [];
  void _dashboardmenufun() {
    var list = <DashMenu>[
      DashMenu(name: 'EDL Details', icon: 'briefcaseMedical'),
      DashMenu(name: 'Rate Contract', icon: 'solidHandshake'),
      DashMenu(name: 'Demand Procurement Status', icon: 'balanceScale'),
      DashMenu(name: 'Common Essential Drugs', icon: 'table'),
      DashMenu(name: 'Drug Expiry Details', icon: 'exclamationTriangle'),
      DashMenu(name: 'Stock Details', icon: 'shoppingCart'),
      DashMenu(name: 'State wise RC Expiry Details', icon: 'compress'),
      DashMenu(name: 'Drugs Excess/Shortage', icon: 'chartBar'),
      DashMenu(name: 'Stock Out Detail V 2.0', icon: 'shoppingCart'),
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
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    'CENTRAL DASHBAORD',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13),
                                  )),
                            ),

                            Flexible(
                              flex: 1,
                              child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 130.0,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: dashboardConfigData.length,
                                    itemBuilder: (context, index) {
                                      var obj = dashboardConfigData[index];
                                      return GestureDetector(
                                          onTap: () async {
                                          },
                                          child: Container(
                                              child: Column(children: [
                                                Container(
                                                  width: 30.0,
                                                  height: 30.0,
                                                  margin:
                                                  EdgeInsets.fromLTRB(8, 5, 8, 5),
                                                  padding: EdgeInsets.zero,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(200.0),
                                                    border: Border.all(
                                                        width: 1.0,
                                                        style: BorderStyle.solid,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0)),
                                                    color: Colors.red[100],
                                                  ),
                                                ),
                                                Container(
                                                    width: 40,
                                                    child: Text(
                                                    obj[0],
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: 9,
                                                          color: Colors.black),
                                                    ))
                                              ])));
                                    },
                                  )),
                            ),


                          ],
                        ),
                      ),
                    ),
                  ],
                ))));
  }
}
