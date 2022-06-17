import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/historyModel.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightModel.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightRepo.dart';

import '../../../../locator.dart';
import '../../../shared/toasts.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage();

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _weightRepo = locator.get<WeightRepo>();
  List<WeightModel> weightsList = [];
  List<String> weightsListKeys = [];

  _HistoryPageState();

  Widget projectWidget() {
    return FutureBuilder(
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
                      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: new Center(
                        child: new Text('There is no history',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,),
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
                                ' Date : ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                weightsList[index].date,
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
                                ' Time : ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                weightsList[index].time,
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
                              Icon(Icons.monitor_weight_outlined),
                              Text(
                                ' Weight : ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                weightsList[index].weight.toString(),
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
        title: Text('Delete History'),
        content: Text('Are you sure you want to delete this data'),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),
          TextButton(onPressed: (){
            setState(() {
              _weightRepo.deleteWeightMeasurement(weightsListKeys[index]);
              Navigator.pop(context);
            });

          }, child: Text('Yes')),
        ],
      );
    });
  }
}
