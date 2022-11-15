import 'package:centraldashboardversion4/BarChart/barchartDemand.dart';
import 'package:centraldashboardversion4/BarChart/barchartRateContract.dart';
import 'package:centraldashboardversion4/LineChart/linechartDemandProc.dart';
import 'package:centraldashboardversion4/LineChart/linechartRateContract.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../LineChart/mainlinechart.dart';
import '../Tabular/mainTable.dart';
import 'mainbarchart.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../Utils/basicAuth.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class Chart extends StatefulWidget {
  final String heading;

  Chart({Key key, @required this.heading}) : super(key: key);

  @override
  _PageState createState() => new _PageState();
}

class _PageState extends State<Chart> {


  List<String> _locations = ['Column Bar Graph', 'Line Graph'];
  String _selectedLocation = 'Column Bar Graph',
      selectedValue,
      _drugId = '104',
      holder,
      _id,
      selectDrugNameValue,
      holderName,
      selectYear,
      year,
      _drugNameId = '21191037',
      _yeard = "2020-2021";
  List<dynamic> userid;
  String selectedStore;
  List<dynamic> storeList = ['Column Bar Graph', 'Line Graph'];

  //VIA_USERID_DATA_FETCH_FUNC

  Future<List<dynamic>> _getfilterdropdownType() async {

    print("nancy");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _id = (prefs.getString('username') ?? "");

    String url;
    var filtervalue, filterid;
    switch ('${widget.heading}') {
      case 'Rate Contract':
        url = RATE_DRUG_TYPE_URL;
        filterid = '73';
        filtervalue = '';

        break;
      case 'Demand Procurement Status':
        url = DEMAND_YEAR;
        filterid = '75';
        filtervalue = '';
        break;
      case 'Common Essential Drugs':
        url = COMMAN_ESSENTAIL_STATE_COMBO;
        filterid = '66';
        filtervalue = '';
        break;
      case 'Drugs Excess/Shortage':
        url = STATE_COMBO_DRUGS_EXCESS;
        filterid = '69';
        filtervalue = '';
        break;
      case 'Stock Out Detail V 2.0':
        url = COMBO_FACILI_STOCKOUTV2;
        filterid = '67';
        filtervalue = '';
        break;
    }
    print('combo1 $url');
    try {
      final formData = jsonEncode({
        "seatId": "$_id",
        "filterIds": [filterid],
        "filterValues": [filtervalue]
      });
      print('combo1 ' + formData);
      final response = await http.post(url, headers: headers, body: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> userid = list["dataValue"];
        return userid;
      } else {
        return [];
      }
    } on SocketException catch (error) {
      throw NoInternetException('No Internet');
    } on HttpException {
      throw NoServiceFoundException('No Service Found');
    } on FormatException {
      throw InvalidFormatException('Invalid Data Format');
    } catch (error) {
      throw UnknownException(error.message);
    }
  }

  // DRUG_NAME_FETCH
  Future<List<dynamic>> _getDrugName() async {
    var list, val;

    if (_drugId == null) {
      val = 104;
    } else {
      val = _drugId;
    }

    String url;
    var filtervalue, filterid;
    switch ('${widget.heading}') {
      case 'Rate Contract':
        url = RATE_DRUG_NAME_URL;
        filterid = '73';
        filtervalue = val;
        break;
      case 'Common Essential Drugs':
        url = COMMAN_ESSENTAIL_FACILITY_COMBO;
        filterid = '67';
        filtervalue = '';
        break;
      case 'Drugs Excess/Shortage':
        url = DRUG_COMBO_DRUGS_EXCESS;
        filterid = '70';
        filtervalue = '';
        break;
      case 'Stock Out Detail V 2.0':
        url = COMBO_MONTH_STOCKOUTV2;
        filterid = '68';
        filtervalue = '';
        break;
    }
    print('combo2++++++ $url');
    try {
      final formData = jsonEncode({
        "seatId": "$_id",
        "filterIds": [filterid],
        "filterValues": [filtervalue]
      });
      print('combo2++++++ ' + formData);
      final response = await http.post(url, headers: headers, body: formData);
      if (response.statusCode == 200) {
        list = json.decode(response.body);
        userid = list["dataValue"];
        return list["dataValue"];
      } else {
        return [];
      }
    } on SocketException catch (error) {
      throw NoInternetException('No Internet');
    } on HttpException {
      throw NoServiceFoundException('No Service Found');
    } on FormatException {
      throw InvalidFormatException('Invalid Data Format');
    } catch (error) {
      throw UnknownException(error.message);
    }
  }

  void getDropDownItem() {
    setState(() {
      holder = selectedValue;
    });
  }

  void getDrugNameDrop() {
    setState(() {
      holderName = selectDrugNameValue;
    });
  }

  void getYear() {
    setState(() {
      year = selectDrugNameValue;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  final StoreNameLabel = const Text(
    'Store Name:',
    style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
  );


  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Container(
          margin: EdgeInsets.all(10),
          child: Text('${widget.heading.toUpperCase()}',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600))),
          '${widget.heading}' == 'EDL Details'
              ? Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            color: Colors.white70,
            elevation: 5,
            child: Column(children: [

              Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Zone Name:  ",
                          style: new TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      Expanded(
                        child: Container(
                          // margin: EdgeInsets.only(top: 30),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: new Container(
                                    width: 350,
                                    child: FutureBuilder(
                                        future: _getDrugName(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<dynamic>>
                                            snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.data == null) {
                                              return Center(
                                                  child:
                                                  Text('No Zone Found!'));
                                            } else {
                                              return SearchableDropdown(
                                                hint:
                                                Text('Search Zone name'),
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 13,
                                                    color: Colors.black),
                                                items:
                                                snapshot.data.map((item) {
                                                  return new DropdownMenuItem<
                                                      String>(
                                                    value: item[1].toString(),
                                                    child: Text(
                                                      item[2],
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'Poppins',
                                                          fontSize: 13),
                                                    ),
                                                  );
                                                }).toList(),
                                                isExpanded: true,
                                                value: selectDrugNameValue,
                                                isCaseSensitiveSearch: true,
                                                onChanged: (value) async {
                                                  setState(() {
                                                    selectDrugNameValue =
                                                        value;
                                                    _drugNameId = value;
                                                  });
                                                  getDrugNameDrop();
                                                },
                                              );
                                            }
                                          } else if (snapshot.hasError &&
                                              snapshot.connectionState ==
                                                  ConnectionState.done) {
                                            return Text('Error'); // error
                                          } else {
                                            return Center(
                                                child: Text(
                                                    "loading...")); // loading
                                          }
                                        })),
                              ),
                            )),
                      ),
                    ],
                  )),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("State Name :  ",
                          style: new TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      Expanded(
                        child: Container(
                          // margin: EdgeInsets.only(top: 30),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: new Container(
                                    width: 350,
                                    child: FutureBuilder(
                                        future: _getDrugName(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<dynamic>>
                                            snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.data == null) {
                                              return Center(
                                                  child:
                                                  Text('No State Found!'));
                                            } else {
                                              return SearchableDropdown(
                                                hint:
                                                Text('Search State Name'),
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 13,
                                                    color: Colors.black),
                                                items:
                                                snapshot.data.map((item) {
                                                  return new DropdownMenuItem<
                                                      String>(
                                                    value: item[1].toString(),
                                                    child: Text(
                                                      item[2],
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'Poppins',
                                                          fontSize: 13),
                                                    ),
                                                  );
                                                }).toList(),
                                                isExpanded: true,
                                                value: selectDrugNameValue,
                                                isCaseSensitiveSearch: true,
                                                onChanged: (value) async {
                                                  setState(() {
                                                    selectDrugNameValue =
                                                        value;
                                                    _drugNameId = value;
                                                  });
                                                  getDrugNameDrop();
                                                },
                                              );
                                            }
                                          } else if (snapshot.hasError &&
                                              snapshot.connectionState ==
                                                  ConnectionState.done) {
                                            return Text('Error'); // error
                                          } else {
                                            return Center(
                                                child: Text(
                                                    "loading...")); // loading
                                          }
                                        })),
                              ),
                            )),
                      ),
                    ],
                  )),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Facility :  ",
                          style: new TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      Expanded(
                        child: Container(
                          // margin: EdgeInsets.only(top: 30),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: new Container(
                                    width: 350,
                                    child: FutureBuilder(
                                        future: _getDrugName(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<dynamic>>
                                            snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.data == null) {
                                              return Center(
                                                  child:
                                                  Text('No Facility Found!'));
                                            } else {
                                              return SearchableDropdown(
                                                hint:
                                                Text('Search facility Type'),
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 13,
                                                    color: Colors.black),
                                                items:
                                                snapshot.data.map((item) {
                                                  return new DropdownMenuItem<
                                                      String>(
                                                    value: item[1].toString(),
                                                    child: Text(
                                                      item[2],
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'Poppins',
                                                          fontSize: 13),
                                                    ),
                                                  );
                                                }).toList(),
                                                isExpanded: true,
                                                value: selectDrugNameValue,
                                                isCaseSensitiveSearch: true,
                                                onChanged: (value) async {
                                                  setState(() {
                                                    selectDrugNameValue =
                                                        value;
                                                    _drugNameId = value;
                                                  });
                                                  getDrugNameDrop();
                                                },
                                              );
                                            }
                                          } else if (snapshot.hasError &&
                                              snapshot.connectionState ==
                                                  ConnectionState.done) {
                                            return Text('Error'); // error
                                          } else {
                                            return Center(
                                                child: Text(
                                                    "loading...")); // loading
                                          }
                                        })),
                              ),
                            )),
                      ),
                    ],
                  )),
            ]),
          )
              : Container(),
      '${widget.heading}' == 'Rate Contract'
          ? Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white70,
              elevation: 5,
              child: Column(children: [
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Drug Type:  ",
                            style: new TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                        Expanded(
                          child: Container(
                            // margin: EdgeInsets.only(top: 10, bottom: 10),
                            // padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: new Container(
                                width: 350,
                                child: FutureBuilder(
                                  future: _getfilterdropdownType(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<dynamic>> snapshot) {
                                    if (snapshot.hasData) {
                                      List<dynamic> drugsName = snapshot.data;

                                      return SearchableDropdown(
                                        hint: 'Search drug type',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13,
                                            color: Colors.black),
                                        items: drugsName.map((item) {
                                          // print('length ${item.length}');
                                          return new DropdownMenuItem(
                                            value: item[0].toString(),
                                            child: Text(
                                              item[1],
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13),
                                            ),
                                          );
                                        }).toList(),
                                        isExpanded: true,
                                        value: selectedValue,
                                        isCaseSensitiveSearch: false,
                                        onChanged: (value) async {
                                          setState(() {
                                            selectedValue = value[1].toString();
                                            _drugId = value;
                                          });
                                          getDropDownItem();
                                        },
                                      );
                                    } else {
                                      return Center(child: Text("loading..."));
                                    }
                                  },
                                )),
                          ),
                        ),
                      ],
                    )),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Drug Name:  ",
                            style: new TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                        Expanded(
                          child: Container(
                              // margin: EdgeInsets.only(top: 30),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: new Container(
                                      width: 350,
                                      child: FutureBuilder(
                                          future: _getDrugName(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<List<dynamic>>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              if (snapshot.data == null) {
                                                return Center(
                                                    child:
                                                        Text('No Drug Found!'));
                                              } else {
                                                return SearchableDropdown(
                                                  hint:
                                                      Text('Search drug name'),
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 13,
                                                      color: Colors.black),
                                                  items:
                                                      snapshot.data.map((item) {
                                                    return new DropdownMenuItem<
                                                        String>(
                                                      value: item[1].toString(),
                                                      child: Text(
                                                        item[2],
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 13),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  isExpanded: true,
                                                  value: selectDrugNameValue,
                                                  isCaseSensitiveSearch: true,
                                                  onChanged: (value) async {
                                                    setState(() {
                                                      selectDrugNameValue =
                                                          value;
                                                      _drugNameId = value;
                                                    });
                                                    getDrugNameDrop();
                                                  },
                                                );
                                              }
                                            } else if (snapshot.hasError &&
                                                snapshot.connectionState ==
                                                    ConnectionState.done) {
                                              return Text('Error'); // error
                                            } else {
                                              return Center(
                                                  child: Text(
                                                      "loading...")); // loading
                                            }
                                          })),
                                ),
                              )),
                        ),
                      ],
                    )),
              ]),
            )
          : Container(),
      '${widget.heading}' == 'Demand Procurement Status'
          ? Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white70,
              elevation: 5,
              child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("Year:  ",
                                style: new TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                                  ,
                                )),
                            Expanded(
                              child: new Container(
                                  width: 350,
                                  child: FutureBuilder(
                                      future: _getfilterdropdownType(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<dynamic>>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.data == null) {
                                            return Center(
                                                child: Text('Year not found!'));
                                          } else {
                                            return SearchableDropdown(
                                              hint: Text('Search Year'),
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13,
                                                  color: Colors.black),
                                              items: snapshot.data.map((item) {
                                                return new DropdownMenuItem<
                                                    String>(
                                                  value: item[1],
                                                  child: Text(
                                                    item[1],
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 13),
                                                  ),
                                                );
                                              }).toList(),
                                              isExpanded: true,
                                              value: selectYear,
                                              isCaseSensitiveSearch: false,
                                              onChanged: (value) async {
                                                setState(() {
                                                  selectYear = value;
                                                  _yeard = value;
                                                });
                                                getYear();
                                              },
                                            );
                                          }
                                        } else if (snapshot.hasError &&
                                            snapshot.connectionState ==
                                                ConnectionState.done) {
                                          return Text('Error'); // error
                                        } else {
                                          return Center(
                                              child: Text(
                                                  "loading...")); // loading
                                        }
                                      })),
                            ),
                          ],
                        )),
                  )))
          : Container(),
      '${widget.heading}' == 'Common Essential Drugs'
          ? Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white70,
              elevation: 5,
              child: Column(children: [
                Container(
                  // width: 300,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('State: ',
                          style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      new Expanded(
                          child: Container(
                        // margin: EdgeInsets.only(top: 10, bottom: 10),
                        // padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: new Container(
                            width: 350,
                            child: FutureBuilder(
                              future: _getfilterdropdownType(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.hasData) {
                                  List<dynamic> drugsName = snapshot.data;
                                  return SearchableDropdown(
                                    hint: 'All',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        color: Colors.black),
                                    items: drugsName.map((item) {
                                      return new DropdownMenuItem(
                                        value: item[1].toString(),
                                        child: Text(
                                          item[2],
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13),
                                        ),
                                      );
                                    }).toList(),
                                    isExpanded: true,
                                    value: selectedValue,
                                    isCaseSensitiveSearch: false,
                                    onChanged: (value) async {
                                      setState(() {
                                        selectedValue = value;
                                        _drugId = value;
                                      });
                                      getDropDownItem();
                                    },
                                  );
                                } else {
                                  return Center(child: Text("loading..."));
                                }
                              },
                            )),
                      )),
                    ],
                  ),
                ),
                Container(
                  // width: 300,
                  // margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Text('Facility',
                          style: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      new Expanded(
                          child: Container(
                        // margin: EdgeInsets.only(top: 10, bottom: 10),
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: new Container(
                            width: 350,
                            child: FutureBuilder(
                              future: _getDrugName(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.hasData) {
                                  List<dynamic> drugsName = snapshot.data;

                                  return SearchableDropdown(
                                    hint: 'All',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        color: Colors.black),
                                    items: drugsName.map((item) {
                                      return new DropdownMenuItem(
                                        value: item[0].toString(),
                                        child: Text(
                                          item[2],
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13),
                                        ),
                                      );
                                    }).toList(),
                                    isExpanded: true,
                                    value: selectedValue,
                                    isCaseSensitiveSearch: false,
                                    onChanged: (value) async {
                                      setState(() {
                                        selectedValue = value;
                                        _drugId = value;
                                      });
                                      getDropDownItem();
                                    },
                                  );
                                } else {
                                  return Center(child: Text("loading..."));
                                }
                              },
                            )),
                      )),
                    ],
                  ),
                ),
              ]))
          : Container(),
      '${widget.heading}' == 'Drugs Excess/Shortage'
          ? Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white70,
              elevation: 5,
              child: Column(children: [
                Container(
                  // width: 300,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Text('State:',
                          style: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      new Expanded(
                          child: Container(
                        // margin: EdgeInsets.only(top: 10, bottom: 10),
                        // padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: new Container(
                            width: 350,
                            child: FutureBuilder(
                              future: _getfilterdropdownType(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.hasData) {
                                  List<dynamic> drugsName = snapshot.data;
                                  return SearchableDropdown(
                                    hint: 'All',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        color: Colors.black),
                                    items: drugsName.map((item) {
                                      return new DropdownMenuItem(
                                        value: item[0].toString(),
                                        child: Text(
                                          item[1],
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13),
                                        ),
                                      );
                                    }).toList(),
                                    isExpanded: true,
                                    value: selectedValue,
                                    isCaseSensitiveSearch: false,
                                    onChanged: (value) async {
                                      setState(() {
                                        selectedValue = value;
                                        _drugId = value;
                                      });
                                      getDropDownItem();
                                    },
                                  );
                                } else {
                                  return Center(child: Text("loading..."));
                                }
                              },
                            )),
                      )),
                    ],
                  ),
                ),
                Container(
                    // width: 300,
                    // margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Text('Drug Name :',
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          new Expanded(
                            child: Container(
                              // margin: EdgeInsets.only(top: 10, bottom: 10),
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: new Container(
                                  width: 350,
                                  child: FutureBuilder(
                                      future: _getDrugName(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<dynamic>>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.data == null) {
                                            return Center(
                                                child: Text('no data'));
                                          } else {
                                            return SearchableDropdown(
                                              hint: Text('All'),
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13,
                                                  color: Colors.black),
                                              items: snapshot.data.map((item) {
                                                return new DropdownMenuItem<
                                                    String>(
                                                  value: item[0].toString(),
                                                  child: Text(
                                                    item[1],
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 13),
                                                  ),
                                                );
                                              }).toList(),
                                              isExpanded: true,
                                              value: selectDrugNameValue,
                                              isCaseSensitiveSearch: true,
                                              onChanged: (value) async {
                                                setState(() {
                                                  selectDrugNameValue = value;
                                                  _drugNameId = value;
                                                });
                                                getDrugNameDrop();
                                              },
                                            );
                                          }
                                        } else if (snapshot.hasError &&
                                            snapshot.connectionState ==
                                                ConnectionState.done) {
                                          return Text('Error'); // error
                                        } else {
                                          return Center(
                                              child: Text(
                                                  "loading...")); // loading
                                        }
                                      })),
                            ),
                          ),
                        ]))
              ]))
          : Container(),
      '${widget.heading}' == 'Stock Out Detail V 2.0'
          ? Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white70,
              elevation: 5,
              child: Column(children: [
                Container(
                  // width: 300,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Text('Facility: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  color: Color(0xff4b2b59),
                                  fontWeight: FontWeight.w500)),
                      new Expanded(
                          child: Container(
                        // margin: EdgeInsets.only(top: 10, bottom: 10),
                        // padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: new Container(
                            width: 350,
                            child: FutureBuilder(
                              future: _getfilterdropdownType(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.hasData) {
                                  List<dynamic> drugsName = snapshot.data;

                                  return SearchableDropdown(
                                    hint: 'All',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        color: Colors.black),
                                    items: drugsName.map((item) {
                                      return new DropdownMenuItem(
                                        value: item[0].toString(),
                                        child: Text(
                                          item[2],
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13),
                                        ),
                                      );
                                    }).toList(),
                                    isExpanded: true,
                                    value: selectedValue,
                                    isCaseSensitiveSearch: false,
                                    onChanged: (value) async {
                                      setState(() {
                                        selectedValue = value;
                                        _drugId = value;
                                      });
                                      getDropDownItem();
                                    },
                                  );
                                } else {
                                  return Center(child: Text("loading..."));
                                }
                              },
                            )),
                      )),
                    ],
                  ),
                ),
                Container(
                    // width: 300,
                    // margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Text('Month: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                      color: Color(0xff4b2b59),
                                      fontWeight: FontWeight.w500)),
                          new Expanded(
                              child: Container(
                                  // margin: EdgeInsets.only(top: 30),
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10.0),
                                      child: new Container(
                                          width: 350,
                                          child: FutureBuilder(
                                              future: _getDrugName(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<List<dynamic>>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  if (snapshot.data == null) {
                                                    return Center(
                                                        child: Text('no data'));
                                                  } else {
                                                    return SearchableDropdown(
                                                      hint: Text('Month'),
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 13,
                                                          color: Colors.black),
                                                      items: snapshot.data
                                                          .map((item) {
                                                        return new DropdownMenuItem<
                                                            String>(
                                                          value: item[1]
                                                              .toString(),
                                                          child: Text(
                                                            item[2],
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 13),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      isExpanded: true,
                                                      value:
                                                          selectDrugNameValue,
                                                      isCaseSensitiveSearch:
                                                          true,
                                                      onChanged: (value) async {
                                                        setState(() {
                                                          selectDrugNameValue =
                                                              value;
                                                          _drugNameId = value;
                                                        });
                                                        getDrugNameDrop();
                                                      },
                                                    );
                                                  }
                                                } else if (snapshot.hasError &&
                                                    snapshot.connectionState ==
                                                        ConnectionState.done) {
                                                  return Text('Error'); // error
                                                } else {
                                                  return Center(
                                                      child: Text(
                                                          "loading...")); // loading
                                                }
                                              })),
                                    ),
                                  ))),
                        ]))
              ]))
          : Container(),
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
                                          Icon(Icons.pie_chart),
                                          Container(
                                            margin: EdgeInsets.only(left: 8),
                                            child: Text('Charts'),
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
                                          Icon(Icons.table_chart),
                                          Container(
                                            margin: EdgeInsets.only(left: 8),
                                            child: Text('Tabular'),
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
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20, bottom: 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: DropdownButton(
                                        isExpanded: false,
                                        hint: Text('Select the format'),
                                        value: _selectedLocation,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedLocation = newValue;
                                          });
                                        },
                                        items: _locations.map((location) {
                                          return DropdownMenuItem(
                                            child: new Text(location),
                                            value: location,
                                          );
                                        }).toList(),
                                      ))
                                ]),
                          ),
                          _selectedLocation == 'Column Bar Graph' ||
                                  _selectedLocation == ''
                              ? Container(

                                  child: getBarChartWidget())
                              : Container
                            (child: getLineChartWidget()
                          )
                        ],
                      ),
                    )),
                    Container(
                        child: TableDetail(
                      head: '${widget.heading}',
                      dId: _drugNameId,
                      dyear: _yeard,
                    )),
                  ]),
                )),
          ))
    ]));
  }
  Widget getLineChartWidget(){
    switch('${widget.heading}'){
      case 'EDL Details':

        return LineChartEDL(
          bhead: '${widget.heading}',
          dId: _drugNameId,
          dyear: _yeard,
        );
        break;
      case 'Rate Contract':
        return LineChartRateContract(
          bhead: '${widget.heading}',
          dId: _drugNameId,
          dyear: _yeard,
        );
        break;
      case 'Demand Procurement Status':

        return LineChartDeamnd(
          bhead: '${widget.heading}',
          dId: _drugNameId,
          dyear: _yeard,
        );
        break;

      default:

        break;
    }
  }
  Widget getBarChartWidget(){
    switch('${widget.heading}'){
      case 'EDL Details':

        return BarchartEDL(
          bhead: '${widget.heading}',
          dId: _drugNameId,
          dyear: _yeard,

        );
        break;
      case 'Rate Contract':
        return BarchartRateContract(
          bhead: '${widget.heading}',
          dId: _drugNameId,
          dyear: _yeard,

        );
        break;
      case 'Demand Procurement Status':

        return BarchartDemand(
          bhead: '${widget.heading}',
          dId: _drugNameId,
          dyear: _yeard,

        );
        break;

      default:

        break;
    }
  }
}
