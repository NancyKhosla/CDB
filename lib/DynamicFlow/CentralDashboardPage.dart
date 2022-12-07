import 'dart:convert';

import 'package:centraldashboardversion4/DynamicFlow/url.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:progress_hud/progress_hud.dart';

class CentralDashboardPage extends StatefulWidget {
  List<dynamic> leafMenuList;

  CentralDashboardPage({Key key, @required this.leafMenuList})
      : super(key: key);

  @override
  CentralDashboardPageState createState() => new CentralDashboardPageState();
}

class CentralDashboardPageState extends State<CentralDashboardPage> {
  List<dynamic> dashboardConfig = [];
  List<dynamic> tabConfig = [];
  List<dynamic> parametersConfig = [];
  List<dynamic> widgetsConfig = [];
  ProgressHUD progressHUD;

  // Future<List<dynamic>> _getDashboardConfiguration(String groupId) async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi) {
  //     progressHUD.state.show();
  //     final formData = jsonEncode({
  //       "primaryKeys": ['$groupId']
  //     });
  //     print(formData);
  //     print(DASHBOARD_CONFIG);
  //     Response response = await ioClient.post(DASHBOARD_CONFIG,
  //         headers: headers, body: formData);
  //     if (response.statusCode == 200) {
  //       // progressHUD.state.dismiss();
  //       Map<String, dynamic> list = json.decode(response.body);
  //       setState(() {
  //         dashboardConfig = list["dataValue"];
  //       });
  //
  //
  //
  //       if ( dashboardConfig != null && dashboardConfig.length > 0) {
  //         print("dashboardConfig.........." + dashboardConfig.length.toString());
  //         print("dashboardConfig.........." + dashboardConfig.toString());
  //         dashboardConfig.forEach((dashconfig) {
  //           print(dashconfig[3]);
  //           print(dashconfig[1]);
  //           String str = dashconfig[1].toString().replaceAll("\"", " ");
  //           String tabid = dashconfig[3].toString().replaceAll("\"", " ");
  //
  //           if (dashconfig[4].toString().isNotEmpty) {
  //             print("4");
  //           } else {
  //             _getTabConfiguration('$tabid');
  //           }
  //         });
  //       }
  //       else{
  //         progressHUD.state.dismiss();
  //       }
  //     } else {
  //       progressHUD.state.dismiss();
  //       throw Exception('Failed to load data');
  //     }
  //   } else {
  //     return showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return const AlertDialog(
  //             backgroundColor: Color(0xffffffff),
  //             title: Text("Please Check your Internet Connection",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(fontSize: 16, color: Color(0xff000000))),
  //           );
  //         });
  //   }
  // }
  //
  // Future<List<dynamic>> _getTabConfiguration(String tabId) async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi) {
  //     // progressHUD.state.show();
  //     final formData = jsonEncode({
  //       "primaryKeys": ['$tabId']
  //     });
  //     print(formData);
  //     Response response =
  //         await ioClient.post(TAB_CONFIG, headers: headers, body: formData);
  //     if (response.statusCode == 200) {
  //       // progressHUD.state.dismiss();
  //       Map<String, dynamic> list = json.decode(response.body);
  //       setState(() {
  //         tabConfig = list["dataValue"];
  //       });
  //
  //
  //       if ( tabConfig != null && tabConfig.length > 0 ) {
  //         print("tabConfig.........." + tabConfig.length.toString());
  //         print("tabConfig.........." + tabConfig.toString());
  //         tabConfig.forEach((tabconfig) {
  //           print(tabconfig[3]);
  //           print(tabconfig[4]);
  //           String parameters = tabconfig[3].toString().replaceAll("\"", " ");
  //           _getParametersConfiguration(parameters);
  //           _getWidgetsConfiguration(tabconfig[4]);
  //         });
  //       }
  //       {
  //         progressHUD.state.dismiss();
  //       }
  //     } else {
  //       progressHUD.state.dismiss();
  //       throw Exception('Failed to load data');
  //     }
  //   } else {
  //     return showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return const AlertDialog(
  //             backgroundColor: Color(0xffffffff),
  //             title: Text("Please Check your Internet Connection",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(fontSize: 16, color: Color(0xff000000))),
  //           );
  //         });
  //   }
  // }
  //
  Future<List<dynamic>> _getParametersConfiguration(
      String parameters, String widgets) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      progressHUD.state.show();

      final formData = jsonEncode({
        "primaryKeys": ['$parameters']
      });
      print(".......");
      print(formData);
      Response response = await ioClient.post(PARAMETERS_CONFIG,
          headers: headers, body: formData);
      if (response.statusCode == 200) {
        // progressHUD.state.dismiss();
        Map<String, dynamic> list = json.decode(response.body);
        setState(() {
          parametersConfig = list["dataValue"];
        });
        if (parametersConfig != null && parametersConfig.length > 0) {
          print("parametersConfig.........." +
              parametersConfig.length.toString());
          print("parametersConfig.........." + parametersConfig.toString());
        }
        _getWidgetsConfiguration(widgets);
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

  Future<List<dynamic>> _getWidgetsConfiguration(String widgtes) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // progressHUD.state.show();
      final formData = jsonEncode({
        "primaryKeys": ['$widgtes']
      });
      print(formData);
      Response response =
          await ioClient.post(M_Widgets, headers: headers, body: formData);
      if (response.statusCode == 200) {
        progressHUD.state.dismiss();
        Map<String, dynamic> list = json.decode(response.body);
        setState(() {
          widgetsConfig = list["dataValue"];
        });

        if (widgetsConfig != null && widgetsConfig.length > 0) {
          print("widgetsConfig.........." + widgetsConfig.length.toString());
          print("widgetsConfig.........." + widgetsConfig.toString());
          widgetsConfig.forEach((widgetConfig) {
            String parentWidgetId =
                widgetConfig[5].toString().replaceAll("\"", " ");
            String linkedWidgetId =
                widgetConfig[6].toString().replaceAll("\"", " ");

            if (parentWidgetId.contains("0") && linkedWidgetId.isNotEmpty) {
              print(" parent" + " \n" + widgetConfig[0]);
            } else {
              print("not parent" + " \n" + widgetConfig[0]);
              print(widgetConfig[5]);
            }
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
      containerColor: Color(0xFF2196F3),
      borderRadius: 5.0,
      loading: false,
      text: 'Loading...',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 2,
            shadowColor: Colors.red[100],
            iconTheme: IconThemeData(color: Colors.black),
            pinned: false,
            expandedHeight: 140,
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
                        margin: EdgeInsets.only(top: 10),
                        height: 140.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: ClampingScrollPhysics(),
                          itemCount: widget.leafMenuList.length,
                          itemBuilder: (context, index) {
                            var obj = widget.leafMenuList[index];
                            return GestureDetector(
                                onTap: () async {
                                  _getParametersConfiguration(
                                      widget.leafMenuList[index][5],
                                      widget.leafMenuList[index][6]);
                                  // _getDashboardConfiguration(
                                  //     widget.leafMenuList[index][0]);
                                },
                                child: Container(
                                    child: Column(children: [
                                  Container(
                                    width: 30.0,
                                    height: 30.0,
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
                                        iconSize: 11,
                                        icon: Icon(getIconForName(obj[3]),
                                            color: Color(0xff000000)),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: 40,
                                      child: Text(
                                        obj[2].replaceAll("\"", " "),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 9, color: Colors.black),
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
      )),
      progressHUD
    ]));
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
}
