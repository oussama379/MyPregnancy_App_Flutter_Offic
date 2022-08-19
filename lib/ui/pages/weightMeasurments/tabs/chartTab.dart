import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightModel.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightRepo.dart';
import '../../../../app_localizations.dart';
import '../../../../globals.dart' as globals;

import '../../../../locator.dart';
import '../../../shared/toasts.dart';
import '../../../sharedServices/checkInternetConnection.dart';
import '../widget/line_chart_widget.dart';

class ChartPage extends StatefulWidget {
  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final _weightRepo = locator.get<WeightRepo>();

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
    return _source.keys.toList()[0] == ConnectivityResult.none
        ? Center(
            child: Container(
              height: 120.0,
              width: 300.0,
              color: Colors.transparent,
              child: Container(
                  padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Icon(
                          Icons.signal_wifi_off,
                          size: 40,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('info_page_cnx_error_msg'),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )),
            ),
          )
        : Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: Colors.grey.shade300,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: LineChartWidget(),
            ),
          );
  }
}
