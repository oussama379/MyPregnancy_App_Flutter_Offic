import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightModel.dart';
import '../../../globals.dart' as globals;

class WeightRepo {

  DatabaseReference reference = FirebaseDatabase.instance
      .reference()
      .child('Patientes')
      .child(globals.UID.toString())
      .child("mesures")
      .child("poids");


  WeightModel prepareWeightModel(int weight, DateTime date, DateTime time) {
    String timeToBeSaved = DateFormat.jm().format(time);
    String dateToBeSaved = DateFormat('dd/MM/yyyy').format(date);
    int weightToBeSaved = weight;
    return WeightModel(weightToBeSaved, dateToBeSaved, timeToBeSaved);
  }

  Future<bool> deleteWeightMeasurement(String key) async {
    print('key : ');
    print(key);
    reference.child(key).remove().whenComplete(() { print('Done'); return true;});
    return true;
  }

  Future<void> SaveWeightMeasurements(Map<dynamic, dynamic> json) async {
    String key = FirebaseDatabase.instance
        .reference()
        .child('Patientes')
        .child(globals.UID.toString())
        .child("mesures")
        .child("poids")
        .push()
        .key;
    await FirebaseDatabase.instance
        .reference()
        .child('Patientes')
        .child(globals.UID.toString())
        .child("mesures")
        .child("poids")
        .child(key)
        .set(json);
  }

  final Query _weightHistory = FirebaseDatabase.instance
      .reference()
      .child('Patientes')
      .child(globals.UID.toString())
      .child("mesures")
      .child("poids");

  Query getWeightHistory() {
    return _weightHistory;
  }

  WeightRepo();
}
