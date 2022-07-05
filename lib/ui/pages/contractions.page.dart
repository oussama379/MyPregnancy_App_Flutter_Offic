import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_timer/simple_timer.dart';

import '../../app_localizations.dart';
import '../../extrasWidgets/icons_counters.dart';
import '../../locator.dart';
import '../shared/toasts.dart';
import 'counters/babyKicks/babyKickModel.dart';
import 'counters/babyKicks/babyKickRepo.dart';
import 'counters/contractions/contractionsModel.dart';
import 'counters/contractions/contractionsRepo.dart';

class ContractionsPage extends StatefulWidget {
  @override
  State<ContractionsPage> createState() => _ContractionsPageState();
}

class _ContractionsPageState extends State<ContractionsPage>
    with SingleTickerProviderStateMixin {
  late TimerController _timerController;
  TimerStyle _timerStyle = TimerStyle.ring;
  TimerProgressIndicatorDirection _progressIndicatorDirection =
      TimerProgressIndicatorDirection.clockwise;
  TimerProgressTextCountDirection _progressTextCountDirection =
      TimerProgressTextCountDirection.count_up;
  int _counter = 0;
  bool counterStarted = false;
  List<String> durations = [];
  final _contractionsRepo = locator.get<ContractionsRepo>();
  List<ContractionsModel> contractionsList = [];
  List<String> contractionsListKeys = [];
  final _toast = locator.get<toastMsg>();

  @override
  void initState() {
    super.initState();
    _timerController = TimerController(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contractions Counter'),
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: SimpleTimer(
                  duration: Duration(seconds: 100000000000000),
                  controller: _timerController,
                  //timerStyle: _timerStyle,
                  onStart: handleTimerOnStart,
                  onEnd: handleTimerOnEnd,
                  valueListener: timerValueChangeListener,
                  backgroundColor: Colors.grey,
                  progressIndicatorColor: Colors.pinkAccent,
                  progressIndicatorDirection: _progressIndicatorDirection,
                  progressTextCountDirection: _progressTextCountDirection,
                  progressTextStyle:
                      TextStyle(color: Colors.black, fontSize: 55),
                  strokeWidth: 5,
                ),
              )),
              Expanded(
                child: Container(),
              ),
              Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Contractions',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                '$_counter',
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
              ),
                    ],
                  ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: _timerController.start,
                  child: const Text("Start",
                      style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(backgroundColor: Colors.green)),
              SizedBox(
                width: 20,
              ),
              TextButton(
                  onPressed: onReset,
                  child:
                      const Text("Stop", style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(backgroundColor: Colors.red)),
              SizedBox(
                width: 20,
              ),
              OutlinedButton.icon(
                style: ButtonStyle(
                    side: MaterialStateProperty.all(
                  BorderSide.lerp(
                      BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.pinkAccent,
                        width: 3.0,
                      ),
                      BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.pinkAccent,
                        width: 3.0,
                      ),
                      10.0),
                )),
                onPressed: () {
                  setState(() {
                    if (counterStarted) _counter++;
                  });
                },
                icon: const Icon(DBIcons.image2vector__1_),
                label: Text('Contraction'),
              )
            ],
          ),
          SizedBox(height: 10,),
          ColoredBox(
            color: Colors.pinkAccent,
            child: ListTile(
              onTap: null,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                Text("Date and Time", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                Text("Quantity", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text("Duration", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(""),
              ]),
            ),
          ),
          SizedBox(height: 10,),
          Container(
              child: FutureBuilder(
                  future: _contractionsRepo.getContractionsHistory().once(),
                  builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                    contractionsList.clear();
                    contractionsListKeys.clear();
                    if (snapshot.hasData) {
                      Map<dynamic, dynamic> values = snapshot.data!.value;
                      if (values == null){
                        return Center(
                          child: Container(
                          ),
                        );
                      }
                      values.forEach((key, values) {
                        contractionsListKeys.add(key);
                        contractionsList.add(ContractionsModel.fromJson(values));
                      });
                      return ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey,
                          thickness: 3,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: contractionsList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    contractionsList[index].dateAndTime,
                                    style: TextStyle(
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  )
                                ]),
                                Row(children: [
                                  Text(
                                    contractionsList[index].quantity.toString(),
                                    style: TextStyle(
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  )
                                ]),
                                Row(children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    contractionsList[index].duration,
                                    style: TextStyle(
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  )
                                ]),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: IconButton(
                                    icon: new Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _showDeleteDialog(index);
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                    //return Center(child: Container(),);
                    return Center(child: CircularProgressIndicator());
                  })),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timerController.dispose();
  }

  void handleTimerOnStart() {
    print("timer has just started");
    setState(() {
      counterStarted = true;
    });
  }

  void handleTimerOnEnd() {
    print("timer has ended");
  }

  void timerValueChangeListener(Duration timeElapsed) {
    //print(timeElapsed.inMinutes.toString()+':'+timeElapsed.inSeconds.toString());
    durations.add(timeElapsed.inMinutes.toString() +
        ':' +
        timeElapsed.inSeconds.toString());
    //print(DateFormat('dd-MM-yyyy hh:mm:ss').format(timeElapsed));
  }

  void onReset() {
    _timerController.reset();
    DateTime dateTime = DateTime.now();
    String date = DateFormat('dd-MM-yyyy hh:mm:ss').format(dateTime);
    int quantity = _counter;
    String duration = durations[durations.length.toInt() - 2];
    String dateIntString =
        DateFormat('yyyy/MM/dd').format(dateTime).replaceAll('/', '');
    int datInt = int.parse(dateIntString);
    print('date : $date');
    print('quantity : $quantity');
    print('duration : $duration');
    ContractionsModel contractionsModel =
    ContractionsModel(quantity, date, duration, datInt);
    setState(() {
      _counter = 0;
      counterStarted = false;
      _contractionsRepo.SaveContractions(contractionsModel.toJson());
      _toast.showMsg('Saved Successfully');
    });
  }
  void _showDeleteDialog(var index){
    showDialog(context: this.context, builder: (context){
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('weight_history_dialog_title')),
        content: Text(AppLocalizations.of(context)!.translate('weight_history_dialog_text')),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text(AppLocalizations.of(context)!.translate('weight_history_dialog_cancel'))),
          TextButton(onPressed: (){
            setState(() {
              _contractionsRepo.deleteContractions(contractionsListKeys[index]);
              _toast.showMsg('Deleted Successfully');
              Navigator.pop(context);
            });
          }, child: Text(AppLocalizations.of(context)!.translate('weight_history_dialog_confirm'))),
        ],
      );
    });
  }
}
