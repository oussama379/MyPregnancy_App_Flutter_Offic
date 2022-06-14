import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:ma_grossesse/ui/pages/home/services/homeServices.dart';
import 'package:ma_grossesse/ui/pages/home/widgets/sideText.home.dart';

import '../../app_localizations.dart';
import '../../locator.dart';
import '../../preferencesService.dart';
import 'home/widgets/aboutAlertDialog.dart';
import 'home/widgets/bottomBar.home.dart';
import 'home/widgets/drawer.home.dart';
import 'home/widgets/homeButtons.home.dart';
import 'home/widgets/progressCircle.home.dart';
import 'home/widgets/roundButton.home.dart';
import 'package:nice_button/nice_button.dart';

import '../../globals.dart' as globals;

class HomePage2 extends StatefulWidget {
  @override
  State<HomePage2> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage2> {
  final _preferencesService = locator.get<PreferencesService>();
  DateTime lastPeriodDate = new DateTime(00, 00, 0000);
  final _HomeServices = locator.get<HomeServices>();
  var _dpaFromPref;
  var _lastPeriodFromPref = globals.lastPeriodDate;
  var _weekImage;
  var firstColor = Color(0xffff80ab), secondColor = Color(0xffe91e63);

  Future<void> onClick() async {
    DateTime? newDateTime = await showRoundedDatePicker(
      context: context,
      locale: Localizations.localeOf(context),
      theme: ThemeData(primarySwatch: Colors.pink),
      firstDate: DateTime(DateTime.now().year - 1),
    );
    //if cancel
    var date = new DateTime.now();
    if (newDateTime == null) return;
    if (newDateTime.isAfter(DateTime.now()) ||
        newDateTime
            .isBefore(new DateTime(date.year, date.month - 9, date.day))) {
      _HomeServices.InvalidPeriodDateDialog(context);
      return;
    }
    //if Okay
    var lastP;
    setState(() {
      lastPeriodDate = newDateTime;
      lastP = lastPeriodDate.day.toString() +
          '/' +
          lastPeriodDate.month.toString() +
          '/' +
          lastPeriodDate.year.toString();
      _lastPeriodFromPref = lastP;
      globals.lastPeriodDate = _lastPeriodFromPref;
      _dpaFromPref = _HomeServices.calculeDPA(lastP);
    });
    _preferencesService.saveLastPeriodDate(lastP);
    _preferencesService.saveDPA(_HomeServices.calculeDPA(lastP));
    //Navigator.pushNamedAndRemoveUntil(context, "/homePage", (_) => false);
    initImage();
  }

  void initImage() async {
    int pregWeek;
    if (globals.lastPeriodDate != null) {
      pregWeek = _HomeServices.gePregWeek(globals.lastPeriodDate);
      DatabaseReference _WeekPhoto;
      if (pregWeek >= 10) {
        _WeekPhoto = FirebaseDatabase.instance
            .reference()
            .child('Data')
            .child(pregWeek.toString())
            .child('image');
      } else {
        _WeekPhoto = FirebaseDatabase.instance
            .reference()
            .child('Data')
            .child("0" + pregWeek.toString())
            .child('image');
        ;
      }
      _WeekPhoto.onValue.listen((event) {
        final data = event.snapshot.value;
        setState(() {
          _weekImage = data;
        });
        print(_weekImage + ' In home');
      });
      getDpaFromPref();
    }
  }

  @override
  void initState() {
    super.initState();
    getDpaFromPref();
    getLastPeriodFromPref();
    initImage();
    //getPhoto();
  }

  void getDpaFromPref() async {
    final dpa = await _preferencesService.getDPA();
    setState(() {
      _dpaFromPref = dpa;
    });
  }

  void getLastPeriodFromPref() async {
    final lastPeriod = await _preferencesService.getLastPeriodDate();
    setState(() {
      _lastPeriodFromPref = lastPeriod;
    });
  }

  void getPhoto() async {
    print(globals.lastPeriodDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyPregnancy'),
      ),
      drawer: HomeDrawer(),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Container(
                child: _dpaFromPref != null
                    ? Text(
                        AppLocalizations.of(context)!
                                .translate('home_page_drawer_EDD') +
                            '\n' +
                            _HomeServices.calculeDPA(_lastPeriodFromPref),
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                    : Text(''),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: _dpaFromPref != null
                    ? Text(
                        AppLocalizations.of(context)!
                                .translate('home_page_drawer_InWeek') +
                            _HomeServices.gePregWeek(_lastPeriodFromPref)
                                .toString(),
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      )
                    : Text(''),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: _lastPeriodFromPref == null
                    ? Column(
                        children: [
                          CircleAvatar(
                            radius: 95,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('home_page_ImagesMsg'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            backgroundColor: Colors.grey,
                          ),
                          OutlinedButton.icon(
                            // foreground
                            onPressed: () {
                              onClick();
                              //Navigator.pushNamed(context, "/lastPeriod");
                            },
                            icon: const Icon(Icons.create),
                            label: Text(AppLocalizations.of(context)!
                                .translate('home_page_LastPeriodButton')),
                          )
                        ],
                      )
                    : _weekImage != null
                        ? Column(
                            children: [
                              CircleAvatar(
                                radius: 95,
                                child: ClipOval(
                                  child: Image.network(
                                    _weekImage,
                                    width: 190,
                                    height: 190,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              OutlinedButton.icon(
                                // foreground
                                onPressed: () {
                                  onClick();
                                  //Navigator.pushNamed(context, "/lastPeriod");
                                },
                                icon: const Icon(Icons.create),
                                label: Text(AppLocalizations.of(context)!
                                    .translate(
                                        'home_page_ChangeLastPeriodButton')),
                              )
                            ],
                          )
                        : CircularProgressIndicator(),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    NiceButton(
                      width: 50,
                      radius: 40,
                      mini: true,
                      padding: const EdgeInsets.all(10),
                      icon: Icons.pregnant_woman,
                      gradientColors: [secondColor, firstColor],
                      onPressed: () {
                        Navigator.pushNamed(context, '/infoPagePage2');
                      },
                    ),
                    Text(
                      AppLocalizations.of(context)!.translate('home_page_INFO'),
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    NiceButton(
                      width: 50,
                      radius: 40,
                      mini: true,
                      padding: const EdgeInsets.all(10),
                      icon: Icons.insert_drive_file_rounded,
                      gradientColors: [secondColor, firstColor],
                      onPressed: () {
                        Navigator.pushNamed(context, '/pHRPage');
                      },
                    ),
                    Text(
                      AppLocalizations.of(context)!.translate('home_page_PHR'),
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          //PregnancyProgress(),
        ],
      ),
      bottomNavigationBar: HomeBottomBar(),
    );
  }
}
