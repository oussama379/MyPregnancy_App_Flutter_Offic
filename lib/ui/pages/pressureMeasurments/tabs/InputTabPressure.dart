import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:ma_grossesse/ui/pages/pressureMeasurments/pressureModel.dart';


import '../../../../app_localizations.dart';
import '../../../../locator.dart';
import '../../../shared/toasts.dart';
import '../pressureRepo.dart';

class InputPagePressure extends StatefulWidget {
  @override
  State<InputPagePressure> createState() => _InputPageStatePressure();
}

class _InputPageStatePressure extends State<InputPagePressure> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _pressureSystolic = TextEditingController();
  TextEditingController _pressureDiastolic  = TextEditingController();
  final _toast = locator.get<toastMsg>();
  DateTime? _date = null;
  DateTime? _time = null;
  final _pressureRepo = locator.get<PressureRepo>();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                  padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 30, bottom: 0),
                  child: TextFormField(
                      autofocus: false,
                      controller: _pressureSystolic,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Systolic pressure';
                        }
                        if (int.parse(value) <= 0) {
                          return 'Please enter a positive value';
                        }
                        if(int.tryParse(value) == null){
                          return AppLocalizations.of(context)!.translate('createAccount_page_phone_field_noValid');
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.monitor_heart,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Enter your Systolic pressure',
                        hintText: 'Systolic pressure',
                      ))),
              Padding(
                  padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextFormField(
                      autofocus: false,
                      controller: _pressureDiastolic,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Diastolic pressure';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a positive value';
                        }
                        if(int.tryParse(value) == null){
                          //numeric value
                          return AppLocalizations.of(context)!.translate('createAccount_page_phone_field_noValid');
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.monitor_heart,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Enter your Diastolic pressure',
                        hintText: 'Diastolic pressure',
                      ))),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width-30,
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
                            if(date.isBefore(DateTime.now()))
                              _date = date;
                            else{
                              _toast.showMsg('Please enter a valid date ');
                            }
                          });
                          print('confirm $date');
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  label: _date == null
                      ? Text('Enter the date')
                      : Text(
                    DateFormat('yyyy-MM-dd').format(_date!).toString()+' (Tap to change)',
                    style: TextStyle(color: Colors.pink),
                  ),
                  icon: const Icon(Icons.date_range),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width-30,
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
                      ? Text('Enter the time')
                      : Text(
                    DateFormat.jm().format(_time!).toString() + ' (Tap to change)',
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
                    if(_date == null || _time == null)
                      _toast.showMsg('Please fill in all the fields');
                    else {
                      if (_formKey.currentState!.validate()) {
                        print("Successful");
                        PressureModel P = _pressureRepo.preparePressureModel(int.parse(_pressureSystolic.text), int.parse(_pressureDiastolic.text), _date!, _time!);
                        print(P.toString());
                        print(P.toJson());
                        _pressureRepo.SavePressureMeasurements(P.toJson());
                        _toast.showMsg('Saved Successfully : See History');
                        setState(() {
                          _date = null;
                          _time = null;
                          _pressureSystolic.clear();
                          _pressureDiastolic.clear();
                        });
                      } else {
                        _toast.showMsg('Please enter your pressures');
                      }
                    }
                  },
                  child: Text(
                    'Save All',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ));
  }


}
