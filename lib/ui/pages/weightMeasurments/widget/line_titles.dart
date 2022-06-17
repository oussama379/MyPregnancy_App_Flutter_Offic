import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class LineTitles {
  static getTitleData(List<String> xTitles, List<double> yTitles) => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          getTitles: (value) {
            return xTitles[value.toInt()];
            //return 'FYT';
          },
          margin: 8,
          rotateAngle: -70,
        ), leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          getTitles: (value) {
            return yTitles[value.toInt()].toString();
          },
          reservedSize: 35,
          margin: 12,
        ),
      );
}
