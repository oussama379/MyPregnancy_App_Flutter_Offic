import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../app_localizations.dart';

class HomeServices{


  int daysBetween(String lastPeriod) {
    var lastPeriodSplited = lastPeriod.split('/');
    //print(lastPeriod);
    //print(lastPeriodSplited[0]);
    //print(lastPeriodSplited[1]);
    //print(lastPeriodSplited[2]);

    DateTime lasP = DateTime(int.parse(lastPeriodSplited[2]), int.parse(lastPeriodSplited[1]), int.parse(lastPeriodSplited[0]));
    //print(lasP);
    DateTime now = DateTime.now();
    return (now.difference(lasP).inHours / 24).round();
  }




  //Date prévue d'accouchement
  String calculeDPA(String ddr){
    String res, jour = "", mois = "";
    var tab = ddr.split("/");
    var jj = int.parse(tab[0]);
    var mm = int.parse(tab[1]);
    var aa = int.parse(tab[2]);
    aa++;
    mm -= 3;
    if(mm < 1){
      if(mm == 0){
        mm = 12;
      }else{
        mm += 12;
      }
      aa--;
    }
    jj += 14;
    if(mm == 1 || mm == 3 || mm == 5 || mm == 7  || mm == 8 || mm == 12 || mm == 10){
      if(jj > 31){
        jj %= 31;
        mm++;
        if(mm == 13){
          mm = 1;
          aa++;
        }
      }
    }else if(mm == 4 || mm == 6 || mm == 11 || mm == 9){
      if(jj > 30){
        jj %= 30;
        mm++;
      }
    }else if(mm == 2){
      if(jj > 28){
        jj %= 28;
        mm++;
      }
    }
    if (jj <= 9) {
      jour = "0" + jj.toString();
    }else{
      jour = "" + jj.toString();
    }
    if(mm <= 9){
      mois = "0" + mm.toString();
    }else{
      mois = "" + mm.toString();
    }
    res = jour + "/" + mois + "/" + aa.toString();
    return res;
  }


  String getWeekPhoto(String lastPeriod){
    int pregWeek;
    pregWeek = gePregWeek(lastPeriod);
    DatabaseReference _WeekPhoto;
    var photoLink;
    if (pregWeek >= 10) {
      _WeekPhoto = FirebaseDatabase.instance.reference().child('Data').child(pregWeek.toString()).child('image');
    } else {
      _WeekPhoto = FirebaseDatabase.instance.reference().child('Data').child("0" +pregWeek.toString()).child('image');;
    }
    _WeekPhoto.onValue.listen((event) {
        final data = event.snapshot.value;
        photoLink = data;
        print(photoLink + ' In Services');
      });
    return photoLink;
    }

    int gePregWeek(String lastPeriod){
      double weekValue = (daysBetween(lastPeriod) / 7) + 1;
      //print(weekValue.toInt());
      return weekValue.toInt() ;
    }

  HomeServices();
  Future<void> InvalidPeriodDateDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate('home_page_LPD_alert_title')),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text(AppLocalizations.of(context)!.translate('home_page_LPD_alert_msg')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate('home_page_LPD_alert_conf')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  }









