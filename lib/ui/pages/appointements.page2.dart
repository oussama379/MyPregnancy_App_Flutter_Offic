import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ma_grossesse/ui/pages/appointmenets/timeSlotModel.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../locator.dart';
import 'appointmenets/appointmentsRepo.dart';
import 'appointmenets/buttonKeys.dart';
import 'appointmenets/timeTextButton.dart';

class AppointmentsCalendarPage2 extends StatefulWidget {
  @override
  State<AppointmentsCalendarPage2> createState() =>
      _AppointmentsCalendarPageState();
}

class _AppointmentsCalendarPageState extends State<AppointmentsCalendarPage2> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<DateTime> toHighlight = [];
  late Map<DateTime,List<String>> timeSlots = {};
  List<String> slots = [];
  final _appointmentsRepo = locator.get<AppointmentsRepo>();

  @override
  void initState() {
    super.initState();
    //_appointmentsRepo.getBookedSlots();
  }

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
            Padding(
              padding: const EdgeInsets.only(top : 8.0, left: 8.0),
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.lightGreen,

                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Days with available appointments',
                    style: TextStyle(
                      color: Color(0xff363636),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: FutureBuilder(
                  future: FirebaseDatabase.instance
                      .reference()
                      .child('Rdv').once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  toHighlight.clear();
                  if (!snapshot.hasData) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  Map<dynamic, dynamic> data = snapshot.data!.value;
                  data.forEach((key, values) {
                    DateTime dt =  DateFormat('dd-MM-yyyy').parse(key);
                    toHighlight.add(dt);
                  });
                  return Column(
                    children: [
                      Container(
                        child: TableCalendar(
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                                color: Colors.pink.shade200, shape: BoxShape.rectangle, ),
                            selectedDecoration: BoxDecoration(
                                color: Colors.pink.shade400, shape: BoxShape.rectangle,),
                          ),
                          firstDay: DateTime.now(),
                          lastDay: DateTime.now().add(Duration(days: 365)),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          //eventLoader: _getEventsForDay,
                          calendarBuilders: CalendarBuilders(
                            prioritizedBuilder: (context, day, focusedDay) {
                              for (DateTime d in toHighlight) {
                                if (day.day == d.day &&
                                    day.month == d.month &&
                                    day.year == d.year) {
                                  return InkWell(
                                    onTap: (){
                                      setState(() {
                                        //print(toHighlight);
                                        _selectedDay = day;
                                        _focusedDay = day;
                                        //print(checkDate(_selectedDay));
                                      });
                                    },
                                    child: Container(
                                      width: 45,
                                      height: 45,
                                      decoration: const BoxDecoration(
                                        color: Colors.lightGreen,
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${day.day}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
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
                    ],
                  );
                }
              ),
            ),
                      checkDate(_selectedDay)
                          ? FutureBuilder(
                          future : FirebaseDatabase.instance
                              .reference()
                              .child('Rdv').reference().once(),
                          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                            timeSlots.clear();
                            print('Inside : FutureBuilder1');
                            if (!snapshot.hasData) {
                              return Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            Map<dynamic, dynamic> data = snapshot.data!.value;
                            data.forEach((key, values) {
                              List<String> slots = [];
                              DateTime dt =  DateFormat('dd-MM-yyyy').parse(key);
                              Map<dynamic, dynamic> timeSlot = values;
                              //print(values);
                              timeSlot.forEach((k, v) {
                                //print(v);
                                TimeSlot c1 = TimeSlot.fromJson(v);
                                if(c1.id1.length > 0) {
                                  slots.add(k.toString());
                                }
                              });
                              timeSlots[dt] = slots;
                            });
                            //print(timeSlots);
                            return Column(
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
                                  margin: EdgeInsets.only(right: 5, left: 5, top: 15),
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
                                      TimeTextButton("09h-10h", timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())] != null ? timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())]!.contains('c1') == true ? true : false : false, _selectedDay),
                                      TimeTextButton("10h-11h", timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())] != null ? timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())]!.contains('c2') == true ? true : false : false, _selectedDay),
                                      TimeTextButton("11h-12h", timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())] != null ? timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())]!.contains('c3') == true ? true : false : false, _selectedDay),
                                      //Text(timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())] != null ? timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())]!.contains('c3') ? timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())].toString() : 'YEEYEYEYEY' : DateFormat('dd-MM-yyyy').parse(_selectedDay.toString()).toString()),
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
                                  margin: EdgeInsets.only(right: 5, left: 5, top: 15),
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
                                      TimeTextButton("12h-13h", timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())] != null ? timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())]!.contains('c4') == true ? true : false : false, _selectedDay),
                                      TimeTextButton("13h-14h", timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())] != null ? timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())]!.contains('c5') == true? true : false : false, _selectedDay),
                                      TimeTextButton("14h-15h", timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())] != null ? timeSlots[DateFormat('yyyy-MM-dd').parse(_selectedDay.toString())]!.contains('c6') == true ? true : false : false, _selectedDay),
                                    ],
                                  ),
                                ),
                                ButtonKeys(),
                                SizedBox(
                                  height: 10,
                                ),
                                // Container(
                                //   height: 45,
                                //   width: 300,
                                //   decoration: BoxDecoration(
                                //     color: Colors.pinkAccent,
                                //     borderRadius: BorderRadius.circular(5),
                                //   ),
                                //   child: TextButton(
                                //     onPressed: () {
                                //       print('Save');
                                //       print('Selected Day :'+this._selectedDay.toString());
                                //       //print('Selected Time Slot :'+this.time);
                                //     },
                                //     child: Text(
                                //       'Make an appointment',
                                //       style: TextStyle(color: Colors.white, fontSize: 17),
                                //     ),
                                //   ),
                                // ),
                              ],
                            );
                          }
                      )
                          : Center(
                        child: Container(
                            height: 50,
                            margin:
                            EdgeInsets.only(right: 10.0, left: 10.0, top: 70),
                            padding: EdgeInsets.only(right: 10.0, left: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.pinkAccent,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
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
    print('checkDate');
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

