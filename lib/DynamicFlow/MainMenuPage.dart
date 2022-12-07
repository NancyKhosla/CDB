import 'dart:convert';

import 'package:centraldashboardversion4/DynamicFlow/url.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Login/login.dart';
import 'SubMenuPage.dart';

class MainMenuPage extends StatefulWidget {
  @override
  MainMenuPageState createState() => new MainMenuPageState();
}

class MainMenuPageState extends State<MainMenuPage> {
  ProgressHUD progressHUD;
  List<dynamic> mainMenuList = [];
  List<dynamic> subMenuList = [];
  String rolename = "";

  Future<List<dynamic>> _getMainMenuList() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      progressHUD.state.show();
      final formData = jsonEncode({
        "primaryKeys": ["10001"]
      });
      print(formData);
      Response response =
          await ioClient.post(M_MENU, headers: headers, body: formData);
      if (response.statusCode == 200) {
        progressHUD.state.dismiss();
        Map<String, dynamic> list = json.decode(response.body);
        setState(() {
          mainMenuList = list["dataValue"];
        });

        if ( mainMenuList != null && mainMenuList.length > 0 ) {
          print("mainMenuList.........." + mainMenuList.length.toString());
          print("mainMenuList.........." + mainMenuList.toString());
        }

      } else {
        progressHUD.state.dismiss();
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

  Future<List<dynamic>> _getSubMenuList(String dashboardGroupId, String menuName) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      progressHUD.state.show();
      final formData = jsonEncode({
        "primaryKeys": ['$dashboardGroupId']
      });
      print(formData);
      Response response =
          await ioClient.post(M_PARENT_TABS, headers: headers, body: formData);
      if (response.statusCode == 200) {
        progressHUD.state.dismiss();
        Map<String, dynamic> list = json.decode(response.body);
        setState(() {
          subMenuList = list["dataValue"];
        });
        if ( subMenuList != null && subMenuList.length > 0 ) {
          print("subMenuList.........." + subMenuList.length.toString());
          print("subMenuList.........." + subMenuList.toString());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SubMenuPage(subMenuList: subMenuList, menuName: menuName,dashboardId: dashboardGroupId,)));
        }else{
          progressHUD.state.dismiss();
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  backgroundColor: Color(0xffffffff),
                  title: Text("No Data found",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Color(0xff000000))),
                );
              });
        }





      } else {
        progressHUD.state.dismiss();
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

  @override
  void initState() {
    progressHUD = ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor:Color(0xFF2196F3),
      borderRadius: 5.0,
      loading: true,
      text: 'Loading...',
    );
    loadData();
    _getMainMenuList();

    super.initState();
  }

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rolename = (prefs.getString('uname') ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildBar(context),
        body: Stack(children: <Widget>[

          SizedBox(
              height: 1200,
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                    appBar: PreferredSize(
                        preferredSize: Size.fromHeight(50),
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0.0,
                          bottom: PreferredSize(
                            preferredSize: new Size(50.0, 50.0),
                            child: Container(
                                width: 230,
                                child: TabBar(
                                  unselectedLabelColor: Colors.black,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.red[100]),
                                  indicatorColor: Color(0xff000000),
                                  indicatorWeight: 1,
                                  labelColor: Color(0xff000000),
                                  tabs: [
                                    Container(
                                        width: 100,
                                        height: 40,
                                        child: Tab(
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.list),
                                              Container(
                                                margin: EdgeInsets.only(left: 8),
                                                child: Text('List '),
                                              ),
                                            ],
                                          ),
                                        )),
                                    Container(
                                        width: 100,
                                        height: 40,
                                        child: Tab(
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.grid_3x3_sharp),
                                              Container(
                                                margin: EdgeInsets.only(left: 8),
                                                child: Text('Grid'),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                )),
                          ),
                        )),
                    body: Container(
                      child: TabBarView(children: [
                        Container(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: ClampingScrollPhysics(),
                            itemCount: mainMenuList.length,
                            itemBuilder: (context, index) {
                              var obj = mainMenuList[index];
                              return GestureDetector(
                                  onTap: () async {
                                    _getSubMenuList( mainMenuList[index][3], mainMenuList[index][1] );
                                  },
                                  child: Container(
                                      padding:const EdgeInsets.all(10),
                                      child: Column(children: [
                                        Container(

                                            child: Card(
                                                color: Color(0xffccf2f4),
                                                elevation: 10,
                                                child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        margin: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                                        padding: EdgeInsets.zero,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(200.0),
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
                                                          child: Text(
                                                            mainMenuList[index][1],
                                                            textAlign: TextAlign.center,
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                fontSize: 15, color: Colors.black),
                                                          ))
                                                    ])))
                                      ])));
                            },
                          )
                           ),
                        Container(
                            child: GridView.builder(
                                padding: const EdgeInsets.all(10),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.75,
                                    crossAxisSpacing: 5),
                                itemCount: mainMenuList.length,
                                itemBuilder: (BuildContext context, int index) =>
                                    GestureDetector(
                                        onTap: () {
                                          _getSubMenuList( mainMenuList[index][3], mainMenuList[index][1] );
                                        },
                                        child: Card(
                                          color: Color(0xffccf2f4),
                                          elevation: 10,
                                          child: Center(
                                            child: Container(
                                                child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        width: 60.0,
                                                        height: 60.0,
                                                        margin: EdgeInsets.fromLTRB(8, 5, 8, 5),
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
                                                            iconSize: 40,
                                                            icon: Icon(Icons.bar_chart,
                                                                color: Color(0xff000000)),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                          child: Text(
                                                            mainMenuList[index][1],
                                                            textAlign: TextAlign.center,
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                fontSize: 15, color: Colors.black),
                                                          ))
                                                    ])),
                                          ),
                                        )))
                            ),
                      ]),
                    )),
              )),
          progressHUD
        ]));
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xffccf2f4),
      iconTheme: new IconThemeData(color: Colors.black),
      title: _buildTitle(context),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.logout),
          color: Colors.black,
          // The "-" icon
          onPressed: () async {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                    child: AlertDialog(
                      backgroundColor: Color(0xffffffff),
                      title: const Text("Are you sure you want to logout ?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, color: Color(0xff000000))),
                      actions: <Widget>[
                        TextButton(
                          child: new Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: new Text("Logout"),
                          onPressed: () async {
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
                    onWillPop: () async {
                      return false;
                    },
                  );
                });
          }, // The `_decrementCounter` function
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return InkWell(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'DVDMS CENTRAL DASHBOARD',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Raleway'),
                  ),
                  Text(
                    'Welcome  ' + rolename,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Raleway'),
                  ),
                ],
              )),
            ],
          )),
    );
  }
}
