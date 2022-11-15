// import 'dart:convert';
// import '../Utils/basicAuth.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class demo extends StatefulWidget {
//   final String bhead, dId, dyear;
//
//   demo(
//       {Key key, @required this.bhead, @required this.dId, @required this.dyear})
//       : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => ChartTabState();
// }
//
// class ChartTabState extends State<demo> {
//   String _id;
//   Future<List<dynamic>> myedlist;
//   List<dynamic> graphDisplayList = [];
//   List<dynamic> userid = [];
//   String tit='Rate Contract';
//
//   @override
//   void initState() {
//     print("chart called...");
//
//     super.initState();
//     myedlist = _fetchMainMenu();
//   }
//
//   final Color leftBarColor = const Color(0xff64dfdf);
//   final Color rightBarColor = const Color(0xffff9292);
//   final Color thirdBarColor = const Color(0xffffc478);
//   final double width = 5;
//
//   Future<List<dynamic>> _fetchMainMenu() async {
//     String url;
//     var filtervalue, filterid;
//     switch (tit) {
//       case 'EDL Details':
//         url = EDL_URL;
//         filterid = '';
//         filtervalue = '';
//         break;
//       case 'Rate Contract':
//         url = RATE_URL;
//         filterid = '64';
//         filtervalue = '21191037';
//         break;
//       case 'Demand Procurement Status':
//         url = DEMAND_URL;
//         filterid = '64';
//         filtervalue = '2020-2021';
//         break;
//     }
//
//     try {
//       var connectivityResult = await (Connectivity().checkConnectivity());
//       if (connectivityResult == ConnectivityResult.mobile ||
//           connectivityResult == ConnectivityResult.wifi) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         _id = (prefs.getString('username') ?? "");
//         final formData = jsonEncode({
//           "seatId": "$_id",
//           "filterIds": [filterid],
//           "filterValues": [filtervalue]
//         });
//
//         print("abc..." + formData);
//         print("url " + url);
//
//         Response response =
//         await ioClient.post(url, headers: headers, body: formData);
//         if (response.statusCode == 200) {
//           Map<String, dynamic> list = json.decode(response.body);
//           graphDisplayList.clear();
//
//           List<dynamic> userid1 = list["dataValue"];
//           setState(() {
//             graphDisplayList = userid1;
//           });
//
//
//           print(graphDisplayList.length.toString() + "\n" + graphDisplayList.toString());
//
//
//           return userid1;
//         } else {
//           throw Exception('Failed to load Menu');
//         }
//       } else {
//         return showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 backgroundColor: Color(0xffffffff),
//                 title: Text("Please Check your Internet Connection",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 16, color: Color(0xff000000))),
//               );
//             });
//       }
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }
//
//   int touchedIndex;
//   final Color barBackgroundColor = const Color(0xff72d8bf);
//   List<int> showTooltips = const [];
//
//
//
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Container(
//                 margin: const EdgeInsets.only(top: 30),
//                 child: Container(
//                     width: 900,
//                     height: 400,
//                     child: AspectRatio(
//                       aspectRatio: 1,
//                       child: Card(
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(4)),
//                         color: const Color(0xff232d37),
//                         child: Padding(
//                           padding: const EdgeInsets.all(6),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.max,
//                             children: <Widget>[
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: <Widget>[
//                                   Container(
//                                       margin: EdgeInsets.all(10),
//                                       child: IconButton(
//                                           icon: Icon(
//                                             Icons.fullscreen,
//                                             color: Colors.white,
//                                           ),
//                                           onPressed: () {
//                                             // showMyDialog(context);
//                                           })),
//                                   const SizedBox(
//                                     width: 38,
//                                   ),
//                                   const Text(
//                                     'State Wise Essential Drugs Count',
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 18),
//                                   ),
//                                   const SizedBox(
//                                     width: 4,
//                                   ),
//                                 ],
//                               ),
//
//                               Expanded(child: Container(
//                                   margin: EdgeInsets.all(10),
//                                   child: BarChart(
//
//
//                                     BarChartData(
//
//                                         alignment: BarChartAlignment
//                                             .spaceEvenly,
//                                         // minY: 0,
//                                         // maxY: 1000,
//                                         axisTitleData:
//                                         FlAxisTitleData(
//                                             leftTitle: AxisTitle(
//                                               showTitle: true,
//                                               margin: 12,
//                                               titleText:
//                                               'Essntials Drugs Count(in no.)',
//                                               textStyle: TextStyle(
//                                                   color: Color(
//                                                       0xffffffff)),
//                                             ),
//                                             bottomTitle: AxisTitle(
//                                                 showTitle: true,
//                                                 titleText:
//                                                 'States',
//                                                 margin: 12,
//                                                 textStyle: TextStyle(
//                                                     color: Color(
//                                                         0xffffffff)))),
//                                         titlesData: FlTitlesData(
//                                           show: true,
//                                           bottomTitles: SideTitles(
//                                             rotateAngle: 60,
//                                             showTitles: true,
//                                             margin: 20,
//                                             getTextStyles: (
//                                                 value) =>
//                                             const TextStyle(
//                                                 color: Color(
//                                                     0xffaaaaaa)),
//                                             getTitles:
//                                                 (double value) {
//                                               var _list = [];
//
//                                               graphDisplayList.map((e) {
//                                                 _list.add(e[1]);
//                                               }).toList();
//
//                                               switch (value
//                                                   .toInt()) {
//                                                 case -1:
//                                                   return '';
//                                                 default:
//                                                   return _list[
//                                                   value.toInt()];
//                                               }
//                                             },
//                                           ),
//                                           leftTitles: SideTitles(
//                                             showTitles: true,
//                                             getTextStyles: (
//                                                 value) =>
//                                             const TextStyle(
//                                                 color: Color(
//                                                     0xffaaaaaa)),
//                                             getTitles: (value) {
//                                               return '${value
//                                                   .toInt()}';
//                                             },
//                                             interval: 200,
//                                             margin: 5,
//                                           ),
//                                         ),
//                                         gridData: FlGridData(
//                                           show: true,
//                                           checkToShowHorizontalLine:
//                                               (value) =>
//                                           value % 5 == 0,
//                                           getDrawingHorizontalLine:
//                                               (value) =>
//                                               FlLine(
//                                                 color:
//                                                 Color(
//                                                     (0xff37434d)),
//                                                 strokeWidth: 1,
//                                               ),
//                                         ),
//                                         borderData: FlBorderData(
//                                           show: false,
//                                         ),
//                                         groupsSpace: 5,
//                                         barGroups: graphDisplayList.map((
//                                             e) {
//                                           List<String> _list = [];
//                                           for (int i = 0; i <
//                                               e.length; i++)
//                                             _list.add(e[i]);
//                                           // new _list(e);
//
//                                           switch ('${widget
//                                               .bhead}') {
//                                             case 'EDL Details':
//                                               return BarChartGroupData(
//                                                   x: graphDisplayList
//                                                       .indexOf(e),
//                                                   barRods: [
//                                                     BarChartRodData(
//                                                         width:
//                                                         width,
//                                                         colors: [
//                                                           leftBarColor
//                                                         ],
//                                                         y: double
//                                                             .parse(
//                                                             e[
//                                                             3])),
//                                                     BarChartRodData(
//                                                         width:
//                                                         width,
//                                                         colors: [
//                                                           leftBarColor
//                                                         ],
//                                                         y: double
//                                                             .parse(
//                                                             e[
//                                                             4])),
//                                                     BarChartRodData(
//                                                         width:
//                                                         width,
//                                                         colors: [
//                                                           leftBarColor
//                                                         ],
//                                                         y: double
//                                                             .parse(
//                                                             e[
//                                                             5])),
//                                                   ]);
//                                               break;
//                                             case 'Rate Contract':
//                                               return BarChartGroupData(
//                                                   x: graphDisplayList
//                                                       .indexOf(e),
//                                                   barRods: [
//                                                     BarChartRodData(
//                                                         width:
//                                                         width,
//                                                         colors: [
//                                                           leftBarColor
//                                                         ],
//                                                         y: double
//                                                             .parse(
//                                                             e[3])),
//                                                   ]);
//                                               break;
//                                             case 'Demand Procurement Status':
//                                               return BarChartGroupData(
//                                                   x: graphDisplayList
//                                                       .indexOf(
//                                                       e),
//                                                   barRods: [
//                                                     BarChartRodData(
//                                                         width:
//                                                         width,
//                                                         colors: [
//                                                           leftBarColor
//                                                         ],
//                                                         y: double
//                                                             .parse(
//                                                             e[4])),
//                                                   ]);
//                                               break;
//                                             default:
//                                               BarChartGroupData(
//                                                   x: 0,
//                                                   barRods: []);
//                                               break;
//                                           }
//
//                                         }).toList()),
//                                   ))),
//
//
//                               const SizedBox(
//                                 height: 12,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ))))
//       ],
//     );
//   }
// }
