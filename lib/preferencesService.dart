import 'dart:ffi';

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