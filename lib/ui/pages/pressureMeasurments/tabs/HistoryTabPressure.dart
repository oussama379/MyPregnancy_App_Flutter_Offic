import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:ma_grossesse/ui/pages/pressureMeasurments/pressureModel.dart';
import 'package:ma_grossesse/ui/pages/pressureMeasurments/pressureRepo.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/historyModel.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightModel.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightRepo.dart';

import '../../../../app_localizations.dart';
import '../../../../locator.dart';
import '../../../shared/toasts.dart';

class HistoryPagePressure extends StatefulWidget {

  @override
  State<HistoryPagePressure> createState() => _HistoryPageStatePressure();
}

class _HistoryPageStatePressure extends State<HistoryPagePressure> {
  final _pressureRepo = locator.get<PressureRepo>();
  List<PressureModel> pressuresList = [];
  List<String>pressuresListKeys = [];



  Widget projectWidget() {
    return FutureBuilder(
        future: _pressureRepo.getPressureHistoryHistory().once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          pressuresList.clear();
          pressuresListKeys.clear();
          if (snapshot.hasData) {
            Map<dynamic, dynamic> values = snapshot.data!.value;
            if (values == null)
              return Center(
                child: Container(
                  height: 100.0,
                  width: 300.0,
                  color: Colors.transparent,
                  child: Container(
                      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: new Center(
                        child: new Text(AppLocalizations.of(context)!.translate('weight_history_noHistory'),
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,),
                      )),
                ),
              );
            values.forEach((key, values) {
              print('values : '+values.toString());
              pressuresListKeys.add(key);
              pressuresList.add(PressureModel.fromJson(values));
            });
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: pressuresList.length,
              itemBuilder: (context, index) {
                print(index);
                print(pressuresList[index].toString());
                print(pressuresListKeys[index]);
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
                                AppLocalizations.of(context)!.translate('weight_history_date_field'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                pressuresList[index].date,
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                AppLocalizations.of(context)!.translate('weight_history_time_field'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                pressuresList[index].time,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 15,
                              )
                            ]),
                            Row(children: [
                              SizedBox(
                                width: 15,
                              ),
                              Icon(Icons.monitor_heart),
                              Text(
                                AppLocalizations.of(context)!.translate('weight_history_Syst_field'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                pressuresList[index].pressureSystolic.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 15,
                              )
                            ]),
                            SizedBox(
                              width: 15,
                            ),
                        Row(children: [
                          SizedBox(
                            width: 15,
                          ),
                          Icon(Icons.monitor_heart),
                          Text(
                            AppLocalizations.of(context)!.translate('weight_history_Dias_field'),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            pressuresList[index].pressureDiastolic.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
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

  void _showDeleteDialog(var index){
    showDialog(context: this.context, builder: (context){
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('weight_history_dialog_title')),
        content: Text(AppLocalizations.of(context)!.translate('weight_history_dialog_text')),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text(AppLocalizations.of(context)!.translate('weight_history_dialog_cancel'))),
          TextButton(onPressed: (){
            setState(() {
              _pressureRepo.deletePressureMeasurement(pressuresListKeys[index]);
              Navigator.pop(context);
            });

          }, child: Text(AppLocalizations.of(context)!.translate('weight_history_dialog_confirm'))),
        ],
      );
    });
  }
}
