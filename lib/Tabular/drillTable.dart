import 'dart:convert';
import 'package:flutter/material.dart';
import '../Utils/basicAuth.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../BarChart/drillchart.dart';

class DrillTableDetail extends StatefulWidget {
  final String drillStateid;
  DrillTableDetail({Key key, this.drillStateid}) : super(key: key);
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<DrillTableDetail> {
  String _id;
  bool sort;
  bool drilldrop = false;

  _fetchdrillEDLDetails() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _id = (prefs.getString('username') ?? "");
      final formData = jsonEncode({
        "primaryKeys": ['${widget.drillStateid}']
      });
      Response response =
          await ioClient.post(DRILL_EDL_URL, headers: headers, body: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> chartData = list["dataValue"];
        List<dynamic> chartDatareverse = chartData.reversed.toList(); 
        return chartData;
      } else {
        throw Exception('Failed to load Data');
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

  @override
  void initState() {
    sort = false;
    super.initState();
    _fetchdrillEDLDetails();
  }

  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: _fetchdrillEDLDetails(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: new Column(
                children: <Widget>[
                  new Padding(padding: new EdgeInsets.all(50.0)),
                  new CircularProgressIndicator(),
                ],
              ),
            );
          }
          List<dynamic> chData = snapshot.data;
          List<dynamic> reversechData = snapshot.data.reversed.toList();
          return ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              //  Container(
              //   margin: EdgeInsets.only(top:20, bottom:10),
              //   child: Center(
              //       child: Text('State Wise Essential Drugs Count',
              //           style: TextStyle(
              //             fontSize: 18,
              //             color:Colors.black
              //             // decoration: TextDecoration.underline,
              //           )))),
              DataTable(
                sortAscending: sort,
                sortColumnIndex: 0,
                columns: [
                  DataColumn(
                      label: Row(
                    children: [
                      IconButton(
                          icon: new Icon(Icons.import_export),
                          onPressed: () {
                            setState(() {
                              sort = !sort;
                            });
                          }),
                      Text("Facility Name",
                          style: TextStyle(color: Colors.black, fontSize: 14))
                    ],
                  )),
                  DataColumn(
                      label: Text("EDL(Count In Nos.)",
                          style: TextStyle(color: Colors.black, fontSize: 14))),
                  DataColumn(
                      label: Text("Gol EDL(Count In Nos.)",
                          style: TextStyle(color: Colors.black, fontSize: 14))),
                  DataColumn(
                      label: Text("State EDL(Count In Nos.)",
                          style: TextStyle(color: Colors.black, fontSize: 14)))
                ],
                rows: sort
                    ? reversechData
                        .map((element) => DataRow(
                                color:
                                    MaterialStateColor.resolveWith((element) {
                                  return Colors.grey[200];
                                }),
                                cells: [
                                  DataCell(Row(
                                    children: [
                                      GestureDetector(
                                          child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 5, 0),
                                        child: Icon(
                                          Icons.assessment,
                                          color: Colors.green,
                                        ),
                                      )),
                                      Text(element[0])
                                    ],
                                  )),
                                  DataCell(Text(element[1])),
                                  DataCell(Text(element[2])),
                                  DataCell(Text(element[3])),
                                ]))
                        .toList()
                    : chData
                        .map((element) => DataRow(cells: [
                              DataCell(Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DrillChart(
                                                  stateName: element[1], stateId: element[0],)),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 5, 0),
                                        child: Icon(
                                          Icons.assessment,
                                          color: Colors.red[200],
                                        ),
                                      )),
                                  Text(element[0])
                                ],
                              )),
                              DataCell(Text(element[1])),
                              DataCell(Text(element[2])),
                              DataCell(Text(element[3])),
                            ]))
                        .toList(),
              ),
            ],
          );
        });
  }
}
