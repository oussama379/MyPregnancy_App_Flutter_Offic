import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'dart:math' as math;

class ProgressCircle extends StatelessWidget {
  const ProgressCircle();
  @override
  Widget build(BuildContext context) {
    return CircularStepProgressIndicator(
      totalSteps: 40,
      currentStep: 40,
      stepSize: 15,
      selectedColor: Color.fromARGB(255, 249, 3, 204),
      unselectedColor: Color.fromARGB(255, 220, 22, 128),
      padding: math.pi / 80,
      width: 100,
      height: 120,
      startingAngle: -math.pi * 2 / 3,
      arcSize: math.pi * 2 / 3 * 2,
      gradientColor: LinearGradient(
        colors: [
          Color.fromARGB(255, 249, 3, 204),
          Color.fromARGB(255, 220, 22, 128)
        ],
      ),
      child: CircleAvatar(
        radius: 50,
        child : Text('Tap Here', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey,
        //backgroundImage: AssetImage('assets/images/embryo.png'),
      ),
    );
  }
}
