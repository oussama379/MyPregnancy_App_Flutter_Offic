import 'package:intl/intl.dart';

class PressureModel implements Comparable<PressureModel> {
  int pressureSystolic;
  int pressureDiastolic;
  String date;
  String time;
  int dateInt;

  PressureModel(this.pressureSystolic, this.pressureDiastolic, this.date,
      this.time, this.dateInt);
  // @override
  // int compareTo(WeightModel other) {
  //   if (weight < other.weight) {
  //     return -1;
  //   } else if (weight > other.weight) {
  //     return 1;
  //   } else {
  //     return 0;
  //   }
  // }





  factory PressureModel.fromJson(Map<dynamic, dynamic> json) {
    final pressureSystolic = json['tensionPAS'] as int;
    final pressureDiastolic = json['tensionPAD'] as int;
    final date = json['date'] as String;
    final time = json['time'] as String;
    final dateInt = json['dateInt'] as int;
    print('in json pressureSystolic : '+ pressureSystolic.toString());
    print('in json pressureDiastolic: '+ pressureDiastolic.toString());
    return PressureModel(pressureSystolic, pressureDiastolic, date, time, dateInt);
  }

  Map<dynamic, dynamic> toJson() =>
      {'tensionPAS': pressureSystolic, 'tensionPAD': pressureDiastolic, 'date': date, 'time': time, 'dateInt': dateInt};

  @override
  String toString() {
    return 'PressureModel{pressureSystolic: $pressureSystolic, pressureDiastolic: $pressureDiastolic, date: $date, time: $time, , dateInt: $dateInt}';
  }

  @override
  int compareTo(PressureModel other) {
    throw UnimplementedError();
  }
}
