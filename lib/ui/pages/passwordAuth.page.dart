import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ma_grossesse/ui/pages/passwordAuth/passwordAuthServices.dart';

import '../../app_localizations.dart';
import '../../locator.dart';
import '../../preferencesService.dart';
import '../shared/toasts.dart';
import 'home/widgets/sideText.home.dart';

class PasswordAthenPage extends StatefulWidget {
  @override
  _PasswordAthenPageState createState() => _PasswordAthenPageState();
}

class _PasswordAthenPageState extends State<PasswordAthenPage> {
  bool _isVisible1 = false;

  TextEditingController _password = TextEditingController();

  final _preferencesService = locator.get<PreferencesService>();
  final _passwordAuthenServices = locator.get<PasswordAuthServices>();
  final _formKey = GlobalKey<FormState>();

  var _passwordFromPref;
  var _loggedInFromPref;

  final FirebaseAuth auth = FirebaseAuth.instance;

  final _toast = locator.get<toastMsg>();

  @override
  void initState() {
    super.initState();
    getPasswordFromPref();
    getLoggedInFromPref();
  }

  var email_Msg;

  void getPasswordFromPref() async {
    final pass = await _preferencesService.getPassword();
    setState(() {
      _passwordFromPref = pass;
    });
  }

  void getLoggedInFromPref() async {
    final loggedIn = await _preferencesService.getLoggedIn();
    setState(() {
      _loggedInFromPref = loggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!
            .translate('password_auth_page_title')),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: [0.7, 1.5],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.pinkAccent])),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
                    //   child: Center(
                    //     child: Container(
                    //       //width: 200,
                    //       //height: 150,
                    //         child: Column(
                    //           children: [
                    //             Image.asset('assets/images/USAID-logo.png',
                    //                 width: 90, height: 90),
                    //             SizedBox(
                    //               height: 10,
                    //             ),
                    //             SideText(AppLocalizations.of(context)!.translate('intro_acknowledgment')),
                    //           ],
                    //         )),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Center(
                        child: Container(
                            child: Column(
                          children: [
                            Image.asset('assets/images/appIcon.png',
                                width: 100, height: 100),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'MyPregnancy',
                              style: TextStyle(
                                  color: Colors.pinkAccent,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            //SideText('My Pregnancy',),
                          ],
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 30, bottom: 0),
                      child: TextFormField(
                        controller: _password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.translate(
                                'password_creation_page_pwd_field_error_noValue');
                          }
                          if (value != _passwordFromPref) {
                            return AppLocalizations.of(context)!
                                .translate('password_auth_page_wrongPass');
                          }
                          return null;
                        },
                        obscureText: !_isVisible1,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isVisible1 = !_isVisible1;
                                });
                              },
                              icon: _isVisible1
                                  ? Icon(
                                      Icons.visibility,
                                      color: Colors.black,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                            ),
                            border: OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.translate(
                                'password_creation_page_pwd_field_title'),
                            hintText: AppLocalizations.of(context)!.translate(
                                'password_creation_page_pwd_field_title')),
                      ),
                    ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    TextButton(
                      onPressed: () {
                        auth.currentUser != null
                            ? _passwordAuthenServices.sendEmail(
                            context, email_Msg, _passwordFromPref)
                            : Navigator.pushNamedAndRemoveUntil(
                            context, "/createPasswordPage", (_) => false);
                        ;
                        print('Done');
                      },
                      child: auth.currentUser != null
                          ? Text(
                        AppLocalizations.of(context)!.translate(
                            'password_auth_page_recover_email'),
                        style: TextStyle(
                            color: Colors.pinkAccent, fontSize: 15),
                      )
                          : Text(
                        AppLocalizations.of(context)!
                            .translate('password_auth_page_reset_email'),
                        style: TextStyle(
                            color: Colors.pinkAccent, fontSize: 15),
                      ),
                    ),
                    Container(
                      height: 45,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(5)),
                      child: TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (_loggedInFromPref == true) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/homePage", (_) => false);
                            } else {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/loginPage", (_) => false);
                            }
                            _toast.showMsg(AppLocalizations.of(context)!
                                .translate('password_auth_page_auth_succ'));
                            print("Successful");
                          } else {
                            _toast.showMsg(AppLocalizations.of(context)!
                                .translate('password_auth_page_auth_error'));
                            print("Unsuccessful");
                          }
                          //Navigator.pushNamed(context, "/homePage");
                        },
                        child: Text(
                          AppLocalizations.of(context)!.translate(
                              'password_creation_page_confirm_button'),
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }
}
