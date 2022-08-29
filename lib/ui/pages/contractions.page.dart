import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_timer/simple_timer.dart';

import '../../app_localizations.dart';
import '../../extrasWidgets/icons_counters.dart';
import '../../locator.dart';
import '../shared/toasts.dart';
import '../sharedServices/checkInternetConnection.dart';
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

  late Map _source = {ConnectivityResult.wifi: true};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  //return the status of the internet cnx
  void updateCnx() {
    _connectivity.myStream.listen((source) {
      if (this.mounted) {
        setState(() {
          _source = source;
          print(_source.keys.toList()[0]);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _timerController = TimerController(this);
    _connectivity.initialise();
    updateCnx();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)!.translate('contractions_page_title')),
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
                    AppLocalizations.of(context)!
                        .translate('contractions_page_txtCounter'),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$_counter',
                    style:
                        TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
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
                  child: Text(
                      AppLocalizations.of(context)!
                          .translate('contractions_page_btn2'),
                      style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(backgroundColor: Colors.green)),
              SizedBox(
                width: 20,
              ),
              TextButton(
                  onPressed: onReset,
                  child: Text(
                      AppLocalizations.of(context)!
                          .translate('contractions_page_btn1'),
                      style: TextStyle(color: Colors.white)),
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
                label: Text(AppLocalizations.of(context)!
                    .translate('contractions_page_btn3')),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ColoredBox(
            color: Colors.pinkAccent,
            child: ListTile(
              onTap: null,
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!
                          .translate('contractions_page_list_field1'),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        AppLocalizations.of(context)!
                            .translate('contractions_page_list_field2'),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(
                        AppLocalizations.of(context)!
                            .translate('contractions_page_list_field3'),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(""),
                  ]),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _source.keys.toList()[0] == ConnectivityResult.none
              ? Center(
                  child: Container(
                    height: 120.0,
                    width: 300.0,
                    color: Colors.transparent,
                    child: Container(
                        padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                        decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Icon(
                                Icons.signal_wifi_off,
                                size: 40,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                AppLocalizations.of(context)!.translate('internet_errors5'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )),
                  ),
                )
              : Container(
                  child: FutureBuilder(
                      future: _contractionsRepo.getContractionsHistory().once(),
                      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                        contractionsList.clear();
                        contractionsListKeys.clear();
                        if (snapshot.hasData) {
                          Map<dynamic, dynamic> values = snapshot.data!.value;
                          if (values == null) {
                            return Center(
                              child: Container(),
                            );
                          }
                          values.forEach((key, values) {
                            contractionsListKeys.add(key);
                            contractionsList
                                .add(ContractionsModel.fromJson(values));
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
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      )
                                    ]),
                                    Row(children: [
                                      Text(
                                        contractionsList[index]
                                            .quantity
                                            .toString(),
                                        style: TextStyle(fontSize: 16),
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
                                        style: TextStyle(fontSize: 16),
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
    if(_source.keys.toList()[0] != ConnectivityResult.none) {
      if (counterStarted == true) {
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
          if(_contractionsRepo.calculateDur(duration) < 600 && quantity > 2){
            print('Duration : '+_contractionsRepo.calculateDur(duration).toString());
            _showContractionAlertDialog();
          }
          //
          _toast.showMsg(AppLocalizations.of(context)!
              .translate('contractions_page_toastMsg'));
        });
      }
    }else{
      if (counterStarted == true) {
        _timerController.reset();
      }
      _toast.showMsg(AppLocalizations.of(context)!.translate('internet_errors2'));
    }
  }

  void _showDeleteDialog(var index) {
    showDialog(
        context: this.context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!
                .translate('weight_history_dialog_title')),
            content: Text(AppLocalizations.of(context)!
                .translate('weight_history_dialog_text')),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!
                      .translate('weight_history_dialog_cancel'))),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _contractionsRepo
                          .deleteContractions(contractionsListKeys[index]);
                      //
                      _toast.showMsg(AppLocalizations.of(context)!
                          .translate('contractions_page_dialog_conf'));
                      Navigator.pop(context);
                    });
                  },
                  child: Text(AppLocalizations.of(context)!
                      .translate('weight_history_dialog_confirm'))),
            ],
          );
        });
  }
  void _showContractionAlertDialog() {
    showDialog(
        context: this.context,
        builder: (context) {
          return Container(
            //height: 300,
            child: AlertDialog(
              title: Text(AppLocalizations.of(context)!
                  .translate('pressure_HighAlertdialog_title')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_outlined, size: 40, color: Colors.red,),
                  SizedBox(height: 10,),
                  Text(AppLocalizations.of(context)!
                      .translate('contraction_HighAlertdialog')),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!
                        .translate('home_page_LPD_alert_conf'))),
              ],
            ),
          );
        });
  }

}
