import 'package:flutter/material.dart';
import 'package:ma_grossesse/ui/pages/appointements.page.dart';

import '../../../../app_localizations.dart';
import '../../../../locator.dart';
import '../../../../preferencesService.dart';
import '../../../shared/toasts.dart';
import '../appointmentsRepo.dart';
import '../timeSlotModel.dart';

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
  final _preferencesService = locator.get<PreferencesService>();
  _TimeTextButtonState(this.time, this.isReserved, this.selectedDate);

  @override
  void initState() {
    super.initState();
  }

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
          _toast.showMsg(AppLocalizations.of(context)!.translate('appointment_page_redButton_msg'));
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

    showDialog(context: this.context,
        barrierDismissible: false,
        builder: (context){

      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('appointment_page_dialog_title')),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.translate('appointment_page_dialog_msg')),
            SizedBox(height: 10,),
            Text(AppLocalizations.of(context)!.translate('weight_history_time_field')+timeSlot, style: TextStyle(fontWeight: FontWeight.bold),),
            Text(AppLocalizations.of(context)!.translate('weight_history_date_field')+dateTime.day.toString() +'/'+dateTime.month.toString() +'/'+dateTime.year.toString(), style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
            Navigator.pushReplacementNamed(
                context,
                "/appointementsCalendarPage"
            );
          }, child: Text(AppLocalizations.of(context)!.translate('weight_history_dialog_cancel'))),
          TextButton(onPressed: () async {
            bool savedOrNot = await _preferencesService.saveAppointmentDates(dateTime);
            setState(() {
              if(savedOrNot == true){
                _appointmentsRepo.saveAppointment(dateTime, timeSlot);
                _appointmentsRepo.saveAppointmentPerUser(dateTime, timeSlot);
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                    context,
                    "/appointementsCalendarPage"
                );
                _toast.showMsg(AppLocalizations.of(context)!.translate('appointment_page_dialog_conf')+dateTime.day.toString() +'/'+dateTime.month.toString() +'/'+dateTime.year.toString()+' : '+timeSlot);
                //Navigator.pushNamedAndRemoveUntil(context, "/appointementsCalendarPage", (_) => true);
              }else{
                 Navigator.pop(context);
                 Navigator.pushReplacementNamed(
                     context,
                     "/appointementsCalendarPage"
                 );
                _toast.showMsg(AppLocalizations.of(context)!.translate('appointment_page_dialog_error'));
              }
            });
          }, child: Text(AppLocalizations.of(context)!.translate('weight_history_dialog_confirm'))),
        ],
      );
    });
  }

}
