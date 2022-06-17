import 'package:intl/intl.dart';

class WeightModel implements Comparable<WeightModel> {
  int weight;
  String date;
  String time;
  int dateInt;

  @override
  int compareTo(WeightModel other) {
    if (weight < other.weight) {
      return -1;
    } else if (weight > other.weight) {
      return 1;
    } else {
      return 0;
    }
  }

  WeightModel(this.weight, this.date, this.time, this.dateInt);

  factory WeightModel.fromJson(Map<dynamic, dynamic> json) {
    final weight = json['poids'] as int;
    final date = json['date'] as String;
    final time = json['time'] as String;
    final dateInt = json['dateInt'] as int;
    return WeightModel(weight, date, time, dateInt);
  }

  Map<dynamic, dynamic> toJson() =>
      {'poids': weight, 'date': date, 'time': time, 'dateInt': dateInt};

  @override
  String toString() {
    return 'WeightModel{weight: $weight, date: $date, time: $time, , dateInt: $dateInt}';
  }
}
