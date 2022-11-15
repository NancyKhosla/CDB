import 'dart:convert';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/basicAuth.dart';

class LineChartDeamnd extends StatefulWidget {
  final String bhead, dId, dyear;

  LineChartDeamnd(
      {Key key, @required this.bhead, @required this.dId, @required this.dyear})
      : super(key: key);

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChartDeamnd> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  List<Color> gradientColors1 = [
    const Color(0xfff56a79),
    const Color(0xffebd4d4),
  ];
  List<Color> gradientColors2 = [
    const Color(0xffffc75f),
    const Color(0xffffefa0),
  ];

  bool showAvg = false;
  String _id;

  // Future<dynamic> _fetchMainMenu() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     _id = (prefs.getString('username') ?? "");
  //     final formData = jsonEncode({
  //       "primaryKeys": ['$_id']
  //     });
  //     print(formData);
  //     Response response =
  //         await ioClient.post(EDL_URL, headers: headers, body: formData);
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> list = json.decode(response.body);
  //       List<dynamic> userid = list["dataValue"];
  //       print(userid.toString());
  //
  //       return userid;
  //     } else {
  //       throw Exception('Failed to load Menu');
  //     }
  //   } else {
  //     return showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             backgroundColor: Color(0xffffffff),
  //             title: Text("Please Check your Internet Connection",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(fontSize: 16, color: Color(0xff000000))),
  //           );
  //         });
  //   }
  // }
  Future<List<dynamic>> _fetchMainMenu() async {
    String url;
    print('${widget.bhead}');
    print('${widget.dId}');
    print('${widget.dyear}');

    switch ('${widget.bhead}') {
      case 'EDL Details':
        url = EDL_URL;
        break;
      case 'Rate Contract':
        url = RATE_URL;
        break;
      case 'Demand Procurement Status':
        url = DEMAND_URL;
        break;
    }
    var _d;
    if ('${widget.dId}' == null) {
      _d = '21191037';
    } else {
      _d = '${widget.dId}';
    }

    var _dy;
    if ('${widget.dyear}' == null) {
      _dy = '2020-2021';
    } else {
      _dy = '${widget.dyear}';
    }

    var filtervalue, filterid;
    switch ('${widget.bhead}') {
      case 'EDL Details':
        filterid = '';
        filtervalue = '';
        break;
      case 'Rate Contract':
        filterid = '64';
        filtervalue = _d;
        break;
      case 'Demand Procurement Status':
        filterid = '65';
        filtervalue = _dy;
        break;
    }
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _id = (prefs.getString('username') ?? "");
        final formData = jsonEncode({
          "seatId": "$_id",
          "filterIds": [filterid],
          "filterValues": [filtervalue]
        });

        print("abc..." + formData);
        print("url " + url);

        Response response =
            await ioClient.post(url, headers: headers, body: formData);
        if (response.statusCode == 200) {
          Map<String, dynamic> list = json.decode(response.body);

          List<dynamic> userid1 = list["dataValue"];
          // setState(() {
          //   graphDisplayList = userid1;
          // });
          //
          //
          // print(graphDisplayList.length.toString());

          return userid1;
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
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMainMenu();
  }

  showMyDialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return RotatedBox(
              quarterTurns: 1,
              child: Hero(
                  transitionOnUserGestures: true,
                  tag: 'halfcard',
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Card(
                        elevation: 1,
                        // margin: EdgeInsets.only(top: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        color: const Color(0xff232d37),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.all(10),
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.fullscreen_exit_outlined,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          })),
                                  const SizedBox(
                                    width: 38,
                                  ),
                                  const Text(
                                    'State Wise Essential Drugs Count',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                ],
                              ),
                              FutureBuilder<dynamic>(
                                  future: _fetchMainMenu(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.hasData) {
                                      List<dynamic> object = snapshot.data;
                                      return Container(
                                          margin: EdgeInsets.fromLTRB(
                                              10, 15, 10, 15),
                                          child: LineChart(LineChartData(
                                              minY: 0,
                                              maxY: 1000,
                                              axisTitleData: FlAxisTitleData(
                                                  leftTitle: AxisTitle(
                                                    showTitle: true,
                                                    margin: 12,
                                                    titleText:
                                                        'Essntials Drugs Count(in no.)',
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xffffffff)),
                                                  ),
                                                  bottomTitle: AxisTitle(
                                                      showTitle: true,
                                                      titleText: 'States',
                                                      margin: 12,
                                                      textStyle: TextStyle(
                                                          color: Color(
                                                              0xffffffff)))),
                                              gridData: FlGridData(
                                                show: true,
                                                drawVerticalLine: true,
                                                getDrawingHorizontalLine:
                                                    (value) {
                                                  return FlLine(
                                                    color:
                                                        const Color(0xff37434d),
                                                    strokeWidth: 1,
                                                  );
                                                },
                                                getDrawingVerticalLine:
                                                    (value) {
                                                  return FlLine(
                                                    color:
                                                        const Color(0xff37434d),
                                                    strokeWidth: 1,
                                                  );
                                                },
                                              ),
                                              titlesData: FlTitlesData(
                                                show: true,
                                                bottomTitles: SideTitles(
                                                  // margin:20,
                                                  rotateAngle: 90,
                                                  showTitles: true,
                                                  reservedSize: 22,
                                                  getTextStyles: (value) =>
                                                      const TextStyle(
                                                          color:
                                                              Color(0xff68737d),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                  getTitles: (double value) {
                                                    var _list = [];
                                                    object.map((e) {
                                                      // setState(() {
                                                      _list.add((e[1]
                                                          .substring(0, 3)
                                                          .toUpperCase()));
                                                      // });
                                                    }).toList();

                                                    switch (value.toInt()) {
                                                      case -1:
                                                        return '';
                                                      // case 0:
                                                      //   return 'AP';
                                                      // case 1:
                                                      //   return 'AR';
                                                      // case
                                                      default:
                                                        return _list[
                                                            value.toInt()];
                                                    }

                                                    // value.toString();
                                                  },
                                                  margin: 8,
                                                ),
                                                leftTitles: SideTitles(
                                                    showTitles: true,
                                                    getTextStyles: (value) =>
                                                        const TextStyle(
                                                          color:
                                                              Color(0xff67727d),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                    getTitles: (value) {
                                                      return '${value.toInt()}';
                                                    },
                                                    reservedSize: 28,
                                                    margin: 12,
                                                    interval: 200),
                                              ),
                                              borderData: FlBorderData(
                                                  show: true,
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xff37434d),
                                                      width: 1)),
                                              lineBarsData: [
                                                LineChartBarData(
                                                  spots: [
                                                    FlSpot(0, 268),
                                                    FlSpot(1, 552),
                                                    FlSpot(2, 457),
                                                    FlSpot(3, 502),
                                                    FlSpot(4, 282),
                                                    FlSpot(5, 713),
                                                    FlSpot(6, 690),
                                                    FlSpot(7, 775),
                                                    FlSpot(8, 171),
                                                    FlSpot(9, 349),
                                                    FlSpot(10, 658),
                                                    FlSpot(11, 800),
                                                    FlSpot(12, 231),
                                                    FlSpot(13, 199),
                                                    FlSpot(14, 425),
                                                    FlSpot(15, 245),
                                                    FlSpot(16, 260),
                                                    FlSpot(17, 204),
                                                    FlSpot(18, 827),
                                                    FlSpot(19, 89),
                                                    FlSpot(20, 0),
                                                    FlSpot(21, 828),
                                                    FlSpot(22, 208)
                                                  ],
                                                  isCurved: true,
                                                  colors: gradientColors,
                                                  barWidth: 1,
                                                  isStrokeCapRound: true,
                                                  curveSmoothness: 0,
                                                  dotData: FlDotData(
                                                    show: true,
                                                  ),
                                                  // belowBarData: BarAreaData(
                                                  //   show: true,
                                                  //   colors: gradientColors
                                                  //       .map((color) => color.withOpacity(0.3))
                                                  //       .toList(),
                                                  // ),
                                                ),
                                                LineChartBarData(
                                                  spots: [
                                                    FlSpot(0, 80),
                                                    FlSpot(1, 160),
                                                    FlSpot(2, 145),
                                                    FlSpot(3, 158),
                                                    FlSpot(4, 88),
                                                    FlSpot(5, 147),
                                                    FlSpot(6, 157),
                                                    FlSpot(7, 193),
                                                    FlSpot(8, 48),
                                                    FlSpot(9, 222),
                                                    FlSpot(10, 257),
                                                    FlSpot(11, 151),
                                                    FlSpot(12, 94),
                                                    FlSpot(13, 76),
                                                    FlSpot(14, 221),
                                                    FlSpot(15, 73),
                                                    FlSpot(16, 81),
                                                    FlSpot(17, 68),
                                                    FlSpot(18, 173),
                                                    FlSpot(19, 39),
                                                    FlSpot(20, 0),
                                                    FlSpot(21, 180),
                                                    FlSpot(22, 72)
                                                  ],
                                                  isCurved: true,
                                                  colors: gradientColors1,
                                                  barWidth: 1,
                                                  isStrokeCapRound: true,
                                                  curveSmoothness: 0,
                                                  dotData: FlDotData(
                                                    show: true,
                                                  ),
                                                  // belowBarData: BarAreaData(
                                                  //   show: true,
                                                  //   colors: gradientColors1
                                                  //       .map((color) => color.withOpacity(0.3))
                                                  //       .toList(),
                                                  // ),
                                                ),
                                                LineChartBarData(
                                                  spots: [
                                                    FlSpot(0, 188),
                                                    FlSpot(1, 392),
                                                    FlSpot(2, 312),
                                                    FlSpot(3, 344),
                                                    FlSpot(4, 194),
                                                    FlSpot(5, 566),
                                                    FlSpot(6, 533),
                                                    FlSpot(7, 582),
                                                    FlSpot(8, 123),
                                                    FlSpot(9, 124),
                                                    FlSpot(10, 401),
                                                    FlSpot(11, 649),
                                                    FlSpot(12, 138),
                                                    FlSpot(13, 123),
                                                    FlSpot(14, 204),
                                                    FlSpot(15, 172),
                                                    FlSpot(16, 179),
                                                    FlSpot(17, 136),
                                                    FlSpot(18, 654),
                                                    FlSpot(19, 50),
                                                    FlSpot(20, 0),
                                                    FlSpot(21, 648),
                                                    FlSpot(22, 134)
                                                  ],
                                                  isCurved: true,
                                                  colors: gradientColors2,
                                                  curveSmoothness: 0,
                                                  barWidth: 1,
                                                  isStrokeCapRound: true,
                                                  dotData: FlDotData(
                                                    show: true,
                                                  ),
                                                  // belowBarData: BarAreaData(
                                                  //   show: true,
                                                  //   colors: gradientColors2
                                                  //       .map((color) => color.withOpacity(0.3))
                                                  //       .toList(),
                                                  // ),
                                                ),
                                              ])));
                                    } else if (snapshot.hasError) {
                                      return snapshot.error;
                                    }
                                    return new Center(
                                      child: new Column(
                                        children: <Widget>[
                                          new Padding(
                                              padding:
                                                  new EdgeInsets.all(50.0)),
                                          new CircularProgressIndicator(),
                                        ],
                                      ),
                                    );
                                  }),
                            ])),
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            // padding: const EdgeInsets.all(value)
            child: Container(
              width: 550,
              height: 350,
              // aspectRatio: 1,
              child: Card(
                  elevation: 1,
                  // margin: EdgeInsets.only(top: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  color: const Color(0xff232d37),
                  child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.all(10),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.fullscreen,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          showMyDialog(context);
                                        })),
                                const SizedBox(
                                  width: 38,
                                ),
                                const Text(
                                  'State Wise Essential Drugs Count',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                              ],
                            ),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              child: FutureBuilder<dynamic>(
                                  future: _fetchMainMenu(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.hasData) {
                                      List<dynamic> object = snapshot.data;

                                      // final List<FlSpot> dummyData1 = object.map((e) {
                                      //   return FlSpot(e, index * Random().nextDouble());
                                      // });
                                      // list.documents.map((doc) => Product.fromFirestore(doc))).toList();
                                      final List<FlSpot> dummyData1 =
                                          object.map((e) {
                                        return FlSpot(
                                            object.indexOf(e).toDouble(),
                                            double.parse(e[4]));
                                      }).toList();
                                      final List<FlSpot> dummyData2 =
                                          object.map((e) {
                                        return FlSpot(
                                            object.indexOf(e).toDouble(),
                                            double.parse(e[5]));
                                      }).toList();
                                      final List<FlSpot> dummyData3 =
                                          object.map((e) {
                                        return FlSpot(
                                            object.indexOf(e).toDouble(),
                                            double.parse(e[6]));
                                      }).toList();
                                      final List<FlSpot> dummyData4 =
                                      object.map((e) {
                                        return FlSpot(
                                            object.indexOf(e).toDouble(),
                                            double.parse(e[7]));
                                      }).toList();

                                      return Container(
                                          margin: EdgeInsets.fromLTRB(
                                              10, 15, 10, 15),
                                          child: LineChart(LineChartData(
                                              minY: 0,
                                              maxY: 300000,
                                              axisTitleData: FlAxisTitleData(
                                                  leftTitle: AxisTitle(
                                                    showTitle: true,
                                                    margin: 12,
                                                    titleText:
                                                        'Essntials Drugs Count(in no.)',
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xffffffff)),
                                                  ),
                                                  bottomTitle: AxisTitle(
                                                      showTitle: true,
                                                      titleText: 'States',
                                                      margin: 12,
                                                      textStyle: TextStyle(
                                                          color: Color(
                                                              0xffffffff)))),
                                              gridData: FlGridData(
                                                show: true,
                                                drawVerticalLine: true,
                                                getDrawingHorizontalLine:
                                                    (value) {
                                                  return FlLine(
                                                    color:
                                                        const Color(0xff37434d),
                                                    strokeWidth: 1,
                                                  );
                                                },
                                                getDrawingVerticalLine:
                                                    (value) {
                                                  return FlLine(
                                                    color:
                                                        const Color(0xff37434d),
                                                    strokeWidth: 1,
                                                  );
                                                },
                                              ),
                                              titlesData: FlTitlesData(
                                                show: true,
                                                bottomTitles: SideTitles(
                                                  // margin:20,
                                                  rotateAngle: 90,
                                                  showTitles: true,
                                                  reservedSize: 22,
                                                  getTextStyles: (value) =>
                                                      const TextStyle(
                                                          color:
                                                              Color(0xff68737d),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                  getTitles: (double value) {
                                                    var _list = [];
                                                    object.map((e) {
                                                      // setState(() {

                                                      _list.add((e[1]));
                                                      // });
                                                    }).toList();

                                                    switch (value.toInt()) {
                                                      case -1:
                                                        return '';

                                                      default:
                                                        return _list[
                                                            value.toInt()];
                                                    }

                                                    // value.toString();
                                                  },
                                                  margin: 8,
                                                ),
                                                leftTitles: SideTitles(
                                                    showTitles: true,
                                                    getTextStyles: (value) =>
                                                        const TextStyle(
                                                          color:
                                                              Color(0xff67727d),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                    getTitles: (value) {
                                                      return '${value.toInt()}';
                                                    },
                                                    reservedSize: 28,
                                                    margin: 12,
                                                    interval: 40000),
                                              ),
                                              borderData: FlBorderData(
                                                  show: true,
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xff37434d),
                                                      width: 1)),
                                              lineBarsData: [
                                                LineChartBarData(
                                                  spots: dummyData1,
                                                  isCurved: true,
                                                  colors: gradientColors,
                                                  barWidth: 1,
                                                  isStrokeCapRound: true,
                                                  curveSmoothness: 0,
                                                  dotData: FlDotData(
                                                    show: true,
                                                  ),
                                                ),
                                              ]

                                          )));
                                    } else if (snapshot.hasError) {
                                      return snapshot.error;
                                    }
                                    return new Center(
                                      child: new Column(
                                        children: <Widget>[
                                          new Padding(
                                              padding:
                                                  new EdgeInsets.all(50.0)),
                                          new CircularProgressIndicator(),
                                        ],
                                      ),
                                    );
                                  }),
                            ))
                          ]))),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                  fontSize: 12,
                  color:
                      showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
            ),
          ),
        ),
      ],
    );
  }

}
