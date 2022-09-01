import 'dart:convert';
import 'dart:ffi';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {

  String setInitialRoute(var wantPassword, var loggedIn){
    var initRoute;
    if(wantPassword != null){
      if(wantPassword == true && loggedIn == true)
        initRoute = '/passwordAuthPage';
      if(wantPassword == false && loggedIn == true)
        initRoute = '/homePage';
      if(wantPassword == false && loggedIn == null)
        initRoute = '/loginPage';
      if(wantPassword == true && loggedIn == null)
        initRoute = '/passwordAuthPage';
    }
    else{
      initRoute = '/createPasswordPage';
    }
    return initRoute;
  }

  Future saveWantPassword(bool wantPasswordVar) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('wantPassword', wantPasswordVar);
  }

  Future<bool>  saveAppointmentDates(DateTime dateTime) async {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");
    String date = dateFormat.format(dateTime);
    List<dynamic> list = [];
    final preferences = await SharedPreferences.getInstance();
    final appointmentDates = preferences.getString('appointmentDates');
    if(appointmentDates != null) list  = json.decode(appointmentDates);
    for (var d in list) {
      if(d == date) {print('False'); return false;}
    }
    list.add(date);
    var s = json.encode(list);
    await preferences.setString('appointmentDates', s);
    //print('True');
    //print('Saved AppointmentDates'+s);
    return true;
  }

  Future<bool> deleteAppointmentDates(String date) async {
    List<dynamic> list = [];
    final preferences = await SharedPreferences.getInstance();
    final appointmentDates = preferences.getString('appointmentDates');
    if(appointmentDates != null) list  = json.decode(appointmentDates);
    list.removeWhere((d) => d == date);
    var s = json.encode(list);
    await preferences.setString('appointmentDates', s);
    print('True');
    print('deleted AppointmentDate'+s);
    return true;
  }


  Future<List<String>?> getAppointmentsDates() async {
    final preferences = await SharedPreferences.getInstance();
    final appointmentDates = preferences.getString('appointmentDates');
    List<String> list  = json.decode(appointmentDates!);
    return list;
  }



  Future<bool?> getWantPassword() async {
    final preferences = await SharedPreferences.getInstance();
    final wantPasswordVar = preferences.getBool('wantPassword');
    return wantPasswordVar;
  }

  Future deleteWantPassword() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('wantPassword');
    print('deleted wantPassword');
  }


  Future<bool?> getLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    final loggedIn = preferences.getBool('loggedIn');
    return loggedIn;
  }

  Future savePassword(String password) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('appPassword', password);
    print('Saved password');
  }

  Future saveLastPeriodDate(String lastPeriodDate) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('lastPeriodDate', lastPeriodDate);
    print('Saved lastPeriodDate');
  }

  Future<String?> getLastPeriodDate() async {
    final preferences = await SharedPreferences.getInstance();
    final lastPeriodDate = preferences.getString('lastPeriodDate');
    //print(lastPeriodDate);
    print('Got lastPeriodDate');
    return lastPeriodDate;
  }
  Future deleteLastPeriodDate() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('lastPeriodDate');
    print('deleted lastPeriodDate');
  }

  Future saveDPA(String DPA) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('DPA', DPA);
    print('Saved DPA');
  }

  Future<String?> getDPA() async {
    final preferences = await SharedPreferences.getInstance();
    final DPA = preferences.getString('DPA');
    //print(DPA);
    print('Got DPA');
    return DPA;
  }
  Future deleteDPA() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('DPA');
    print('deleted DPA');
  }


  Future deletePassword() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('appPassword');
    print('deleted appPassword');
  }



  Future saveLoggedIn(bool loggedIn) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('loggedIn', loggedIn);
  }


  Future deleteLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('loggedIn');
    print('deleted loggedIn');
  }



  Future<String?> getPassword() async {
    final preferences = await SharedPreferences.getInstance();
    final password = preferences.getString('appPassword');
    print('Got password');
    return password;
  }

}