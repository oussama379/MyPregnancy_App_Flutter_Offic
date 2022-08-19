import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  void setLocale(Locale locale){
    _locale = locale;
    notifyListeners();
  }

  void clearLocale(){
    _locale = null;
    notifyListeners();
  }
}