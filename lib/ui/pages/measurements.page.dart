import 'package:flutter/material.dart';

import 'home/widgets/roundButton.home.dart';

class MeasurementsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Measurements'),
    ),
    body: Center(
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(100),
        shrinkWrap: true, // to get around infinite size error
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 1,
        children: <Widget>[
          RoundButton(
              buttonText: 'Weight',
              icon: Icon(
                Icons.monitor_weight,
                color: Colors.white,
                size: 45,
              ),
              color: Colors.pinkAccent,
              onTap: () {
                Navigator.pushNamed(context, '/weightMeasurements');
              }),
          RoundButton(
              buttonText: 'Pressure',
              icon: Icon(
                Icons.monitor_heart,
                color: Colors.white,
                size: 45,
              ),
              color:  Colors.pinkAccent,
              onTap: () {
                Navigator.pushNamed(context, '/pressureMeasurements');
              }),
        ],
      ),
    )
    );
  }
}
