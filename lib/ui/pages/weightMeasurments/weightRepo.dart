import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightModel.dart';
import '../../../globals.dart' as globals;


class WeightRepo {

  WeightModel prepareWeightModel(double weight, DateTime date, DateTime time){
    String timeToBeSaved = DateFormat.jm().format(time);
    String dateToBeSaved = DateFormat('dd/MM/yyyy').format(date);
    double weightToBeSaved = weight;
    return WeightModel(weightToBeSaved, dateToBeSaved, timeToBeSaved);
  }

  Future<void> SaveWeightMeasurements(Map<dynamic, dynamic> json) async {
    String key = FirebaseDatabase.instance.reference().child('Patientes').child(globals.UID.toString()).child("mesures").child("poids").push().key;
    await FirebaseDatabase.instance.reference().child('Patientes').child(globals.UID.toString()).child("mesures").child("poids").child(key).set(json);
  }




  WeightRepo();
}
