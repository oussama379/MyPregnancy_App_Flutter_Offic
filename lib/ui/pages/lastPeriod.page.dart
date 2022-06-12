import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

import '../../locator.dart';
import '../../preferencesService.dart';
import 'home/services/homeServices.dart';
import '../../globals.dart' as globals;
import 'home/widgets/roundButton.home.dart';

class LastPeriod extends StatefulWidget {
  @override
  State<LastPeriod> createState() => _LastPeriodState();
}

class _LastPeriodState extends State<LastPeriod> {
  final _preferencesService = locator.get<PreferencesService>();
  DateTime lastPeriodDate = new DateTime(00, 00, 0000);
  final _HomeServices = locator.get<HomeServices>();
  var _dpaFromPref;
  var _lastPeriodFromPref;

  Future<void> onClick() async {
    DateTime? newDateTime = await showRoundedDatePicker(
      context: context,
      locale: Localizations.localeOf(context),
      theme: ThemeData(primarySwatch: Colors.pink),
      firstDate: DateTime(DateTime.now().year - 1),
    );
    //if cancel
    if (newDateTime == null) return;
    //if Okay
    var lastP;
    setState(() {
      lastPeriodDate = newDateTime;
      lastP = lastPeriodDate.day.toString() +
          '/' +
          lastPeriodDate.month.toString() +
          '/' +
          lastPeriodDate.year.toString();
      _lastPeriodFromPref = lastP;
      globals.lastPeriodDate = _lastPeriodFromPref;
      _dpaFromPref = _HomeServices.calculeDPA(lastP);
    });
    _preferencesService.saveLastPeriodDate(lastP);
    _preferencesService.saveDPA(_HomeServices.calculeDPA(lastP));
    Navigator.pushNamedAndRemoveUntil(context, "/homePage", (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Last Period Date'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(70),
              shrinkWrap: true, // to get around infinite size error
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 1,
              children: <Widget>[
                RoundButton(
                    buttonText: 'Tap here to enter last period date',
                    icon: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                    color: Colors.pink,
                    onTap: () {
                      onClick();
                    })
              ],
          )),
        );

        // child: TextField(
        //   //enabled: false,
        //   //textInputAction:,
        //   //scrollPadding: const EdgeInsets.only(left: 20, right: 20),
        //   onTap: () async{
        //     onClick();
        //   },
        //   decoration: InputDecoration(
        //       //contentPadding: const EdgeInsets.only(left: 20, right: 20),
        //       suffixIcon: IconButton(
        //         icon: Icon(
        //           Icons.calendar_today_rounded,
        //           color: Colors.black,
        //         ),
        //         onPressed: () async {
        //           onClick();
        //         },
        //       ),
        //       border: OutlineInputBorder(),
        //       labelText: 'Last Period Date',
        //       hintText: 'Click Here To Enter the date of the last period'),
        // ),

  }
}
