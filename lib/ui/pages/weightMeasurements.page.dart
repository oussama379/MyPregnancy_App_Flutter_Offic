import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/tabs/HistoryTab.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/tabs/InputTab.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/tabs/chartTab.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class WeightMeasure extends StatefulWidget {
  @override
  State<WeightMeasure> createState() => _WeightMeasureState();
}

class _WeightMeasureState extends State<WeightMeasure> {

  Map<int, Widget> _children = {
    0: Row(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 7,), Text('Input', style: TextStyle(fontWeight: FontWeight.bold),),SizedBox(width: 7,) , Icon(Icons.input),SizedBox(width: 7,)]),
    1: Row(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 7,), Text('History', style: TextStyle(fontWeight: FontWeight.bold),),SizedBox(width: 7,) , Icon(Icons.history),SizedBox(width: 7,)]),
    2: Row(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 7,), Text('Chart', style: TextStyle(fontWeight: FontWeight.bold),),SizedBox(width: 7,) , Icon(Icons.area_chart),SizedBox(width: 7,)]),
  };
  var _currentSelection = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Measurements'),
      ),
      body: ListView(
      children: [
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

        if(_currentSelection == 0)
        Center(child : InputPage()),
        if(_currentSelection == 1)
          HistoryPage(),
        if(_currentSelection == 2)
        ChartPage(),
      ]),
    );
  }
}