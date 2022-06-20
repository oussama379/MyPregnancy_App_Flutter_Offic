import 'package:flutter/material.dart';
import 'package:ma_grossesse/ui/pages/appointements.page.dart';

import '../../../locator.dart';
import '../../shared/toasts.dart';
import 'appointmentsRepo.dart';
import 'timeSlotModel.dart';

class TimeTextButton extends StatefulWidget {
  String time;
  bool isReserved;
  DateTime selectedDate;

  TimeTextButton(this.time, this.isReserved, this.selectedDate);

  @override
  State<TimeTextButton> createState() => _TimeTextButtonState(this.time, this.isReserved, this.selectedDate);
}

class _TimeTextButtonState extends State<TimeTextButton> {
  bool selected = false;
  final _toast = locator.get<toastMsg>();
  String time;
  bool isReserved;
  DateTime selectedDate;
  final _appointmentsRepo = locator.get<AppointmentsRepo>();
  _TimeTextButtonState(this.time, this.isReserved, this.selectedDate);

  @override
  Widget build(BuildContext context) {

    return isReserved
        ? Container(
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: OutlinedButton.icon(
        onPressed: () {
          _toast.showMsg('The time slot you selected is reserved');
          // print(selectedDate);
        },
        icon: const Icon(
          Icons.access_time,
          color: Colors.black,
          size: 13,
        ),
        label: Text(
          time,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    )
        : Container(
      decoration: BoxDecoration(
        color: selected == false ? Colors.lightGreenAccent : Colors.orange,
        borderRadius: BorderRadius.circular(5),
      ),
      //margin: EdgeInsets.only(left: 2),
      child: OutlinedButton.icon(
        // foreground
        onPressed: () {
            setState(() {
              selected = !selected;
            });
            if(selected){
              _showAppConfirmDialog(selectedDate, time);
            }
        },
        icon: const Icon(
          Icons.access_time,
          color: Colors.black,
          size: 13,
        ),
        label: Text(
          time,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  void _showAppConfirmDialog(DateTime dateTime, String timeSlot){
    showDialog(context: this.context, builder: (context){
      return AlertDialog(
        title: Text('Make an appointment'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to make this appointment : '),
            SizedBox(height: 10,),
            Text('Time : '+timeSlot, style: TextStyle(fontWeight: FontWeight.bold),),
            Text('Date : '+dateTime.day.toString() +'/'+dateTime.month.toString() +'/'+dateTime.year.toString(), style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
            Navigator.pushReplacementNamed(
                context,
                "/appointementsCalendarPage"
            );
          }, child: Text('Cancel')),
          TextButton(onPressed: (){
            setState(() {
              _appointmentsRepo.saveAppointment(dateTime, timeSlot);
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                context,
                  "/appointementsCalendarPage"
              );
              //Navigator.pushNamedAndRemoveUntil(context, "/appointementsCalendarPage", (_) => true);
            });

          }, child: Text('Yes')),
        ],
      );
    });
  }

}
