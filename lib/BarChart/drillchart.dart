import 'package:flutter/material.dart';
import '../Tabular/drillTable.dart';
import 'drillbarchart.dart';

class DrillChart extends StatefulWidget {
  final String stateName, stateId;
  
  DrillChart({Key key, @required this.stateName, @required this.stateId}) : super(key: key);
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<DrillChart> {
  List<String> _locations = ['Graph', 'Tabular Format'];
  String _selected = 'Graph';

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.stateName}'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
              height: 800,
              child: Column(children: [
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        DropdownButton(
                          hint: Text('Option'), // Not necessary for Option 1
                          value: _selected,
                          onChanged: (newValue) {
                            setState(() {
                              _selected = newValue; 
                            });
                          },
                          items: _locations.map((location) {
                            return DropdownMenuItem(
                              child: new Text(location),
                              value: location,
                            );
                          }).toList(),
                        ),
                      ]),
                ),
                _selected == 'Graph'
                    ? SizedBox(height: 400, child: DrillchartTab(drillStateid: '${widget.stateId}'))
                    : SizedBox(height: 400, child: DrillTableDetail(drillStateid: '${widget.stateId}'))
              ]) // ),
              ),
        )));
  }
}
