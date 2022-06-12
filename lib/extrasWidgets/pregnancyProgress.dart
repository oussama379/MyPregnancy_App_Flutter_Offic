import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class PregnancyProgress extends StatelessWidget {
  PregnancyProgress();
  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
      CircleAvatar(
        radius: 15,
        backgroundImage: AssetImage('assets/images/ovum.png'),
      ),
      Expanded(
        child: StepProgressIndicator(
          totalSteps: 39,
          currentStep: 39,
          size: 10,
          selectedColor: Color.fromARGB(255, 255, 7, 205),
          unselectedColor: Colors.black,
        ),
      ),
      CircleAvatar(
        radius: 15,
        backgroundImage: AssetImage('assets/images/baby.png'),
      ),
    ]);
  }
}
