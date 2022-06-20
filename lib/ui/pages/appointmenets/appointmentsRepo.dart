import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../../../globals.dart' as globals;
import 'timeSlotModel.dart';
class AppointmentsRepo{

  List<DateTime> getAvailableAppointments(){
    List<DateTime> availableAppointmentsDates = [];
    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child('Rdv').reference();
    reference.onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value;
      //print('date :' +data.toString());
      data.forEach((key, values) {
        DateTime dt =  DateFormat('dd-MM-yyyy').parse(key);
        availableAppointmentsDates.add(dt);
      });
    });
    return availableAppointmentsDates;
  }

  void getBookedSlots(){
    Map<DateTime,List<String>> list = {};
    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child('Rdv').reference();
    reference.onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value;
      //print('date :' +data.toString());
      data.forEach((key, values) {
        List<String> slots = [];
        DateTime dt =  DateFormat('dd-MM-yyyy').parse(key);
        Map<dynamic, dynamic> timeSlots = values;
        //print(values);
        timeSlots.forEach((k, v) {
          //print('for the date : '+ dt.toString() + ' time slots : '+k.toString()+ ' / '+v.toString());
          v.forEach((k2, v2) {
            //print('for the date : '+ dt.toString() + ' time slots : '+k2.toString()+ ' / '+v2.toString());
            if(k2.toString() == 'id1') {
              print(v2.toString().length);
              print(k.toString());
              if(v2.toString().length > 0) {
                slots.add(k.toString());
              }
            }
          });
        });
        list[dt] = slots;
        //print(dt); // 2020-01-02 03:04:05.000
      });
      print(list.toString());
    });
  }

  Future<void> saveAppointment(DateTime dateTime, String timeSlot) async {

    if(timeSlot == '09h-10h') timeSlot = 'c1';
    if(timeSlot == '10h-11h') timeSlot = 'c2';
    if(timeSlot == '11h-12h') timeSlot = 'c3';
    if(timeSlot == '12h-13h') timeSlot = 'c4';
    if(timeSlot == '13h-14h') timeSlot = 'c5';
    if(timeSlot == '14h-15h') timeSlot = 'c6';

    TimeSlot c = new TimeSlot('', globals.UID, 1);
    dynamic json = c.toJson();
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");
    String dateAppoint = dateFormat.format(dateTime);
    print('In saveAppointment : '+dateAppoint);
    print('json : '+json.toString());
    await FirebaseDatabase.instance
        .reference()
        .child('Rdv')
        .child(dateAppoint)
        .child(timeSlot)//c1,or...........c6
        .set(json);
  }

}