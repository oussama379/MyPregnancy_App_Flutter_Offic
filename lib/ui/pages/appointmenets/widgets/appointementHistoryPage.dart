import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ma_grossesse/ui/pages/appointmenets/appointmentModel.dart';


import '../../../../app_localizations.dart';
import '../../../../locator.dart';
import '../../../../preferencesService.dart';
import '../../../shared/toasts.dart';
import '../../../sharedServices/checkInternetConnection.dart';
import '../appointmentsRepo.dart';

class AppointmentHistoryPage extends StatefulWidget {

  @override
  State<AppointmentHistoryPage> createState() => _AppointmentHistoryPageState();
}

class _AppointmentHistoryPageState extends State<AppointmentHistoryPage> {
  final _appointmentRepo = locator.get<AppointmentsRepo>();
  List<AppointmentModel> appointmentsList = [];
  List<String> appointmentsListKeys = [];
  final _toast = locator.get<toastMsg>();
  final _preferencesService = locator.get<PreferencesService>();

  late Map _source = {ConnectivityResult.wifi: true};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  //return the status of the internet cnx
  void updateCnx(){
    _connectivity.myStream.listen((source) {
      if (this.mounted) {
        setState(() {
          _source = source;
          print(_source.keys.toList()[0]);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    updateCnx();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.translate('appointment_page_history')),
        ),
        backgroundColor: Colors.white,
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
        ) : FutureBuilder(
        future: _appointmentRepo.getAppointmentPerUser().once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          appointmentsList.clear();
          appointmentsListKeys.clear();
          if (snapshot.hasData) {
            Map<dynamic, dynamic> values = snapshot.data!.value;
            if (values == null)
              return Center(
                child: Container(
                  height: 100.0,
                  width: 300.0,
                  color: Colors.transparent,
                  child: Container(
                      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: new Center(
                        child: new Text(AppLocalizations.of(context)!.translate('appointment_page_history_noAppo'),
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,),
                      )),
                ),
              );
            values.forEach((key, values) {
              appointmentsListKeys.add(key);
              appointmentsList.add(AppointmentModel.fromJson(values));
            });
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: appointmentsList.length,
              itemBuilder: (context, index) {
                // print(index);
                // print(weightsList[index].toString());
                // print(weightsListKeys[index]);
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.5, //
                          color: Colors
                              .pink //                <--- border width here
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              SizedBox(
                                width: 15,
                              ),
                              Icon(Icons.date_range),
                              Text(
                                AppLocalizations.of(context)!.translate('appointment_page_history_dateField'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                appointmentsList[index].date,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 15,
                              )
                            ]),
                            Row(children: [
                              SizedBox(
                                width: 15,
                              ),
                              Icon(Icons.watch_later_outlined),
                              Text(
                                AppLocalizations.of(context)!.translate('appointment_page_history_timeField'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                convertTimeSlot(appointmentsList[index].timeSlot),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 15,
                              )
                            ]),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            icon: new Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                _showDeleteDialog(index);
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        }));
  }

   String convertTimeSlot(String timeSlot){
     if(timeSlot == 'c1') return '09h-10h';
     if(timeSlot == 'c2') return '10h-11h';
     if(timeSlot == 'c3') return '11h-12h';
     if(timeSlot == 'c4') return '12h-13h';
     if(timeSlot == 'c5') return '13h-14h';
     if(timeSlot == 'c6') return '14h-15h';
     else return '';
   }

  void _showDeleteDialog(var index){
    showDialog(context: this.context, builder: (context){
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('weight_history_dialog_title')),
        content: Text(AppLocalizations.of(context)!.translate('appointment_page_history_dialog_text')),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text(AppLocalizations.of(context)!.translate('weight_history_dialog_cancel'))),
          TextButton(onPressed: (){
            setState(() {
              _appointmentRepo.deleteAppointmentPerUser(appointmentsListKeys[index]);
              _appointmentRepo.deleteAppointmentTimeSlot(appointmentsList[index].date, appointmentsList[index].timeSlot);
              _preferencesService.deleteAppointmentDates(appointmentsList[index].date);
              Navigator.pop(context);
              _toast.showMsg(AppLocalizations.of(context)!.translate('appointment_page_history_dialog_confirm'));
            });

          }, child: Text(AppLocalizations.of(context)!.translate('weight_history_dialog_confirm'))),
        ],
      );
    });
  }
}
