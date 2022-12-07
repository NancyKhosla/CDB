import 'dart:convert';

import 'package:centraldashboardversion4/DynamicFlow/CentralDashboardPage.dart';
import 'package:centraldashboardversion4/DynamicFlow/url.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../adminmenu.dart';
import '../family.dart';
import '../maternal.dart';
import '../ranking.dart';
import '../stock.dart';

class SubMenuPage extends StatefulWidget {
  List<dynamic> subMenuList;
  String menuName;
  String dashboardId;

  SubMenuPage(
      {Key key,
      @required this.subMenuList,
      @required this.menuName,
      @required this.dashboardId})
      : super(key: key);

  @override
  SubMenuPageState createState() => new SubMenuPageState();
}

class SubMenuPageState extends State<SubMenuPage> {
  String rolename;
  String subMenuName = "";
  int _selectedDrawerIndex = 0;

  // ProgressHUD progressHUD;
  List<dynamic> leafMenuList = [];

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rolename = (prefs.getString('uname') ?? "");
      subMenuName = widget.subMenuList[0][2];
    });
  }

  @override
  void initState() {
    // progressHUD = ProgressHUD(
    //   backgroundColor: Colors.black12,
    //   color: Colors.white,
    //   containerColor: Color(0xFF2196F3),
    //   borderRadius: 5.0,
    //   loading: false,
    //   text: 'Loading...',
    // );
    loadData();
    _getLeafMenuList(widget.dashboardId, widget.subMenuList[0][1]);
    super.initState();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<dynamic>> _getLeafMenuList(
      String menuid, String submenuid) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // progressHUD.state.show();
      final formData = jsonEncode({
        "primaryKeys": ['$menuid', '$submenuid']
      });
      print(formData);
      Response response =
          await ioClient.post(M_CHILD_TABS, headers: headers, body: formData);
      if (response.statusCode == 200) {
        // progressHUD.state.dismiss();
        Map<String, dynamic> list = json.decode(response.body);
        setState(() {
          leafMenuList = list["dataValue"];
        });
        if (leafMenuList != null && leafMenuList.length > 0) {
          print("leafMenuList.........." + leafMenuList.length.toString());
          print("leafMenuList.........." + leafMenuList.toString());
        }
      } else {
        // progressHUD.state.dismiss();
        throw Exception('Failed to load data');
      }
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              backgroundColor: Color(0xffffffff),
              title: Text("Please Check your Internet Connection",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xff000000))),
            );
          });
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    if (scaffoldKey.currentState.isDrawerOpen) {
      scaffoldKey.currentState.closeDrawer();
    } else {
      scaffoldKey.currentState.openDrawer();
    }
    subMenuName = widget.subMenuList[index][2];
    _getLeafMenuList(widget.dashboardId, widget.subMenuList[index][1]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            key: scaffoldKey,
            drawer: Drawer(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 150,
                    child: DrawerHeader(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 60.0,
                              height: 60.0,
                              margin: EdgeInsets.fromLTRB(8, 5, 8, 5),
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(200.0),
                                border: Border.all(
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                color: Colors.red[100],
                              ),
                              child: Center(
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 40,
                                  icon: Icon(Icons.bar_chart,
                                      color: Color(0xff000000)),
                                ),
                              ),
                            ),
                            Container(
                                child: Expanded(
                                    child: Text(
                              widget.menuName,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            )))
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffccf2f4),
                        )),
                  ),
                  Expanded(
                    // flex: 1,
                    child: ListView.builder(
                        itemCount: widget.subMenuList.length,
                        itemBuilder: (BuildContext context, i) {
                          return new ListTile(
                            trailing: Icon(Icons.keyboard_arrow_right_sharp),
                            title: new Text(
                              widget.subMenuList[i][2].replaceAll("\"", " "),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xff2c003e),
                                fontFamily: 'Open Sans',
                              ),
                            ),
                            selected: i == _selectedDrawerIndex,
                            onTap: () => _onSelectItem(i),
                          );
                        }),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Color(0xffccf2f4),
              elevation: 0,
              iconTheme: new IconThemeData(color: Colors.black),
              title: Row(children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back),
                ),
                new IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    if (scaffoldKey.currentState.isDrawerOpen) {
                      scaffoldKey.currentState.closeDrawer();
                    } else {
                      scaffoldKey.currentState.openDrawer();
                    }
                  },
                ),
                new Expanded(
                    child: new Text(subMenuName.replaceAll("\"", " "),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Raleway'))),
              ]),
            ),
            body: widget.subMenuList != null && widget.subMenuList.length > 0
                ? _getDrawerItemWidget(_selectedDrawerIndex)
                : Center(child: Text("loading..."))));
  }

  _getDrawerItemWidget(int pos) {
    switch (widget.subMenuList[pos][2]) {
      default:
        if (leafMenuList != null && leafMenuList.length > 0) {
          return CentralDashboardPage(leafMenuList: leafMenuList);
        }
        break;
    }
  }
}
