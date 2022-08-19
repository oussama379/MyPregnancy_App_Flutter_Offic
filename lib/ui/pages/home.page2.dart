import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:ma_grossesse/main.dart';
import 'package:ma_grossesse/ui/pages/home/services/homeServices.dart';
import 'package:ma_grossesse/ui/pages/home/widgets/sideText.home.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';
import '../../localeProvider.dart';
import '../../locator.dart';
import '../../preferencesService.dart';
import '../sharedServices/checkInternetConnection.dart';
import 'home/widgets/aboutAlertDialog.dart';
import 'home/widgets/bottomBar.home.dart';
import 'home/widgets/drawer.home.dart';
import 'home/widgets/homeButtons.home.dart';
import 'home/widgets/languageSection.dart';
import 'home/widgets/progressCircle.home.dart';
import 'home/widgets/roundButton.home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:country_icons/country_icons.dart';


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

    _connectivity.initialise();
    updateCnx();

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
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(title: Text('MyPregnancy'),
        actions: [
          LanguageSection(),
        ],

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
                            fontSize: 17.sp, fontWeight: FontWeight.bold),
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
                            fontSize: 17.sp, fontWeight: FontWeight.bold),
                      )
                    : Text(''),
              ),
              SizedBox(
                height: 20,
              ),
              _source.keys.toList()[0] != ConnectivityResult.none
                  ? Container(
                      child: _lastPeriodFromPref == null
                          ? Column(
                              children: [
                                CircleAvatar(
                                  radius: 95.r,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('home_page_ImagesMsg'),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.sp),
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
                                      radius: 95.r,
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
                    )
                  : Column(
                      children: [
                        Container(
                          child: Container(
                            height: 120.0,
                            width: 150.0,
                            color: Colors.transparent,
                            child: Container(
                                padding: const EdgeInsets.only(
                                    right: 10.0, left: 10.0),
                                decoration: BoxDecoration(
                                    color: Colors.pinkAccent,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(80.0))),
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
                                        AppLocalizations.of(context)!
                                            .translate('internet_errors3'),
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
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _lastPeriodFromPref == null
                            ? OutlinedButton.icon(
                                // foreground
                                onPressed: () {
                                  onClick();
                                  //Navigator.pushNamed(context, "/lastPeriod");
                                },
                                icon: const Icon(Icons.create),
                                label: Text(AppLocalizations.of(context)!
                                    .translate('home_page_LastPeriodButton')),
                              )
                            : OutlinedButton.icon(
                                // foreground
                                onPressed: () {
                                  onClick();
                                  //Navigator.pushNamed(context, "/lastPeriod");
                                },
                                icon: const Icon(Icons.create),
                                label: Text(AppLocalizations.of(context)!
                                    .translate(
                                        'home_page_ChangeLastPeriodButton')),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
              SizedBox(
                height: 10,
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
                    SizedBox(
                      width: 120.0.w,
                      height: 75.0.h,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Icon(
                              Icons.pregnant_woman,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('home_page_INFO'),
                              style: TextStyle(
                                fontSize: 15.0.sp,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/infoPagePage2');
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 110.0.w,
                      height: 75.0.h,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Icon(
                              Icons.timer,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('home_page_Navig_Btn_2'),
                              style: TextStyle(
                                fontSize: 15.0.sp,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/countersPage');
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 100.0.w,
                      height: 75.0.h,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Icon(
                              Icons.insert_drive_file_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('home_page_PHR'),
                              style: TextStyle(
                                fontSize: 15.0.sp,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/pHRPage');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 140.0.w,
                      height: 75.0.h,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('home_page_Navig_Btn_1'),
                              style: TextStyle(
                                fontSize: 15.0.sp,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/appointementsCalendarPage');
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 140.0.w,
                      height: 75.0.h,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Icon(
                              Icons.monitor_weight,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('home_page_Navig_Btn_3'),
                              style: TextStyle(
                                fontSize: 15.0.sp,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/measurements');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //PregnancyProgress(),
        ],
      ),

      //bottomNavigationBar: HomeBottomBar(),
    );
  }

}
