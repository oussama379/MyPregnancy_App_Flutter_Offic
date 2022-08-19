import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:ma_grossesse/ui/pages/pressureMeasurments/pressureModel.dart';

import '../../../../app_localizations.dart';
import '../../../../locator.dart';
import '../../../shared/toasts.dart';
import '../../../sharedServices/checkInternetConnection.dart';
import '../pressureRepo.dart';

class InputPagePressure extends StatefulWidget {
  @override
  State<InputPagePressure> createState() => _InputPageStatePressure();
}

class _InputPageStatePressure extends State<InputPagePressure> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _pressureSystolic = TextEditingController();
  TextEditingController _pressureDiastolic = TextEditingController();
  final _toast = locator.get<toastMsg>();
  DateTime? _date = null;
  DateTime? _time = null;
  final _pressureRepo = locator.get<PressureRepo>();

  late Map _source = {ConnectivityResult.wifi: true};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  //return the status of the internet cnx
  void updateCnx() {
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
    return Container(
        child: Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextFormField(
                  autofocus: false,
                  controller: _pressureSystolic,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .translate('pressure_input_tab_systField_error1');
                    }
                    if (double.tryParse(value) == null) {
                      return AppLocalizations.of(context)!
                          .translate('createAccount_page_phone_field_noValid');
                      //return 'The input is not a numeric value';
                    }
                    if (double.parse(value) <= 0) {
                      return AppLocalizations.of(context)!
                          .translate('pressure_input_tab_systField_error2');
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.monitor_heart,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!
                        .translate('pressure_input_tab_systField_label'),
                    hintText: AppLocalizations.of(context)!
                        .translate('pressure_input_tab_systField_hint'),
                  ))),
          Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextFormField(
                  autofocus: false,
                  controller: _pressureDiastolic,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .translate('pressure_input_tab_diatField_error1');
                    }
                    if (double.tryParse(value) == null) {
                      return AppLocalizations.of(context)!
                          .translate('createAccount_page_phone_field_noValid');
                      //return 'The input is not a numeric value';
                    }
                    if (double.parse(value) <= 0) {
                      return AppLocalizations.of(context)!
                          .translate('pressure_input_tab_systField_error2');
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.monitor_heart,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!
                        .translate('pressure_input_tab_diatField_label'),
                    hintText: AppLocalizations.of(context)!
                        .translate('pressure_input_tab_diatField_hint'),
                  ))),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 30,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.only(top: 17, bottom: 17),
                  side: BorderSide(width: .6)),
              // foreground
              onPressed: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    theme: DatePickerTheme(
                      doneStyle: TextStyle(color: Colors.pink, fontSize: 16),
                    ),
                    minTime: DateTime(2018, 3, 5),
                    maxTime: DateTime(2040, 6, 7), onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  setState(() {
                    if (date.isBefore(DateTime.now()))
                      _date = date;
                    else {
                      _toast.showMsg(AppLocalizations.of(context)!
                          .translate('weight_input_tab_dateField_error1'));
                    }
                  });
                  print('confirm $date');
                }, currentTime: DateTime.now(), locale: LocaleType.en);
              },
              label: _date == null
                  ? Text(AppLocalizations.of(context)!
                      .translate('weight_input_tab_dateField_hint'))
                  : Text(
                      DateFormat('yyyy-MM-dd').format(_date!).toString() +
                          AppLocalizations.of(context)!
                              .translate('weight_input_tab_dateField_text'),
                      style: TextStyle(color: Colors.pink),
                    ),
              icon: const Icon(Icons.date_range),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 30,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.only(top: 17, bottom: 17),
                  side: BorderSide(width: .6)),
              // foreground
              onPressed: () {
                DatePicker.showTimePicker(context,
                    showTitleActions: true,
                    theme: DatePickerTheme(
                      doneStyle: TextStyle(color: Colors.pink, fontSize: 16),
                    ), onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  setState(() {
                    _time = date;
                  });
                  print('confirm $date');
                }, currentTime: DateTime.now(), locale: LocaleType.en);
              },
              label: _time == null
                  ? Text(AppLocalizations.of(context)!
                      .translate('weight_input_tab_timeField_hint'))
                  : Text(
                      DateFormat.jm().format(_time!).toString() +
                          AppLocalizations.of(context)!
                              .translate('weight_input_tab_dateField_text'),
                      style: TextStyle(color: Colors.pink),
                    ),
              icon: const Icon(Icons.watch_later_outlined),
            ),
          ),
          SizedBox(
            height: 30,
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
                if (_date == null || _time == null)
                  _toast.showMsg(AppLocalizations.of(context)!
                      .translate('weight_input_tab_savedNotOk'));
                else {
                  if (_formKey.currentState!.validate()) {
                    PressureModel P = _pressureRepo.preparePressureModel(
                        int.parse(_pressureSystolic.text),
                        int.parse(_pressureDiastolic.text),
                        _date!,
                        _time!);

                    if(int.parse(_pressureSystolic.text) > 130) _showHighPressureAlertDialog(true);
                    if(int.parse(_pressureDiastolic.text) > 80) _showHighPressureAlertDialog(false);

                    if (_source.keys.toList()[0] != ConnectivityResult.none) {
                      _pressureRepo.SavePressureMeasurements(P.toJson());
                      _toast.showMsg(AppLocalizations.of(context)!
                          .translate('weight_input_tab_saved_ok'));
                    } else {
                      _toast.showMsg(AppLocalizations.of(context)!
                          .translate('internet_errors2'));
                    }

                    setState(() {
                      _date = null;
                      _time = null;
                      _pressureSystolic.clear();
                      _pressureDiastolic.clear();
                    });
                  } else {
                    _toast.showMsg(AppLocalizations.of(context)!
                        .translate('pressure_input_tab_error'));
                  }
                }
              },
              child: Text(
                AppLocalizations.of(context)!
                    .translate('weight_input_tab_confirm_button'),
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void _showHighPressureAlertDialog(bool isItSystolic) {
    String MsgToShow;
    if(isItSystolic)  MsgToShow = AppLocalizations.of(context)!
        .translate('pressure_HighAlertdialog_Sys');
    else MsgToShow = AppLocalizations.of(context)!
        .translate('pressure_HighAlertdialog_Dia');
    showDialog(
        context: this.context,
        builder: (context) {
          return Container(
            //height: 300,
            child: AlertDialog(
              title: Text(AppLocalizations.of(context)!
                  .translate('pressure_HighAlertdialog_title')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_outlined, size: 40, color: Colors.red,),
                  SizedBox(height: 10,),
                  Text(MsgToShow),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!
                        .translate('home_page_LPD_alert_conf'))),
              ],
            ),
          );
        });
  }
}
