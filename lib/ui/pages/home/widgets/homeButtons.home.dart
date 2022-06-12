import 'package:flutter/material.dart';

import '../../../../locator.dart';
import '../../../../preferencesService.dart';
import 'roundButton.home.dart';

class HomeButtons extends StatelessWidget {
  final Color cInfo = const Color.fromARGB(255, 245, 66, 176);
  final Color cPhr = const Color.fromARGB(255, 250, 5, 156);
  final Color cAppoint = const Color.fromARGB(255, 247, 130, 202);
  final Color cCount = const Color.fromARGB(255, 201, 13, 129);
  final Color cMesur = const Color.fromARGB(255, 137, 10, 88);
  final Color cSett = const Color.fromARGB(255, 255, 40, 172);

  // TODO To be removed
  final _preferencesService = locator.get<PreferencesService>();

  HomeButtons();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.only(bottom: 50, left: 50, right: 50, top: 20),

      // physics:
      //     NeverScrollableScrollPhysics(), // to disable GridView's scrolling
      shrinkWrap: true, // to get around infinite size error
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        RoundButton(
            buttonText: 'INFORMATION',
            icon: Icon(
              Icons.pregnant_woman,
              color: Colors.white,
              size: 40,
            ),
            color: cInfo,
            onTap: () {
              Navigator.pushNamed(context, '/infoPagePage2');
            }),
        RoundButton(
            buttonText: 'PHR',
            icon: Icon(
              Icons.calendar_today,
              color: Colors.white,
              size: 40,
            ),
            color: cPhr,
            onTap: () {
              Navigator.pushNamed(context, '/pHRPage');
            }),
        RoundButton(
            buttonText: 'APPOINTEMENT',
            icon: Icon(
              Icons.calendar_today,
              color: Colors.white,
              size: 40,
            ),
            color: cAppoint,
            onTap: () {}),
        RoundButton(
          buttonText: 'COUNTERS',
          icon: Icon(
            Icons.timer,
            color: Colors.white,
            size: 40,
          ),
          color: cCount,
          onTap: () {},
        ),
        RoundButton(
            buttonText: 'MEASUREMENTS',
            icon: Icon(
              Icons.monitor_weight,
              color: Colors.white,
              size: 40,
            ),
            color: cMesur,
            onTap: () {
              //TODO To be removed
              _preferencesService.deleteDPA();
              _preferencesService.deleteLastPeriodDate();
            }),
        RoundButton(
            buttonText: 'SETTINGS',
            icon: Icon(
              Icons.settings,
              color: Colors.white,
              size: 40,
            ),
            color: cSett,
            onTap: () {
              Navigator.pushNamed(context, '/settingsPage');
            }
            ),
      ],
    );
  }
}
