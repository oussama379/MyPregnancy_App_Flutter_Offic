import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'appointmenets/buttonKeys.dart';
import 'appointmenets/timeTextButton.dart';

class AppointmentsCalendarPage extends StatefulWidget {
  @override
  State<AppointmentsCalendarPage> createState() =>
      _AppointmentsCalendarPageState();
}

class _AppointmentsCalendarPageState extends State<AppointmentsCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime? _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<DateTime> toHighlight = [
    DateTime(2022, 06, 21),
    DateTime(2022, 06, 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: TableCalendar(
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                      color: Colors.pink.shade200, shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(
                      color: Colors.pink.shade400, shape: BoxShape.circle),
                ),
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(Duration(days: 365)),
                focusedDay: DateTime.now(),
                calendarFormat: _calendarFormat,
                // onFormatChanged: (format) {
                //   setState(() {
                //     _calendarFormat = format;
                //   });
                // },
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    // print(_selectedDay);
                    print(_focusedDay);
                  });
                },
                //eventLoader: _getEventsForDay,
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    for (DateTime d in toHighlight) {
                      if (day.day == d.day &&
                          day.month == d.month &&
                          day.year == d.year) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    }
                    return null;
                  },
                ),
              ),
            ),
            checkDate(_selectedDay!)
                ? Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        child: Text(
                          'Morning',
                          style: TextStyle(
                            color: Color(0xff363636),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15, left: 15, top: 15),
                        child: GridView.count(
                          crossAxisSpacing: 10,
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 2.7,
                          children: [
                            TimeTextButton("09:00 - 10:00", true),
                            TimeTextButton("10:00 - 11:00", false),
                            TimeTextButton("11:00 - 12:00", false),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 25, top: 20),
                        child: Text(
                          'Evening',
                          style: TextStyle(
                            color: Color(0xff363636),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15, left: 15, top: 15),
                        child: GridView.count(
                          crossAxisSpacing: 10,
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 2.6,
                          children: [
                            TimeTextButton("12:00 - 13:00", true),
                            TimeTextButton("13:00 - 14:00", false),
                            TimeTextButton("14:00 - 15:00", false),
                          ],
                        ),
                      ),
                      ButtonKeys(),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 45,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextButton(
                          onPressed: () {
                            print('Save');
                          },
                          child: Text(
                            'Make an appointment',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                  child: Container(
                    height: 50,
                      margin: EdgeInsets.only(right: 10.0, left: 10.0, top: 70),
                      padding: EdgeInsets.only(right: 10.0, left: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: new Center(
                        child: new Text(
                          'No available appointments on this date',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                             ),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
          ],
        ),
      ),
    );
  }

  bool checkDate(DateTime selectedDate) {
    for (DateTime d in toHighlight) {
      if (selectedDate.day == d.day &&
          selectedDate.month == d.month &&
          selectedDate.year == d.year) {
        return true;
      }
    }
    return false;
  }
}
