import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/historyModel.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightModel.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightRepo.dart';

import '../../../../app_localizations.dart';
import '../../../../locator.dart';
import '../../../shared/toasts.dart';
import '../../../sharedServices/checkInternetConnection.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage();

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _weightRepo = locator.get<WeightRepo>();
  List<WeightModel> weightsList = [];
  List<String> weightsListKeys = [];

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

  Widget projectWidget() {
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
        : FutureBuilder(
            future: _weightRepo.getWeightHistory().once(),
            builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
              weightsList.clear();
              weightsListKeys.clear();
              if (snapshot.hasData) {
                Map<dynamic, dynamic> values = snapshot.data!.value;
                if (values == null)
                  return Center(
                    child: Container(
                      height: 100.0,
                      width: 300.0,
                      color: Colors.transparent,
                      child: Container(
                          padding:
                              const EdgeInsets.only(right: 10.0, left: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.pinkAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: new Center(
                            child: new Text(
                              AppLocalizations.of(context)!
                                  .translate('weight_history_noHistory'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                  );
                values.forEach((key, values) {
                  weightsListKeys.add(key);
                  weightsList.add(WeightModel.fromJson(values));
                });
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: weightsList.length,
                  itemBuilder: (context, index) {
                    // print(index);
                    // print(weightsList[index].toString());
                    // print(weightsListKeys[index]);
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.5, //
                              color: Colors
                                  .pink //                <--- border width here
                              ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Icon(Icons.date_range),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate('weight_history_date_field'),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    weightsList[index].date,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  )
                                ]),
                                Row(children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Icon(Icons.watch_later_outlined),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate('weight_history_time_field'),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    weightsList[index].time,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  )
                                ]),
                                Row(children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Icon(Icons.monitor_weight_outlined),
                                  Text(
                                    AppLocalizations.of(context)!.translate(
                                        'weight_history_weight_field'),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    weightsList[index].weight.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  )
                                ]),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                icon: new Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showDeleteDialog(index);
                                    // _weightRepo.deleteWeightMeasurement(
                                    //     weightsListKeys[index]);
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            });
  }

  @override
  Widget build(BuildContext context) {
    return projectWidget();
  }

  void _showDeleteDialog(var index) {
    showDialog(
        context: this.context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!
                .translate('weight_history_dialog_title')),
            content: Text(AppLocalizations.of(context)!
                .translate('weight_history_dialog_text')),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!
                      .translate('weight_history_dialog_cancel'))),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _weightRepo
                          .deleteWeightMeasurement(weightsListKeys[index]);
                      Navigator.pop(context);
                    });
                  },
                  child: Text(AppLocalizations.of(context)!
                      .translate('weight_history_dialog_confirm'))),
            ],
          );
        });
  }
}
