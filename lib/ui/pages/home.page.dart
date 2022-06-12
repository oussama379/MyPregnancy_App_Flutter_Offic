import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:ma_grossesse/ui/pages/home/services/homeServices.dart';
import 'package:ma_grossesse/ui/pages/home/widgets/sideText.home.dart';

import '../../locator.dart';
import '../../preferencesService.dart';
import 'home/widgets/homeButtons.home.dart';
import 'home/widgets/progressCircle.home.dart';
import 'home/widgets/roundButton.home.dart';
import '../../globals.dart' as globals;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _preferencesService = locator.get<PreferencesService>();
  DateTime lastPeriodDate = new DateTime(00, 00, 0000);
  final _HomeServices = locator.get<HomeServices>();
  var _dpaFromPref;
  var _lastPeriodFromPref = globals.lastPeriodDate;
  var _weekImage ;
  //= 'https://retchhh.files.wordpress.com/2015/03/loading2.gif';

  // late DateTime dpaFromPrefFormat ;
  // late DateTime lastPeriodFromPrefFormat ;

  @override
  void initState() {
    super.initState();
    getDpaFromPref();
    getLastPeriodFromPref();
    int pregWeek;
    if(globals.lastPeriodDate != null) {
      pregWeek = _HomeServices.gePregWeek(globals.lastPeriodDate);
      DatabaseReference _WeekPhoto;
      if (pregWeek >= 10) {
        _WeekPhoto = FirebaseDatabase.instance.reference().child('Data').child(
            pregWeek.toString()).child('image');
      } else {
        _WeekPhoto = FirebaseDatabase.instance.reference().child('Data').child(
            "0" + pregWeek.toString()).child('image');
        ;
      }
      _WeekPhoto.onValue.listen((event) {
        final data = event.snapshot.value;
        _weekImage = data;
        print(_weekImage + ' In home');
      });
      getDpaFromPref();
    }
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
          title: Text('Ma Grossesse - Les Orangers'),
        ),
        body: Center(
          child: ListView(
            children: [
              Container(
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          _dpaFromPref != null
                              ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: SideText(
                                  'Expected date of delivery : \n'+ _HomeServices.calculeDPA(_lastPeriodFromPref)),
                            ),
                          )
                              : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: SideText(''),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10, left: 5, right:5),
                              child: _lastPeriodFromPref == null ? GestureDetector(
                                onTap: () async {
                                  Navigator.pushNamed(context, "/lastPeriod");
                                },
                                child: CircleAvatar(
                                  radius: 60,
                                  child: Text('Tap Here',
                                      style: TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.grey,
                                ),
                              ) : CircleAvatar(
                                radius: 60,
                                child:  ClipOval(
                                  child: Image.network(
                                    _weekImage,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                // Text('',
                                //     style: TextStyle(color: Colors.white)),
                                // //backgroundColor: Colors.grey,
                                // foregroundImage: _weekImage == null ? NetworkImage('https://retchhh.files.wordpress.com/2015/03/loading2.gif') : NetworkImage(_weekImage.toString())
                              ),
                            ),
                            //child: ProgressCircle(),
                          ),
                          _lastPeriodFromPref != null
                              ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: SideText(
                                  'You are in week X \n ( '+_HomeServices.daysBetween(_lastPeriodFromPref).toString()+' days of pregnancy )'),
                            ),
                          )
                              : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: SideText(''),
                            ),
                          )
                        ],
                      ),
                      //PregnancyProgress(),
                    ],
                  )),
              Container(
                child: HomeButtons(),
              ),
            ],
          ),
                //: Center(child: CircularProgressIndicator()),
        ));
  }
}
