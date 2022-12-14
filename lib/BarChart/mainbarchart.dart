import 'dart:convert';
import '../Utils/basicAuth.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarchartEDL extends StatefulWidget {
  final String bhead, dId, dyear;

  BarchartEDL(
      {Key key, @required this.bhead, @required this.dId, @required this.dyear})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ChartTabState();
}

class ChartTabState extends State<BarchartEDL> {
  String _id;
  Future<List<dynamic>> myedlist;
  List<dynamic> userid = [];

  @override
  void initState() {
    print("chart called...");
    myedlist = _fetchMainMenu();
    super.initState();
  }

  final Color leftBarColor = const Color(0xff64dfdf);
  final Color rightBarColor = const Color(0xffff9292);
  final Color thirdBarColor = const Color(0xffffc478);
  final double width = 5;

  Future<List<dynamic>> _fetchMainMenu() async {
    String url;

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

  int touchedIndex;
  final Color barBackgroundColor = const Color(0xff72d8bf);
  List<int> showTooltips = const [];

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
                          FutureBuilder<List<dynamic>>(
                              future: myedlist,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.hasData) {
                                  List<dynamic> object = snapshot.data;
                                  return Container(
                                      margin: EdgeInsets.all(10),
                                      child: BarChart(
                                        BarChartData(
                                            alignment:
                                                BarChartAlignment.spaceEvenly,
                                            // minY: 0,
                                            // maxY: 1000,
                                            axisTitleData: FlAxisTitleData(
                                                leftTitle: AxisTitle(
                                                  showTitle: true,
                                                  margin: 12,
                                                  titleText:
                                                      'Essntials Drugs Count(in no.)',
                                                  textStyle: TextStyle(
                                                      color: Color(0xffffffff)),
                                                ),
                                                bottomTitle: AxisTitle(
                                                    showTitle: true,
                                                    titleText: 'States',
                                                    margin: 12,
                                                    textStyle: TextStyle(
                                                        color: Color(
                                                            0xffffffff)))),
                                            barTouchData: BarTouchData(
                                              touchTooltipData:
                                                  BarTouchTooltipData(
                                                      tooltipBottomMargin: 8,
                                                      tooltipBgColor:
                                                          Colors.blueGrey,
                                                      getTooltipItem: (group,
                                                          groupIndex,
                                                          rod,
                                                          rodIndex) {
                                                        String weekDay;
                                                        var _list = [];
                                                        object.map((e) {
                                                          _list.add((e[1]));
                                                        }).toList();
                                                        switch (
                                                            group.x.toInt()) {
                                                          case -1:
                                                            weekDay = '';
                                                            break;
                                                          default:
                                                            weekDay = _list[
                                                                group.x
                                                                    .toInt()];
                                                        }
                                                        return BarTooltipItem(
                                                            weekDay +
                                                                '\n' +
                                                                (rod.y.round())
                                                                    .toString(),
                                                            TextStyle(
                                                                color: Colors
                                                                    .yellow));
                                                      }),
                                              touchCallback:
                                                  (barTouchResponse) {
                                                setState(() {
                                                  if (barTouchResponse.spot !=
                                                          null &&
                                                      barTouchResponse
                                                              .touchInput
                                                          is! FlPanEnd &&
                                                      barTouchResponse
                                                              .touchInput
                                                          is! FlLongPressEnd) {
                                                    touchedIndex =
                                                        barTouchResponse.spot
                                                            .touchedBarGroupIndex;
                                                  } else {
                                                    touchedIndex = -1;
                                                  }
                                                });
                                              },
                                            ),
                                            titlesData: FlTitlesData(
                                              show: true,
                                              // topTitles: SideTitles(
                                              //   showTitles: true,
                                              //   getTextStyles: (value) =>
                                              //       const TextStyle(
                                              //           color: Colors.white,
                                              //           fontWeight:
                                              //               FontWeight.bold,
                                              //           fontSize: 14),
                                              //   getTitles: (double value) {
                                              //     var _list = [];
                                              //     object.map((e) {
                                              //       _list.add((e[2]));
                                              //     }).toList();

                                              //     switch (value.toInt()) {
                                              //       case -1:
                                              //         return '';
                                              //       default:
                                              //         return _list[
                                              //             value.toInt()];
                                              //     }
                                              //   },
                                              //   rotateAngle: 90,
                                              //   margin: 0,
                                              // ),
                                              bottomTitles: SideTitles(
                                                rotateAngle: 90,
                                                showTitles: true,
                                                margin: 30,
                                                getTextStyles: (value) =>
                                                    const TextStyle(
                                                        color:
                                                            Color(0xffaaaaaa)),
                                                getTitles: (double value) {
                                                  var _list = [];
                                                  object.map((e) {
                                                    _list.add((e[1]
                                                        .substring(0, 3)
                                                        .toUpperCase()));
                                                  }).toList();

                                                  switch (value.toInt()) {
                                                    case -1:
                                                      return '';
                                                    default:
                                                      return _list[
                                                          value.toInt()];
                                                  }
                                                },
                                              ),
                                              leftTitles: SideTitles(
                                                showTitles: true,
                                                getTextStyles: (value) =>
                                                    const TextStyle(
                                                        color:
                                                            Color(0xffaaaaaa)),
                                                getTitles: (value) {
                                                  return '${value.toInt()}';
                                                },
                                                interval: 200,
                                                margin: 5,
                                              ),
                                            ),
                                            gridData: FlGridData(
                                              show: true,
                                              checkToShowHorizontalLine:
                                                  (value) => value % 5 == 0,
                                              getDrawingHorizontalLine:
                                                  (value) => FlLine(
                                                color: Color((0xff37434d)),
                                                strokeWidth: 1,
                                              ),
                                            ),
                                            borderData: FlBorderData(
                                              show: false,
                                            ),
                                            groupsSpace: 4,
                                            barGroups: object
                                                .map((element) =>
                                                    BarChartGroupData(
                                                      x: object
                                                          .indexOf(element),
                                                      barRods: [
                                                        BarChartRodData(
                                                            width: width,
                                                            colors: [
                                                              leftBarColor
                                                            ],
                                                            y: double.parse(
                                                                element[2])),
                                                        BarChartRodData(
                                                            width: width,
                                                            colors: [
                                                              rightBarColor
                                                            ],
                                                            y: double.parse(
                                                                element[3])),
                                                        BarChartRodData(
                                                            width: width,
                                                            colors: [
                                                              thirdBarColor
                                                            ],
                                                            y: double.parse(
                                                                element[4])),
                                                      ],
                                                      // showingTooltipIndicators: [0, 0, 0, 0]
                                                    ))
                                                .toList()),
                                      ));
                                } else if (snapshot.hasError) {
                                  return Text("ERROR: ${snapshot.error}");
                                }
                                return new Center(
                                  child: new Column(
                                    children: <Widget>[
                                      new Padding(
                                          padding: new EdgeInsets.all(50.0)),
                                      new CircularProgressIndicator(),
                                    ],
                                  ),
                                );
                              }),
                        ])
                    // ),
                    ),
              )),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
                margin: const EdgeInsets.only(top: 30),
                child: Container(
                    width: 900,
                    height: 400,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
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
                                    child:  getWidget()
                                  )),
                             /* Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                child: FutureBuilder<List<dynamic>>(
                                    future: _fetchMainMenu(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<dynamic>> snapshot) {
                                      if (snapshot.hasData) {
                                        List<dynamic> object = snapshot.data;
                                        print(object.toString());
                                        return Container(
                                            margin: EdgeInsets.all(10),
                                            child: BarChart(
                                              BarChartData(
                                                  alignment: BarChartAlignment
                                                      .spaceEvenly,
                                                  axisTitleData:
                                                      FlAxisTitleData(
                                                          leftTitle: AxisTitle(
                                                            showTitle: true,
                                                            margin: 12,
                                                            titleText:
                                                                'Essntials Drugs Count(in no.)',
                                                            textStyle: TextStyle(
                                                                color: Color(
                                                                    0xffffffff)),
                                                          ),
                                                          bottomTitle: AxisTitle(
                                                              showTitle: true,
                                                              titleText:
                                                                  'States',
                                                              margin: 12,
                                                              textStyle: TextStyle(
                                                                  color: Color(
                                                                      0xffffffff)))),
                                                  titlesData: FlTitlesData(
                                                    show: true,
                                                    bottomTitles: SideTitles(
                                                      rotateAngle: 60,
                                                      showTitles: true,
                                                      margin: 20,
                                                      getTextStyles: (value) =>
                                                          const TextStyle(
                                                              color: Color(
                                                                  0xffaaaaaa)),
                                                      getTitles:
                                                          (double value) {
                                                        var _list = [];

                                                        object.map((e) {
                                                          _list.add(e[1]);
                                                        }).toList();

                                                        switch (value.toInt()) {
                                                          case -1:
                                                            return '';
                                                          default:
                                                            return _list[
                                                                value.toInt()];
                                                        }
                                                      },
                                                    ),
                                                    leftTitles: SideTitles(
                                                      showTitles: true,
                                                      getTextStyles: (value) =>
                                                          const TextStyle(
                                                              color: Color(
                                                                  0xffaaaaaa)),
                                                      getTitles: (value) {
                                                        return '${value.toInt()}';
                                                      },
                                                      interval: 200,
                                                      margin: 5,
                                                    ),
                                                  ),
                                                  gridData: FlGridData(
                                                    show: true,
                                                    checkToShowHorizontalLine:
                                                        (value) =>
                                                            value % 5 == 0,
                                                    getDrawingHorizontalLine:
                                                        (value) => FlLine(
                                                      color:
                                                          Color((0xff37434d)),
                                                      strokeWidth: 1,
                                                    ),
                                                  ),
                                                  borderData: FlBorderData(
                                                    show: false,
                                                  ),
                                                  groupsSpace: 5,
                                                  barGroups: object.map((e) {
                                                    List<String> _list = [];
                                                    for (int i = 0;
                                                        i < e.length;
                                                        i++) _list.add(e[i]);
                                                    // new _list(e);

                                                    switch ('${widget.bhead}') {
                                                      case 'EDL Details':
                                                        return BarChartGroupData(
                                                            x: object
                                                                .indexOf(e),
                                                            barRods: [
                                                              BarChartRodData(
                                                                  width: width,
                                                                  colors: [
                                                                    leftBarColor
                                                                  ],
                                                                  y: double
                                                                      .parse(e[
                                                                          3])),
                                                              BarChartRodData(
                                                                  width: width,
                                                                  colors: [
                                                                    leftBarColor
                                                                  ],
                                                                  y: double
                                                                      .parse(e[
                                                                          4])),
                                                              BarChartRodData(
                                                                  width: width,
                                                                  colors: [
                                                                    leftBarColor
                                                                  ],
                                                                  y: double
                                                                      .parse(e[
                                                                          5])),
                                                            ]);
                                                        break;
                                                      case 'Rate Contract':
                                                        return BarChartGroupData(
                                                            x: object
                                                                .indexOf(e),
                                                            barRods: [
                                                              BarChartRodData(
                                                                  width: width,
                                                                  colors: [
                                                                    leftBarColor
                                                                  ],
                                                                  y: double
                                                                      .parse(e[
                                                                          3])),
                                                            ]);
                                                        break;
                                                      case 'Demand Procurement Status':
                                                        return BarChartGroupData(
                                                            x: object
                                                                .indexOf(e),
                                                            barRods: [
                                                              BarChartRodData(
                                                                  width: width,
                                                                  colors: [
                                                                    leftBarColor
                                                                  ],
                                                                  y: double
                                                                      .parse(e[
                                                                          4])),
                                                            ]);
                                                        break;
                                                      default:
                                                        BarChartGroupData(
                                                            x: 0, barRods: []);
                                                        break;
                                                    }
                                                    *//*  return '${widget.bhead}' ==
                                                            'EDL Details'
                                                        ? BarChartGroupData(
                                                            x: object
                                                                .indexOf(e),
                                                            barRods: [
                                                                BarChartRodData(
                                                                    width:
                                                                        width,
                                                                    colors: [
                                                                      leftBarColor
                                                                    ],
                                                                    y: double.parse(
                                                                        _list[
                                                                            3])),
                                                                BarChartRodData(
                                                                    width:
                                                                        width,
                                                                    colors: [
                                                                      leftBarColor
                                                                    ],
                                                                    y: double.parse(
                                                                        _list[
                                                                            4])),
                                                                BarChartRodData(
                                                                    width:
                                                                        width,
                                                                    colors: [
                                                                      leftBarColor
                                                                    ],
                                                                    y: double.parse(
                                                                        _list[
                                                                            5])),
                                                              ])
                                                        : '${widget.bhead}' ==
                                                                'Rate Contract'
                                                            ? BarChartGroupData(
                                                                x: object
                                                                    .indexOf(e),
                                                                barRods: [
                                                                    BarChartRodData(
                                                                        width:
                                                                            width,
                                                                        colors: [
                                                                          leftBarColor
                                                                        ],
                                                                        y: double.parse(
                                                                            _list[3])),
                                                                  ])
                                                            : '${widget.bhead}' ==
                                                                    'Demand Procurement Status'
                                                                ? BarChartGroupData(
                                                                    x: object
                                                                        .indexOf(
                                                                            e),
                                                                    barRods: [
                                                                        BarChartRodData(
                                                                            width:
                                                                                width,
                                                                            colors: [
                                                                              leftBarColor
                                                                            ],
                                                                            y: double.parse(_list[4])),
                                                                      ])
                                                                : BarChartGroupData(
                                                                    x: 0,
                                                                    barRods: []);*//*
                                                  }).toList()),
                                            ));
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
                              )),*/
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))))
      ],
    );
  }

 Widget getWidget( ){
    switch('${widget.bhead}'){
      case 'EDL Details':
        print("jshad");
       return FutureBuilder<List<dynamic>>(
            future: _fetchMainMenu(),
            builder: (BuildContext context,
                AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                List<dynamic> object = snapshot.data;
                print(object.toString());
                return Container(
                    margin: EdgeInsets.all(10),
                    child: BarChart(
                      BarChartData(
                          alignment: BarChartAlignment
                              .spaceEvenly,
                          axisTitleData:
                          FlAxisTitleData(
                              leftTitle: AxisTitle(
                                showTitle: true,
                                margin: 12,
                                titleText:
                                'Essntials Drugs Count(in no.)',
                                textStyle: TextStyle(
                                    color: Color(
                                        0xffffffff)),
                              ),
                              bottomTitle: AxisTitle(
                                  showTitle: true,
                                  titleText:
                                  'States',
                                  margin: 12,
                                  textStyle: TextStyle(
                                      color: Color(
                                          0xffffffff)))),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: SideTitles(
                              rotateAngle: 60,
                              showTitles: true,
                              margin: 20,
                              getTextStyles: (value) =>
                              const TextStyle(
                                  color: Color(
                                      0xffaaaaaa)),
                              getTitles:
                                  (double value) {
                                var _list = [];

                                object.map((e) {
                                  _list.add(e[1]);
                                }).toList();

                                switch (value.toInt()) {
                                  case -1:
                                    return '';
                                  default:
                                    return _list[
                                    value.toInt()];
                                }
                              },
                            ),
                            leftTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (value) =>
                              const TextStyle(
                                  color: Color(
                                      0xffaaaaaa)),
                              getTitles: (value) {
                                return '${value.toInt()}';
                              },
                              interval: 200,
                              margin: 5,
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            checkToShowHorizontalLine:
                                (value) =>
                            value % 5 == 0,
                            getDrawingHorizontalLine:
                                (value) => FlLine(
                              color:
                              Color((0xff37434d)),
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          groupsSpace: 5,
                          barGroups: object.map((e) {
                            List<String> _list = [];
                            for (int i = 0;
                            i < e.length;
                            i++) _list.add(e[i]);
                            // new _list(e);

                            /*switch ('${widget.bhead}') {
                              case 'EDL Details':
                                return BarChartGroupData(
                                    x: object
                                        .indexOf(e),
                                    barRods: [
                                      BarChartRodData(
                                          width: width,
                                          colors: [
                                            leftBarColor
                                          ],
                                          y: double
                                              .parse(e[
                                          3])),
                                      BarChartRodData(
                                          width: width,
                                          colors: [
                                            leftBarColor
                                          ],
                                          y: double
                                              .parse(e[
                                          4])),
                                      BarChartRodData(
                                          width: width,
                                          colors: [
                                            leftBarColor
                                          ],
                                          y: double
                                              .parse(e[
                                          5])),
                                    ]);
                                break;
                              case 'Rate Contract':
                                return BarChartGroupData(
                                    x: object
                                        .indexOf(e),
                                    barRods: [
                                      BarChartRodData(
                                          width: width,
                                          colors: [
                                            leftBarColor
                                          ],
                                          y: double
                                              .parse(e[
                                          3])),
                                    ]);
                                break;
                              case 'Demand Procurement Status':
                                return BarChartGroupData(
                                    x: object
                                        .indexOf(e),
                                    barRods: [
                                      BarChartRodData(
                                          width: width,
                                          colors: [
                                            leftBarColor
                                          ],
                                          y: double
                                              .parse(e[
                                          4])),
                                    ]);
                                break;
                              default:
                                BarChartGroupData(
                                    x: 0, barRods: []);
                                break;
                            }*/
                            return  BarChartGroupData(
                                x: object
                                    .indexOf(e),
                                barRods: [
                                  BarChartRodData(
                                      width:
                                      width,
                                      colors: [
                                        leftBarColor
                                      ],
                                      y: double.parse(
                                          _list[
                                          3]  )),
                                  BarChartRodData(
                                      width:
                                      width,
                                      colors: [
                                        leftBarColor
                                      ],
                                      y: double.parse(
                                          _list[
                                          4])),
                                  BarChartRodData(
                                      width:
                                      width,
                                      colors: [
                                        leftBarColor
                                      ],
                                      y: double.parse(
                                          _list[
                                          5])),
                                ]);

                          }).toList()),
                    ));
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
            });
        break;
      case 'Rate Contract':
        return FutureBuilder<List<dynamic>>(
            future: _fetchMainMenu(),
            builder: (BuildContext context,
                AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                List<dynamic> object = snapshot.data;
                print(object.toString());
                return Container(
                    margin: EdgeInsets.all(10),
                    child: BarChart(
                      BarChartData(
                          alignment: BarChartAlignment
                              .spaceEvenly,
                          axisTitleData:
                          FlAxisTitleData(
                              leftTitle: AxisTitle(
                                showTitle: true,
                                margin: 12,
                                titleText:
                                'Essntials Drugs Count(in no.)',
                                textStyle: TextStyle(
                                    color: Color(
                                        0xffffffff)),
                              ),
                              bottomTitle: AxisTitle(
                                  showTitle: true,
                                  titleText:
                                  'States',
                                  margin: 12,
                                  textStyle: TextStyle(
                                      color: Color(
                                          0xffffffff)))),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: SideTitles(
                              rotateAngle: 60,
                              showTitles: true,
                              margin: 20,
                              getTextStyles: (value) =>
                              const TextStyle(
                                  color: Color(
                                      0xffaaaaaa)),
                              getTitles:
                                  (double value) {
                                var _list = [];

                                object.map((e) {
                                  _list.add(e[1]);
                                }).toList();

                                switch (value.toInt()) {
                                  case -1:
                                    return '';
                                  default:
                                    return _list[
                                    value.toInt()];
                                }
                              },
                            ),
                            leftTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (value) =>
                              const TextStyle(
                                  color: Color(
                                      0xffaaaaaa)),
                              getTitles: (value) {
                                return '${value.toInt()}';
                              },
                              interval: 200,
                              margin: 5,
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            checkToShowHorizontalLine:
                                (value) =>
                            value % 5 == 0,
                            getDrawingHorizontalLine:
                                (value) => FlLine(
                              color:
                              Color((0xff37434d)),
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          groupsSpace: 5,
                          barGroups: object.map((e) {
                            List<String> _list = [];
                            for (int i = 0;
                            i < e.length;
                            i++) _list.add(e[i]);
                            // new _list(e);

                            return  BarChartGroupData(
                                x: object
                                    .indexOf(e),
                                barRods: [
                                  BarChartRodData(
                                      width: width,
                                      colors: [
                                        leftBarColor
                                      ],
                                      y: double
                                          .parse(e[
                                      3])),
                                ]);

                          }).toList()),
                    ));
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
            });
        break;
      case 'Demand Procurement Status':

      return  FutureBuilder<List<dynamic>>(
            future: _fetchMainMenu(),
            builder: (BuildContext context,
                AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                List<dynamic> object = snapshot.data;
                print(object.toString());
                return Container(
                    margin: EdgeInsets.all(10),
                    child: BarChart(
                      BarChartData(
                          alignment: BarChartAlignment
                              .spaceEvenly,
                          axisTitleData:
                          FlAxisTitleData(
                              leftTitle: AxisTitle(
                                showTitle: true,
                                margin: 12,
                                titleText:
                                'Essntials Drugs Count(in no.)',
                                textStyle: TextStyle(
                                    color: Color(
                                        0xffffffff)),
                              ),
                              bottomTitle: AxisTitle(
                                  showTitle: true,
                                  titleText:
                                  'States',
                                  margin: 12,
                                  textStyle: TextStyle(
                                      color: Color(
                                          0xffffffff)))),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: SideTitles(
                              rotateAngle: 60,
                              showTitles: true,
                              margin: 20,
                              getTextStyles: (value) =>
                              const TextStyle(
                                  color: Color(
                                      0xffaaaaaa)),
                              getTitles:
                                  (double value) {
                                var _list = [];

                                object.map((e) {
                                  _list.add(e[1]);
                                }).toList();

                                switch (value.toInt()) {
                                  case -1:
                                    return '';
                                  default:
                                    return _list[
                                    value.toInt()];
                                }
                              },
                            ),
                            leftTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (value) =>
                              const TextStyle(
                                  color: Color(
                                      0xffaaaaaa)),
                              getTitles: (value) {
                                return '${value.toInt()}';
                              },
                              interval: 200,
                              margin: 5,
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            checkToShowHorizontalLine:
                                (value) =>
                            value % 5 == 0,
                            getDrawingHorizontalLine:
                                (value) => FlLine(
                              color:
                              Color((0xff37434d)),
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          groupsSpace: 5,
                          barGroups: object.map((e) {
                            List<String> _list = [];
                            for (int i = 0;
                            i < e.length;
                            i++) _list.add(e[i]);

                            return  BarChartGroupData(
                                x: object
                                    .indexOf(e),
                                barRods: [
                                  BarChartRodData(
                                      width: width,
                                      colors: [
                                        leftBarColor
                                      ],
                                      y: double
                                          .parse(e[
                                      4])),
                                ]);

                          }).toList()),
                    ));
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
            });
        break;

      default:
        BarChartGroupData(
            x: 0, barRods: []);
        break;
    }
  }
}
