import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ma_grossesse/ui/pages/pressureMeasurments/tabs/HistoryTabPressure.dart';
import 'package:ma_grossesse/ui/pages/pressureMeasurments/tabs/InputTabPressure.dart';
import 'package:ma_grossesse/ui/pages/pressureMeasurments/tabs/chartTabPressure.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/tabs/HistoryTab.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/tabs/InputTab.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/tabs/chartTab.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class PressureMeasure extends StatefulWidget {
  @override
  State<PressureMeasure> createState() => _PressureMeasureState();
}

class _PressureMeasureState extends State<PressureMeasure> {
  Map<int, Widget> _children = {
    0: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        width: 7,
      ),
      Text(
        'Input',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(
        width: 7,
      ),
      Icon(Icons.input),
      SizedBox(
        width: 7,
      )
    ]),
    1: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        width: 7,
      ),
      Text(
        'History',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(
        width: 7,
      ),
      Icon(Icons.history),
      SizedBox(
        width: 7,
      )
    ]),
    2: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        width: 7,
      ),
      Text(
        'Chart',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(
        width: 7,
      ),
      Icon(Icons.area_chart),
      SizedBox(
        width: 7,
      )
    ]),
  };
  var _currentSelection = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pressure Measurements'),
      ),
      body: ListView(children: [
        MaterialSegmentedControl(
          children: _children,
          selectionIndex: _currentSelection,
          borderColor: Colors.grey,
          selectedColor: Colors.pinkAccent,
          unselectedColor: Colors.white,
          borderRadius: 6.0,
          verticalOffset: 12.0,
          horizontalPadding: EdgeInsets.all(15),
          onSegmentChosen: (index) {
            setState(() {
              _currentSelection = index as int;
            });
          },
        ),
        if (_currentSelection == 0) Center(child: InputPagePressure()),
        if (_currentSelection == 1) HistoryPagePressure(),
        if (_currentSelection == 2) ChartPagePressure(),
        if (_currentSelection == 2)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 15,
                      height: 15,
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Systolic blood pressure',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: 15,
                      height: 15,
                      decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Diastolic blood pressure',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    )
                  ],
                ),
              ],
            ),
          ),

      ]),
    );
  }
}
