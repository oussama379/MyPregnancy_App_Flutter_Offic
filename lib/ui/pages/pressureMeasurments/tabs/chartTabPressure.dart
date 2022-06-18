import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightModel.dart';
import 'package:ma_grossesse/ui/pages/weightMeasurments/weightRepo.dart';
import '../../../../globals.dart' as globals;

import '../../../../locator.dart';
import '../../../shared/toasts.dart';
import '../widget/line_chart_widget_pressure.dart';

class ChartPagePressure extends StatefulWidget {
  @override
  State<ChartPagePressure> createState() => _ChartPageStatePressure();
}

class _ChartPageStatePressure extends State<ChartPagePressure> {
  final _weightRepo = locator.get<WeightRepo>();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: LineChartWidget(),
      ),
    );
  }
}
