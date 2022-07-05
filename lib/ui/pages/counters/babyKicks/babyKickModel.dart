import 'package:intl/intl.dart';

class BabyKickModel   {
  int quantity;
  String dateAndTime;
  String duration;
  int dateInt;

  BabyKickModel(this.quantity, this.dateAndTime, this.duration, this.dateInt);

  factory BabyKickModel.fromJson(Map<dynamic, dynamic> json) {
    final quantity = json['quantity'] as int;
    final dateAndTime = json['dateAndTime'] as String;
    final duration = json['duration'] as String;
    final dateInt = json['dateInt'] as int;
    return BabyKickModel(quantity, dateAndTime, duration, dateInt);
  }

  Map<dynamic, dynamic> toJson() =>
      {'quantity': quantity, 'dateAndTime': dateAndTime, 'duration': duration, 'dateInt': dateInt};

  @override
  String toString() {
    return 'BabyKickModel{quantity: $quantity, dateAndTime: $dateAndTime, duration: $duration, , dateInt: $dateInt}';
  }
}
