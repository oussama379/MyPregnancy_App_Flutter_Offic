import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../app_localizations.dart';
import '../weightModel.dart';
import 'line_titles.dart';
import '../../../../globals.dart' as globals;

class LineChartWidget extends StatefulWidget {
  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<WeightModel> weightsList = [];
  List<WeightModel> weightsListSortedWeight = [];
  List<FlSpot> flSpots = [];
  List<String> xTitles = [];
  List<String> yTitles = [];
  List<double> ySortedTitles = [];

  int i = 0;
  @override
  void initState() {
    super.initState();
  }

  final List<Color> gradientColors = [
    const Color.fromRGBO(255,192,203,1),
    const Color.fromRGBO(255,20,147,1),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseDatabase.instance
            .reference()
            .child('Patientes')
            .child(globals.UID.toString())
            .child("mesures")
            .child("poids")
            .orderByChild('dateInt')
            .once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          weightsList.clear();
          weightsListSortedWeight.clear();
          flSpots.clear();
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
                          color: Colors.transparent,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: new Center(
                        child: new Text(
                          AppLocalizations.of(context)!.translate('weight_history_noHistory'),
                          style: TextStyle(
                              color: Colors.pinkAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
              );

            values.forEach((key, values) {
              weightsList.add(WeightModel.fromJson(values));
              weightsListSortedWeight.add(WeightModel.fromJson(values));
              weightsListSortedWeight.sort();
              ySortedTitles.add(WeightModel.fromJson(values).weight.toDouble());
              ySortedTitles.sort();
              i++;
              xTitles.add(WeightModel.fromJson(values).date);
              yTitles.add(WeightModel.fromJson(values).weight.toString());
            }
            );
            return Padding(
              padding: const EdgeInsets.only(left : 5.0,right : 25.0,top: 5.0,bottom : 5.0,),
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: weightsList.length.toDouble() - 1,
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
                      spots: spots(),
                      isCurved: true,
                      colors: gradientColors,
                      barWidth: 3,
                      //dotData: FlDotData(show: false, checkToShowDot: ),
                      belowBarData: BarAreaData(
                        show: true,
                        colors: gradientColors
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

  List<FlSpot> spots(){
    int i = 0;
    xTitles.forEach((element) {
      flSpots.add(FlSpot(i.toDouble(), ytitles().indexOf(weightsList[i].weight.toDouble()).toDouble()));
      i++;
    });
    print('flSpots  :'+flSpots.toString());
    print('weightsList.length.toDouble()  :'+weightsList.length.toDouble().toString());
    return flSpots;
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
