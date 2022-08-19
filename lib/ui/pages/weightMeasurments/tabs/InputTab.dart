import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightModel.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightRepo.dart';

import '../../../../app_localizations.dart';
import '../../../../locator.dart';
import '../../../shared/toasts.dart';
import '../../../sharedServices/checkInternetConnection.dart';

class InputPage extends StatefulWidget {
  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _weight = TextEditingController();
  final _toast = locator.get<toastMsg>();
  DateTime? _date = null;
  DateTime? _time = null;
  final _weightRepo = locator.get<WeightRepo>();


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
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 30, bottom: 0),
                  child: TextFormField(
                      autofocus: false,
                      controller: _weight,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.translate('weight_input_tab_weightField_error1');
                        }
                        if(double.tryParse(value) == null){
                          return AppLocalizations.of(context)!.translate('createAccount_page_phone_field_noValid');
                          //return 'The input is not a numeric value';
                        }
                        if (double.parse(value) <= 0) {
                          return AppLocalizations.of(context)!.translate('weight_input_tab_weightField_error2');
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.monitor_weight_outlined,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)!.translate('weight_input_tab_weightField_hint'),
                        hintText: AppLocalizations.of(context)!.translate('weight_input_tab_weightField_hint'),
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
                              _toast.showMsg(AppLocalizations.of(context)!.translate('weight_input_tab_dateField_error1'));
                            }
                          });
                          print('confirm $date');
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  label: _date == null
                      ? Text(AppLocalizations.of(context)!.translate('weight_input_tab_dateField_hint'))
                      : Text(
                    DateFormat('yyyy-MM-dd').format(_date!).toString() + AppLocalizations.of(context)!.translate('weight_input_tab_dateField_text+'),
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
                      ? Text(AppLocalizations.of(context)!.translate('weight_input_tab_timeField_hint'))
                      : Text(
                    DateFormat.jm().format(_time!).toString() + AppLocalizations.of(context)!.translate('weight_input_tab_dateField_text'),
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
                      _toast.showMsg(AppLocalizations.of(context)!.translate('weight_input_tab_savedNotOk'));
                    else {
                      if (_formKey.currentState!.validate()) {
                        print("Successful");
                        WeightModel W = _weightRepo.prepareWeightModel(
                            int.parse(_weight.text), _date!, _time!);
                       if(_source.keys.toList()[0] != ConnectivityResult.none){
                         _weightRepo.SaveWeightMeasurements(W.toJson());
                         _toast.showMsg(AppLocalizations.of(context)!.translate('weight_input_tab_saved_ok'));

                       }else{
                         _toast.showMsg(AppLocalizations.of(context)!.translate('internet_errors2'));                       }
                       setState(() {
                          _date = null;
                          _time = null;
                          _weight.clear();
                        });
                      } else {
                        _toast.showMsg(AppLocalizations.of(context)!.translate('weight_input_tab_weightField_error1'));
                      }
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('weight_input_tab_confirm_button'),
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ));
  }


}
