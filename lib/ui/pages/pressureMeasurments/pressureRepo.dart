import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ma_grossesse/ui/pages/pressureMeasurments/pressureModel.dart';
import '../../../globals.dart' as globals;

class PressureRepo {

  DatabaseReference reference = FirebaseDatabase.instance
      .reference()
      .child('Patientes')
      .child(globals.UID.toString())
      .child("mesures")
      .child("tension");


  PressureModel preparePressureModel(int pressureSystolic, int pressureDiastolic, DateTime date, DateTime time) {
    String timeToBeSaved = DateFormat.jm().format(time);
    String dateToBeSaved = DateFormat('dd/MM/yyyy').format(date);
    int pressureSystolicToBeSaved = pressureSystolic;
    int pressureDiastolicToBeSaved = pressureDiastolic;
    String dateIntString  = DateFormat('yyyy/MM/dd').format(date).replaceAll('/', '');
    int datInt = int.parse(dateIntString);
    return PressureModel(pressureSystolic, pressureDiastolic, dateToBeSaved, timeToBeSaved, datInt);
  }

  Future<bool> deletePressureMeasurement(String key) async {
    print('key : ');
    print(key);
    reference.child(key).remove().whenComplete(() { print('Done'); return true;});
    return true;
  }

  Future<void> SavePressureMeasurements(Map<dynamic, dynamic> json) async {
    String key = FirebaseDatabase.instance
        .reference()
        .child('Patientes')
        .child(globals.UID.toString())
        .child("mesures")
        .child("tension")
        .push()
        .key;
    await FirebaseDatabase.instance
        .reference()
        .child('Patientes')
        .child(globals.UID.toString())
        .child("mesures")
        .child("tension")
        .child(key)
        .set(json);
  }

  final Query _pressureHistory = FirebaseDatabase.instance
      .reference()
      .child('Patientes')
      .child(globals.UID.toString())
      .child("mesures")
      .child("tension").orderByChild('dateInt');

  Query getPressureHistoryHistory() {
    return _pressureHistory;
  }

}
