import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightModel.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightRepo.dart';

import '../../../../locator.dart';
import '../../../shared/toasts.dart';

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
                      return 'Please enter your weight';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please enter a positive weight';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.monitor_weight_outlined,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Enter your weight here',
                    hintText: 'Enter your weight here',
                  ))),
          SizedBox(
            height: 20,
          ),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                //padding: EdgeInsets.only(left: 35.0, right: 35.0, top: 17, bottom: 17),
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
                ? Text('Enter the date of measurement here')
                : Text(
                    DateFormat('yyyy-MM-dd').format(_date!).toString()+' (Tap to change)',
                    style: TextStyle(color: Colors.pink),
                  ),
            icon: const Icon(Icons.date_range),
          ),
          SizedBox(
            height: 20,
          ),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                padding: EdgeInsets.only(
                    left: 35.0, right: 35.0, top: 17, bottom: 17),
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
                ? Text('Enter the time of measurement here')
                : Text(
                    DateFormat.jm().format(_time!).toString() + ' (Tap to change)',
                    style: TextStyle(color: Colors.pink),
                  ),
            icon: const Icon(Icons.watch_later_outlined),
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
                    WeightModel W = _weightRepo.prepareWeightModel(
                        int.parse(_weight.text), _date!, _time!);
                    print(W.toString());
                    print(W.toJson());
                    _weightRepo.SaveWeightMeasurements(W.toJson());
                    _toast.showMsg('Saved Successfully : See History');
                    setState(() {
                      _date = null;
                      _time = null;
                      _weight.clear();
                    });
                  } else {
                    _toast.showMsg('Please enter your weight');
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
