import 'package:intl/intl.dart';

class AppointmentModel{
  String date;
  String timeSlot;
  int dateInt;


  AppointmentModel(this.date, this.timeSlot, this.dateInt);

  factory AppointmentModel.fromJson(Map<dynamic, dynamic> json) {
    final date = json['date'] as String;
    final timeSlot = json['timeSlot'] as String;
    final dateInt = json['dateInt'] as int;
    return AppointmentModel(date, timeSlot, dateInt);
  }

  Map<dynamic, dynamic> toJson() =>
      {'date': date, 'timeSlot': timeSlot, 'dateInt': dateInt};

  @override
  String toString() {
    return 'WeightModel{date: $date, time: $timeSlot, , dateInt: $dateInt}';
  }
}
