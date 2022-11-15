import 'dart:convert';
import '../Utils/basicAuth.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DrillchartTab extends StatefulWidget {
  final String drillStateid;
  DrillchartTab({Key key, @required this.drillStateid}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChartTabState();
}

class ChartTabState extends State<DrillchartTab> {
  Future<dynamic> myedlist;

  @override
  void initState() {
    myedlist = _drillfacility();
    super.initState();
  }

  final Color leftBarColor = const Color(0xff64dfdf);
  final Color rightBarColor = const Color(0xffff9292);
  final Color thirdBarColor = const Color(0xffffc478);
  final double width = 5;

  Future<dynamic> _drillfacility() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        final formData = jsonEncode({
          "primaryKeys": ['${widget.drillStateid}']
        });
        print('facility $formData');
        Response response = await ioClient.post(DRILL_EDL_URL,
            headers: headers, body: formData);
        if (response.statusCode == 200) {
          Map<String, dynamic> list = json.decode(response.body);
          List<dynamic> userid = list["dataValue"];
          return userid;
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

  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
            child: GestureDetector(
                // onTap: () => showMyDialog(context),
                child: Hero(
                    tag: 'halfcard',
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                              child: Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                                color: const Color(0xff232d37),
                                child: FutureBuilder<dynamic>(
                                    future: myedlist,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      if (snapshot.hasData) {
                                        List<dynamic> object = snapshot.data;
                                        return Container(
                                            margin: EdgeInsets.all(10),
                                            child: BarChart(
                                              BarChartData(
                                                  alignment: BarChartAlignment
                                                      .spaceEvenly,
                                                  minY: 0,
                                                  maxY: 1000,
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
                                                                  'facility',
                                                              margin: 12,
                                                              textStyle: TextStyle(
                                                                  color: Color(
                                                                      0xffffffff)))),
                                                  barTouchData: BarTouchData(
                                                    touchTooltipData:
                                                        BarTouchTooltipData(
                                                            tooltipBottomMargin:
                                                                8,
                                                            tooltipBgColor:
                                                                Colors.blueGrey,
                                                            getTooltipItem:
                                                                (group,
                                                                    groupIndex,
                                                                    rod,
                                                                    rodIndex) {
                                                              String weekDay;
                                                              var _list = [];
                                                              object.map((e) {
                                                                _list.add(
                                                                    (e[0]));
                                                              }).toList();
                                                              switch (group.x
                                                                  .toInt()) {
                                                                case -1:
                                                                  weekDay = '';
                                                                  break;
                                                                default:
                                                                  weekDay =
                                                                      _list[group
                                                                          .x
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
                                                        if (barTouchResponse
                                                                    .spot !=
                                                                null &&
                                                            barTouchResponse
                                                                    .touchInput
                                                                is! FlPanEnd &&
                                                            barTouchResponse
                                                                    .touchInput
                                                                is! FlLongPressEnd) {
                                                          touchedIndex =
                                                              barTouchResponse
                                                                  .spot
                                                                  .touchedBarGroupIndex;
                                                        } else {
                                                          touchedIndex = -1;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                  titlesData: FlTitlesData(
                                                    show: true,
                                                    topTitles: SideTitles(
                                                      showTitles: true,
                                                      getTextStyles: (value) =>
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14),
                                                      getTitles:
                                                          (double value) {
                                                        var _list = [];
                                                        object.map((e) {
                                                          _list.add((e[1]));
                                                        }).toList();

                                                        switch (value.toInt()) {
                                                          case -1:
                                                            return '';
                                                          default:
                                                            return _list[
                                                                value.toInt()];
                                                        }
                                                      },
                                                      rotateAngle: 60,
                                                      margin: 0,
                                                    ),
                                                    bottomTitles: SideTitles(
                                                      rotateAngle: 60,
                                                      showTitles: true,
                                                      margin: 30,
                                                      getTextStyles: (value) =>
                                                          const TextStyle(
                                                              color: Color(
                                                                  0xffaaaaaa)),
                                                      getTitles:
                                                          (double value) {
                                                        var _list = [];
                                                        object.map((e) {
                                                          _list.add((e[0]
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
                                                  barGroups: object
                                                      .map((element) =>
                                                          BarChartGroupData(
                                                            x: object.indexOf(
                                                                element),
                                                            barRods: [
                                                              BarChartRodData(
                                                                  width: width,
                                                                  colors: [
                                                                    leftBarColor
                                                                  ],
                                                                  y: double.parse(
                                                                      element[
                                                                          1])),
                                                              BarChartRodData(
                                                                  width: width,
                                                                  colors: [
                                                                    rightBarColor
                                                                  ],
                                                                  y: double.parse(
                                                                      element[
                                                                          2])),
                                                              BarChartRodData(
                                                                  width: width,
                                                                  colors: [
                                                                    thirdBarColor
                                                                  ],
                                                                  y: double.parse(
                                                                      element[
                                                                          3])),
                                                            ],
                                                            // showingTooltipIndicators: [0, 0, 0, 0]
                                                          ))
                                                      .toList()),
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
                                // ),
                                // ),
                              ),
                            ))))))
      ],
    );
  }
}
