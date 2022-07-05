import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../app_localizations.dart';
import '../pressureModel.dart';
import 'line_titles_pressure.dart';
import '../../../../globals.dart' as globals;

class LineChartWidget extends StatefulWidget {
  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<PressureModel> pressuresList = [];
  List<PressureModel> pressuresListSortedSys = [];
  List<PressureModel> pressuresListSortedDias = [];
  List<FlSpot> flSpotsSys = [];
  List<FlSpot> flSpotsDias = [];
  List<String> xTitles = [];
  List<String> yTitles = [];
  List<double> ySortedTitles = [];

  int i = 0;
  @override
  void initState() {
    super.initState();
  }

  final List<Color> gradientColorsSys = [
    const Color.fromRGBO(255,0,0,1),
    const Color.fromRGBO(255, 102, 102, 1.0),
  ];

  final List<Color> gradientColorsDias = [
    const Color.fromRGBO(7, 238, 238, 1.0),
    const Color.fromRGBO(8, 174, 227, 1.0),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseDatabase.instance
            .reference()
            .child('Patientes')
            .child(globals.UID.toString())
            .child("mesures")
            .child("tension")
            .orderByChild('dateInt')
            .once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          pressuresList.clear();
          pressuresListSortedSys.clear();
          pressuresListSortedDias.clear();
          flSpotsSys.clear();
          flSpotsDias.clear();
          xTitles.clear();
          yTitles.clear();
          ySortedTitles.clear();
          i = 0;
          // weightsListKeys.clear();
          if (snapshot.hasData) {
            Map<dynamic, dynamic> values = snapshot.data!.value;
            if (values == null)
              return Center(
                child: Container(
                  height: 100.0,
                  width: 300.0,
                  color: Colors.transparent,
                  child: Container(
                      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: new Center(
                        child: new Text(
                          AppLocalizations.of(context)!.translate('weight_history_noHistory'),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
              );

            values.forEach((key, values) {
              pressuresList.add(PressureModel.fromJson(values));
              pressuresListSortedSys.add(PressureModel.fromJson(values));
              pressuresListSortedDias.add(PressureModel.fromJson(values));
              pressuresListSortedSys.sort((a, b) => a.pressureSystolic.compareTo(b.pressureSystolic));
              pressuresListSortedDias.sort((a, b) => a.pressureDiastolic.compareTo(b.pressureDiastolic));
              ySortedTitles.add(PressureModel.fromJson(values).pressureSystolic.toDouble());
              ySortedTitles.add(PressureModel.fromJson(values).pressureDiastolic.toDouble());
              ySortedTitles.sort();
              i++;
              xTitles.add(PressureModel.fromJson(values).date);
              yTitles.add(PressureModel.fromJson(values).pressureSystolic.toString());
              yTitles.add(PressureModel.fromJson(values).pressureDiastolic.toString());
            }
            );
            return Padding(
              padding: const EdgeInsets.only(left : 5.0,right : 25.0,top: 5.0,bottom : 5.0,),
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: pressuresList.length.toDouble() - 1,
                  minY: 0,
                  maxY: ytitles().length.toDouble() - 1,
                  titlesData: LineTitles.getTitleData(xtitles(), ytitles()),
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.black54,
                        strokeWidth: 1,
                      );
                    },
                    drawVerticalLine: true,
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.black54,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black54, width: 1),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: SpotsSys(),
                      isCurved: true,
                      colors: gradientColorsSys,
                      barWidth: 3,
                      //dotData: FlDotData(show: false, checkToShowDot: ),
                      belowBarData: BarAreaData(
                        show: true,
                        colors: gradientColorsSys
                            .map((color) => color.withOpacity(0.3))
                            .toList(),
                      ),
                    ),
                    LineChartBarData(
                      spots: spotsDias(),
                      isCurved: true,
                      colors: gradientColorsDias,
                      barWidth: 3,
                      //dotData: FlDotData(show: false, checkToShowDot: ),
                      belowBarData: BarAreaData(
                        show: true,
                        colors: gradientColorsDias
                            .map((color) => color.withOpacity(0.3))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }return Center(child: CircularProgressIndicator());
        });
  }

  List<FlSpot> SpotsSys(){
    int i = 0;
    xTitles.forEach((element) {
      flSpotsSys.add(FlSpot(i.toDouble(), ytitles().indexOf(pressuresList[i].pressureSystolic.toDouble()).toDouble()));
      i++;
    });
    print('flSpotsSys  :'+flSpotsSys.toString());
    print('pressuresList.length.toDouble()  :'+pressuresList.length.toDouble().toString());
    return flSpotsSys;
  }
  List<FlSpot> spotsDias(){
    int i = 0;
    xTitles.forEach((element) {
      flSpotsDias.add(FlSpot(i.toDouble(), ytitles().indexOf(pressuresList[i].pressureDiastolic.toDouble()).toDouble()));
      i++;
    });
    print('flSpotsDias  :'+flSpotsDias.toString());
    print('pressuresList.length.toDouble()  :'+pressuresList.length.toDouble().toString());
    return flSpotsDias;
  }

  List<String> xtitles(){
    print('xTitles:'  + xTitles.toString());
    return xTitles;
  }
  List<double> ytitles(){
    ySortedTitles = ySortedTitles.toSet().toList();
    print('ySortedTitles :' + ySortedTitles.toString());
    return ySortedTitles;
  }
}
