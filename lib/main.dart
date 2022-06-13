import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ma_grossesse/preferencesService.dart';
import 'package:ma_grossesse/ui/pages/createAccount.page.dart';
import 'package:ma_grossesse/ui/pages/createPassword.page.dart';
import 'package:ma_grossesse/ui/pages/disclaimer.page.dart';
import 'package:ma_grossesse/ui/pages/home.page.dart';
import 'package:ma_grossesse/ui/pages/home.page2.dart';
import 'package:ma_grossesse/ui/pages/home/services/homeServices.dart';
import 'package:ma_grossesse/ui/pages/info.page.dart';
import 'package:ma_grossesse/ui/pages/info.page2.dart';
import 'package:ma_grossesse/ui/pages/lastPeriod.page.dart';
import 'package:ma_grossesse/ui/pages/login.page.dart';
import 'package:ma_grossesse/ui/pages/passwordAuth.page.dart';
import 'package:ma_grossesse/ui/pages/phr.page.dart';
import 'package:ma_grossesse/ui/pages/privacyPolicy.page.dart';
import 'package:ma_grossesse/ui/pages/recoverPassword.page.dart';
import 'package:ma_grossesse/ui/pages/settings.page.dart';
import 'package:ma_grossesse/ui/sharedServices/checkInternetConnection.dart';
import './theme/custom_theme.dart';

import 'package:firebase_core/firebase_core.dart';

import 'app_localizations.dart';
import 'locator.dart';
import 'globals.dart' as globals;

var wantPassword;
var loggedIn;
var route;
var UID;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  // injection d'independences in locator.dart file
  setupDependencyInjection();
  // PreferencesService : class that handles interactions with shared preferences
  final _preferencesService = locator.get<PreferencesService>();
  final _homeService = locator.get<HomeServices>();
  final lastPeriodDate = await _preferencesService.getLastPeriodDate();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  if(_auth.currentUser != null) globals.UID = _auth.currentUser?.uid;
  if(lastPeriodDate != null) globals.lastPeriodDate = lastPeriodDate;
  print('in main UID : ');
  print(globals.UID);
  print(globals.lastPeriodDate);




  // get the variable that indicates whether the user have set an app pwd or not
  final wantPasswordVar = await _preferencesService.getWantPassword();
  // get the variable that indicates whether the user is logged in or not
  final loggedInVar = await _preferencesService.getLoggedIn();



  wantPassword = wantPasswordVar;
  loggedIn = loggedInVar;
  route = _preferencesService.setInitialRoute(wantPassword, loggedInVar);
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Pregnancy',
      theme: CustomTheme.lightTheme,
      routes: {
        '/homePage': (context) => HomePage2(),
        '/createPasswordPage' : (context) => CreatePasswordPage(),
        '/passwordAuthPage' : (context) => PasswordAthenPage(),
        '/loginPage' : (context) => LoginPage(),
        '/createAccountPage' : (context) => CreateAccountPage(),
        '/recoverPasswordPage' : (context) => RecoverPasswordPage(),
        '/settingsPage' : (context) => SettingsPage(),
        '/disclaimerPage' : (context) => DisclaimerPage(),
        '/privacyPolicyPage' : (context) => PrivacyPolicyPage(),
        '/infoPagePage' : (context) => InfoPage(),
        '/infoPagePage2' : (context) => InfoPage2(),
        '/pHRPage' : (context) => PHRPage(),
        '/lastPeriod' : (context) => LastPeriod(),
      },
      //TODO to be change to route
      initialRoute: route,
      // List all of the app's supported locales here
      supportedLocales: [
        Locale('en', ''),
        Locale('ar', ''),
        Locale('fr', ''),
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
    );
  }
}

