import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ma_grossesse/ui/pages/appointmenets/widgets/buttonKeys.dart';
import 'package:ma_grossesse/ui/pages/appointmenets/widgets/timeTextButton.dart';

import '../../../../app_localizations.dart';

class TimeSlotsSection extends StatefulWidget {
  DateTime _selectedDay;
  Map<DateTime, List<String>> timeSlots;

  TimeSlotsSection(this._selectedDay, this.timeSlots);
  @override
  State<TimeSlotsSection> createState() => _TimeSlotsSectionState(_selectedDay, timeSlots);
}

class _TimeSlotsSectionState extends State<TimeSlotsSection> {
  DateTime _selectedDay;
  Map<DateTime, List<String>> timeSlots;

  _TimeSlotsSectionState(this._selectedDay, this.timeSlots);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, top: 5),
            child: Text(
              AppLocalizations.of(context)!.translate('appointment_page_morn'),
              style: TextStyle(
                color: Color(0xff363636),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                right: 5, left: 5, top: 15),
            child: GridView.count(
              crossAxisSpacing: 8,
              shrinkWrap: true,
              crossAxisCount: 3,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 2.7,
              children: [
                // checkTimeSlot('c1', "09:00 - 10:00"),
                // checkTimeSlot('c2', "10:00 - 11:00"),
                // checkTimeSlot('c3', "11:00 - 12:00"),
                TimeTextButton(
                    "09h-10h",
                    timeSlots[DateFormat('yyyy-MM-dd')
                        .parse(_selectedDay
                        .toString())] !=
                        null
                        ? timeSlots[DateFormat(
                        'yyyy-MM-dd')
                        .parse(_selectedDay
                        .toString())]!
                        .contains('c1') ==
                        true
                        ? true
                        : false
                        : false,
                    _selectedDay),
                TimeTextButton(
                    "10h-11h",
                    timeSlots[DateFormat('yyyy-MM-dd')
                        .parse(_selectedDay
                        .toString())] !=
                        null
                        ? timeSlots[DateFormat(
                        'yyyy-MM-dd')
                        .parse(_selectedDay
                        .toString())]!
                        .contains('c2') ==
                        true
                        ? true
                        : false
                        : false,
                    _selectedDay),
                TimeTextButton(
                    "11h-12h",
                    timeSlots[DateFormat('yyyy-MM-dd')
                        .parse(_selectedDay
                        .toString())] !=
                        null
                        ? timeSlots[DateFormat(
                        'yyyy-MM-dd')
                        .parse(_selectedDay
                        .toString())]!
                        .contains('c3') ==
                        true
                        ? true
                        : false
                        : false,
                    _selectedDay),
                //Text(timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())] != null ? timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())]!.contains('c3') ? timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())].toString() : 'YEEYEYEYEY' : DateFormat('dd-MM-yyyy').parse(_selectedDay.toString()).toString()),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, top: 20),
            child: Text(
              AppLocalizations.of(context)!.translate('appointment_page_eve'),
              style: TextStyle(
                color: Color(0xff363636),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                right: 5, left: 5, top: 15),
            child: GridView.count(
              crossAxisSpacing: 8,
              shrinkWrap: true,
              crossAxisCount: 3,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 2.6,
              children: [
                // checkTimeSlot('c4', "12:00 - 13:00"),
                // checkTimeSlot('c5', "13:00 - 14:00"),
                // checkTimeSlot('c6', "14:00 - 15:00"),
                TimeTextButton(
                    "12h-13h",
                    timeSlots[DateFormat('yyyy-MM-dd')
                        .parse(_selectedDay
                        .toString())] !=
                        null
                        ? timeSlots[DateFormat(
                        'yyyy-MM-dd')
                        .parse(_selectedDay
                        .toString())]!
                        .contains('c4') ==
                        true
                        ? true
                        : false
                        : false,
                    _selectedDay),
                TimeTextButton(
                    "13h-14h",
                    timeSlots[DateFormat('yyyy-MM-dd')
                        .parse(_selectedDay
                        .toString())] !=
                        null
                        ? timeSlots[DateFormat(
                        'yyyy-MM-dd')
                        .parse(_selectedDay
                        .toString())]!
                        .contains('c5') ==
                        true
                        ? true
                        : false
                        : false,
                    _selectedDay),
                TimeTextButton(
                    "14h-15h",
                    timeSlots[DateFormat('yyyy-MM-dd')
                        .parse(_selectedDay
                        .toString())] !=
                        null
                        ? timeSlots[DateFormat(
                        'yyyy-MM-dd')
                        .parse(_selectedDay
                        .toString())]!
                        .contains('c6') ==
                        true
                        ? true
                        : false
                        : false,
                    _selectedDay),
              ],
            ),
          ),
          Center(child: ButtonKeys()),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
