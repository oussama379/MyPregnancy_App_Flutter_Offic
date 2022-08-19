import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ma_grossesse/ui/pages/information/repo/monthRepo.dart';

import '../../app_localizations.dart';
import '../../locator.dart';
import '../../preferencesService.dart';
import '../sharedServices/checkInternetConnection.dart';
import 'information/model/slide.dart';
import 'information/widgets/slide_dots.dart';
import 'information/widgets/slide_item.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';




class InfoPage2 extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage2> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final _monthRepo = locator.get<MonthDao>();
  List<Map<dynamic, dynamic>> listMonths = [];
  late Map _source = {ConnectivityResult.wifi: true};
  final MyConnectivity _connectivity = MyConnectivity.instance;

   Query getMonths(){
     if(Localizations.localeOf(context).toString() == 'en') {
       print(Localizations.localeOf(context));
       return _monthRepo.getMonthQueryEnglish();
     } else if(Localizations.localeOf(context).toString() == 'fr'){
       print(Localizations.localeOf(context));
       return _monthRepo.getMonthQueryFrench();
     } else if(Localizations.localeOf(context).toString() == 'ar') {
       print(Localizations.localeOf(context));
       return _monthRepo.getMonthQueryArab();
     } else {
       print('in else');
       return _monthRepo.getMonthQueryEnglish();
     }
   }


  //return the status of the internet cnx
  void updateCnx(){
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
    _connectivity.initialise();
    updateCnx();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }


  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('info_page_title')),
      ),
      body: _source.keys.toList()[0] == ConnectivityResult.none ? Center(
        child: Container(
          height: 120.0,
          width: 300.0,
          color: Colors.transparent,
          child: Container(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child:  Center(
                child:  Column(
                  children: [
                    SizedBox(height: 10,),
                    Icon(Icons.signal_wifi_off, size: 40, color: Colors.white,),
                    SizedBox(height: 5,),
                    Text(AppLocalizations.of(context)!.translate('info_page_cnx_error_msg'),
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,),
                    SizedBox(height: 10,),
                  ],
                ),
              )),
        ),
      ) : Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    FutureBuilder(
                        future:  getMonths().once(),
                        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                          if (snapshot.hasData) {
                            listMonths.clear();
                            Map<dynamic, dynamic> values = snapshot.data!.value;
                            values.forEach((key, values) {
                              listMonths.add(values);
                            });
                            return
                            PageView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: _pageController,
                              onPageChanged: _onPageChanged,
                              itemCount: listMonths.length,
                              itemBuilder: (ctx, i) => SlideItem(listMonths[i]["image"], listMonths[i]["title"], listMonths[i]["description1"]),
                            );
                          }
                          return Center(child: CircularProgressIndicator());
                        }
                        ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for(int i = 0 ; i < listMonths.length ; i++)
                            if(i == _currentPage)
                              SlideDots(true)
                            else
                              SlideDots(false)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}