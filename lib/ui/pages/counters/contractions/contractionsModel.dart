import 'package:intl/intl.dart';

class ContractionsModel   {
  int quantity;
  String dateAndTime;
  String duration;
  int dateInt;

  ContractionsModel(this.quantity, this.dateAndTime, this.duration, this.dateInt);

  factory ContractionsModel.fromJson(Map<dynamic, dynamic> json) {
    final quantity = json['quantity'] as int;
    final dateAndTime = json['dateAndTime'] as String;
    final duration = json['duration'] as String;
    final dateInt = json['dateInt'] as int;
    return ContractionsModel(quantity, dateAndTime, duration, dateInt);
  }

  Map<dynamic, dynamic> toJson() =>
      {'quantity': quantity, 'dateAndTime': dateAndTime, 'duration': duration, 'dateInt': dateInt};

  @override
  String toString() {
    return 'ContractionsModel{quantity: $quantity, dateAndTime: $dateAndTime, duration: $duration, , dateInt: $dateInt}';
  }
}
