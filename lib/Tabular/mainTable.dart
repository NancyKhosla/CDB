import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../Utils/basicAuth.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TableDetail extends StatefulWidget {
  final String head, dId, dyear;
  TableDetail(
      {Key key, @required this.head, @required this.dId, @required this.dyear})
      : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<TableDetail> {
  String _id;
  bool sort;
  bool drilldrop = false;
  List<dynamic> listtt = ['drill'];

  Future _fetchEDLDetails() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _id = (prefs.getString('username') ?? "");
      
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
      switch ('${widget.head}') {
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
      final formData = jsonEncode({
        "seatId": "$_id",
        "filterIds": [filterid],
        "filterValues": [filtervalue]
      }); 
      String url;
      switch ('${widget.head}') {
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
      
      Response response =
          await ioClient.post(url, headers: headers, body: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> datalist = list['dataValue'];
        List<dynamic> datalistvalue = list['dataHeading'];
        
        return [datalistvalue, datalist];
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
    _fetchEDLDetails();
  }

  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: _fetchEDLDetails(),
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
          List<dynamic> tableheading = snapshot.data[0];
          List<dynamic> tablevalue = snapshot.data[1];
          return ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              DataTable(
                  sortAscending: sort,
                  sortColumnIndex: 0,
                  columns: tableheading
                      .map((e) => DataColumn(
                          label: Text(e,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14))))
                      .toList(),
                  rows: tablevalue.map((e) {
                    List<String> _list = [];
                    for (int i = 0; i < e.length; i++) _list.add(e[i]);
                    return DataRow(
                        cells: _list
                            .map((index) => DataCell(Text(index)))
                            .toList());
                  }).toList()),
            ],
          );
        });
  }
}
