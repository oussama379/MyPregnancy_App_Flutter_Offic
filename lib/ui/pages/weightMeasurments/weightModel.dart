import 'package:intl/intl.dart';

class WeightModel {
  int weight;
  String date;
  String time;

  WeightModel(this.weight, this.date, this.time);


  factory WeightModel.fromJson(Map<dynamic, dynamic> json){
      final weight = json['poids'] as int;
      final date = json['date'] as String;
      final time = json['time'] as String;
      return WeightModel(weight, date, time);
  }

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