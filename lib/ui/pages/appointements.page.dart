import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ma_grossesse/ui/pages/appointmenets/timeSlotModel.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../app_localizations.dart';
import '../../locator.dart';
import '../sharedServices/checkInternetConnection.dart';
import 'appointmenets/appointmentModel.dart';
import 'appointmenets/appointmentsRepo.dart';
import 'appointmenets/widgets/buttonKeys.dart';
import 'appointmenets/widgets/timeSlotsSection.dart';
import 'appointmenets/widgets/timeTextButton.dart';

class AppointmentsCalendarPage extends StatefulWidget {
  @override
  State<AppointmentsCalendarPage> createState() =>
      _AppointmentsCalendarPageState();
}

class _AppointmentsCalendarPageState extends State<AppointmentsCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<DateTime> toHighlight = [];
  late Map<DateTime, List<String>> timeSlots = {};
  List<String> slots = [];
  final _appointmentsRepo = locator.get<AppointmentsRepo>();
  int counter = 2;
  List<AppointmentModel> appointmentsList = [];

  late Map _source = {ConnectivityResult.wifi: true};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  //return the status of the internet cnx
  void updateCnx(){
    _connectivity.myStream.listen((source) {
      if (this.mounted) {
        setState(() {
          _source = source;
          //print(_source.keys.toList()[0]);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    updateCnx();
    //_appointmentsRepo.getBookedSlots();
  }

  @override
  Widget build(BuildContext context) {
    RouteSettings settings = ModalRoute.of(context)!.settings;
    if (settings.arguments != null) {
      _selectedDay = settings.arguments as DateTime;
      _focusedDay = settings.arguments as DateTime;
    }
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.translate('appointment_page_title')), actions: <Widget>[
        Stack(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.calendar_month),
                onPressed: () {
                  Navigator.pushNamed(context, "/AppointmentHistoryPage");
                  setState(() {
                    //counter = 0;
                  });
                }),
          ],
        ),
      ]),
      body: _source.keys.toList()[0] == ConnectivityResult.none ? Center(
        child: Container(
          height: 120.0,
          width: 300.0,
          color: Colors.transparent,
          child: Container(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child:  Center(
                child:  Column(
                  children: [
                    SizedBox(height: 10,),
                    Icon(Icons.signal_wifi_off, size: 40, color: Colors.white,),
                    SizedBox(height: 5,),
                    Text(AppLocalizations.of(context)!.translate('info_page_cnx_error_msg'),
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,),
                    SizedBox(height: 10,),
                  ],
                ),
              )),
        ),
      ) : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
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
                    AppLocalizations.of(context)!.translate('appointment_page_greenBox'),
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
                  future:
                      FirebaseDatabase.instance.reference().child('Rdv').once(),
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
                      DateTime dt = DateFormat('dd-MM-yyyy').parse(key);
                      if (dt.isAfter(DateTime.now()) ||
                          dt.year == DateTime.now().year &&
                              dt.month == DateTime.now().month &&
                              dt.day == DateTime.now().day) {
                        //print(dt);
                        //print(DateTime.now());
                        toHighlight.add(dt);
                      }
                    });
                    data.forEach((key, values) {
                      List<String> slots = [];
                      DateTime dt = DateFormat('dd-MM-yyyy').parse(key);
                      Map<dynamic, dynamic> timeSlot = values;
                      //print(values);
                      timeSlot.forEach((k, v) {
                        //print('Inside For ');
                        TimeSlot c1 = TimeSlot.fromJson(v);
                        if (c1.id1.length > 0 && c1.id2.length > 0) {
                          slots.add(k.toString());
                        }
                      });
                      //print(slots);
                      timeSlots[dt] = slots;
                    });
                    //print(timeSlots);
                    return Column(
                      children: [
                        Container(
                          child: TableCalendar(
                            locale: Localizations.localeOf(context).toString(),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleTextFormatter: (date, locale) =>
                                  DateFormat.yMMMEd(locale).format(date),
                            ),
                            calendarStyle: CalendarStyle(
                              todayDecoration: BoxDecoration(
                                color: Colors.pink.shade200,
                                shape: BoxShape.rectangle,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Colors.pink.shade400,
                                shape: BoxShape.rectangle,
                              ),
                            ),
                            firstDay: DateTime.now(),
                            lastDay: DateTime.now().add(Duration(days: 365)),
                            focusedDay: _focusedDay,
                            calendarFormat: _calendarFormat,
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                //print('_selectedDay before : '+_selectedDay.toString());
                                _selectedDay = selectedDay;
                                //print('_selectedDay after : '+_selectedDay.toString());
                                _focusedDay = focusedDay;
                                Navigator.pushReplacementNamed(
                                    context, "/appointementsCalendarPage",
                                    arguments: _selectedDay);
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
                                      splashColor: Colors.pinkAccent,
                                      onTap: () {
                                        setState(() {
                                          _selectedDay = day;
                                          _focusedDay = day;
                                          Navigator.pushReplacementNamed(
                                              context,
                                              "/appointementsCalendarPage",
                                              arguments: _selectedDay);
                                          //_selectedDay = day.add(const Duration(days: 10000));
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
                                            style: const TextStyle(
                                                color: Colors.white),
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
                        checkDate(_selectedDay)
                            ? TimeSlotsSection(_selectedDay, timeSlots)
                            : Center(
                                child: Container(
                                    height: 50,
                                    margin: EdgeInsets.only(
                                        right: 10.0, left: 10.0, top: 70),
                                    padding: EdgeInsets.only(
                                        right: 10.0, left: 10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.pinkAccent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    child: new Center(
                                      child: new Text(
                                        AppLocalizations.of(context)!.translate('appointment_page_noDates_msgs'),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                              )
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  bool checkDate(DateTime selectedDate) {
    //print('checkDate : ' + selectedDate.toString());
    for (DateTime d in toHighlight) {
      if (selectedDate.day == d.day &&
          selectedDate.month == d.month &&
          selectedDate.year == d.year) {
        //print('checkDate : true');
        return true;
      }
    }
    //print('checkDate : false');
    return false;
  }
}
