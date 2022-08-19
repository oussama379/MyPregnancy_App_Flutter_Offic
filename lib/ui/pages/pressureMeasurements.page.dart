import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ma_grossesse/ui/pages/pressureMeasurments/tabs/HistoryTabPressure.dart';
import 'package:ma_grossesse/ui/pages/pressureMeasurments/tabs/InputTabPressure.dart';
import 'package:ma_grossesse/ui/pages/pressureMeasurments/tabs/chartTabPressure.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/tabs/HistoryTab.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/tabs/InputTab.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/tabs/chartTab.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

import '../../app_localizations.dart';
import '../sharedServices/checkInternetConnection.dart';

class PressureMeasure extends StatefulWidget {
  @override
  State<PressureMeasure> createState() => _PressureMeasureState();
}

class _PressureMeasureState extends State<PressureMeasure> {

  var _currentSelection = 0;

  late Map _source = {ConnectivityResult.wifi: true};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  //return the status of the internet cnx
  void updateCnx() {
    _connectivity.myStream.listen((source) {
      if (this.mounted) {
        setState(() {
          _source = source;
          print(_source.keys.toList()[0]);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    updateCnx();
  }

  @override
  Widget build(BuildContext context) {
    Map<int, Widget> _children = {
      0: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          width: 5,
        ),
        Text(
          AppLocalizations.of(context)!.translate('weight_page_tab_1'),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 5,
        ),
        Icon(Icons.input, size: 15,),
        SizedBox(
          width: 5,
        )
      ]),
      1: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          width: 5,
        ),
        Text(
          AppLocalizations.of(context)!.translate('weight_page_tab_2'),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 5,
        ),
        Icon(Icons.history, size: 15,),
        SizedBox(
          width: 5,
        )
      ]),
      2: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          width: 5,
        ),
        Text(
          AppLocalizations.of(context)!.translate('weight_page_tab_3'),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 5,
        ),
        Icon(Icons.area_chart, size: 15,),
        SizedBox(
          width: 5,
        )
      ]),
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('pressure_page_title')),
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
        if (_currentSelection == 0) InputPagePressure(),
        if (_currentSelection == 1) HistoryPagePressure(),

        if (_currentSelection == 2) ChartPagePressure(),
        if (_source.keys.toList()[0] != ConnectivityResult.none && _currentSelection == 2)
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
                      AppLocalizations.of(context)!.translate('pressure_page_Syst_field'),
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
                      AppLocalizations.of(context)!.translate('pressure_page_Diat_field'),
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
