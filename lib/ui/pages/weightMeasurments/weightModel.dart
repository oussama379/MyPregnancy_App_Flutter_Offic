import 'package:intl/intl.dart';

class WeightModel {
  double weight;
  String date;
  String time;

  WeightModel(this.weight, this.date, this.time);


  WeightModel.fromJson(Map<dynamic, dynamic> json)
      : weight = json['poids'] as double,
        date = json['date'] as String,
        time = json['time'] as String;

  Map<dynamic, dynamic> toJson() =>
      {
        'poids': weight,
        'date': date,
        'time': time
      };


  @override
  String toString() {
    return 'WeightModel{weight: $weight, date: $date, time: $time}';
  }
}