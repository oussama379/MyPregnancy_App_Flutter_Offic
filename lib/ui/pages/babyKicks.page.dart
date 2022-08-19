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

class BabyKicksPage extends StatefulWidget {
  @override
  State<BabyKicksPage> createState() => _BabyKicksPageState();
}

class _BabyKicksPageState extends State<BabyKicksPage>
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
  final _babyKicksRepo = locator.get<BabyKickRepo>();
  List<BabyKickModel> babyKicksList = [];
  List<String> babyKicksListKeys = [];
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
            AppLocalizations.of(context)!.translate('babyKicks_page_title')),
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
                        .translate('babyKicks_page_txtCounter'),
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
                icon: const Icon(DBIcons.feet),
                label: Text(AppLocalizations.of(context)!
                    .translate('babyKicks_page_btn3')),
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
                                AppLocalizations.of(context)!.translate('internet_errors4'),
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
                      future: _babyKicksRepo.getBabyKicksHistory().once(),
                      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                        babyKicksList.clear();
                        babyKicksListKeys.clear();
                        if (snapshot.hasData) {
                          Map<dynamic, dynamic> values = snapshot.data!.value;
                          if (values == null) {
                            return Center(
                              child: Container(),
                            );
                          }
                          values.forEach((key, values) {
                            babyKicksListKeys.add(key);
                            babyKicksList.add(BabyKickModel.fromJson(values));
                          });
                          return ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                              color: Colors.grey,
                              thickness: 3,
                            ),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: babyKicksList.length,
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
                                        babyKicksList[index].dateAndTime,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      )
                                    ]),
                                    Row(children: [
                                      Text(
                                        babyKicksList[index]
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
                                        babyKicksList[index].duration,
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

  void handleTimerOnEnd() {
    print("timer has ended");
  }

  void handleTimerOnStart() {
    print("timer has just started");
    setState(() {
      counterStarted = true;
    });
  }


  void onReset() {
    if (_source.keys.toList()[0] != ConnectivityResult.none) {
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
        BabyKickModel babyKickModel =
            BabyKickModel(quantity, date, duration, datInt);
        setState(() {
          _counter = 0;
          counterStarted = false;
          _babyKicksRepo.SaveBabyKicks(babyKickModel.toJson());
          _toast.showMsg(AppLocalizations.of(context)!
              .translate('contractions_page_toastMsg'));
        });
      }
    } else {
      if (counterStarted == true) {
        _timerController.reset();
      }
      _toast.showMsg(AppLocalizations.of(context)!.translate('internet_errors2'));

    }
  }

  void timerValueChangeListener(Duration timeElapsed) {
    //print(timeElapsed.inMinutes.toString()+':'+timeElapsed.inSeconds.toString());
    durations.add(timeElapsed.inMinutes.toString() +
        ':' +
        timeElapsed.inSeconds.toString());
    //print(DateFormat('dd-MM-yyyy hh:mm:ss').format(timeElapsed));
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
                      _babyKicksRepo.deleteBabyKicks(babyKicksListKeys[index]);
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
}
