import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_localizations.dart';
import '../../locator.dart';
import '../../preferencesService.dart';
import '../shared/toasts.dart';
import 'home/widgets/sideText.home.dart';

class CreatePasswordPage extends StatefulWidget {
  @override
  _CreatePasswordPageState createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  bool _isVisible1 = false;
  bool _isVisible2 = false;
  late String _passwordText;
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();
  final _preferencesService = locator.get<PreferencesService>();
  final _formKey = GlobalKey<FormState>();
  final _toast = locator.get<toastMsg>();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ModalRoute.of(context)!.settings.arguments == null
            ? Text(AppLocalizations.of(context)!
                .translate('password_creation_page_title'))
        //TODO translate
            : Text('Change Password'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
                //if the user is coming from settings then change what's displayed in the top of the page
                child: ModalRoute.of(context)!.settings.arguments == null
                    ? Center(
                        child: Container(
                            //width: 200,
                            //height: 150,
                            child: Column(
                          children: [
                            Image.asset('assets/images/USAID-logo.png',
                                width: 90, height: 90),
                            SizedBox(
                              height: 10,
                            ),
                            SideText(AppLocalizations.of(context)!
                                .translate('intro_acknowledgment')),
                          ],
                        )),
                      )
                    : Center(
                        child: Container(
                            //width: 200,
                            //height: 150,
                            child: Column(
                          children: [
                            Image.asset('assets/images/appIcon.png',
                                width: 90, height: 90),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'MyPregnancy',
                              style: TextStyle(color: Colors.pinkAccent, fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                  controller: _password,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.translate(
                          'password_creation_page_pwd_field_error_noValue');
                    }
                    if (value.length < 4) {
                      return AppLocalizations.of(context)!.translate(
                          'password_creation_page_pwd_field_error_strong');
                    }
                    _passwordText = value;
                    return null;
                  },
                  obscureText: !_isVisible1,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
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
                      labelText: AppLocalizations.of(context)!
                          .translate('password_creation_page_pwd_field_title'),
                      hintText: AppLocalizations.of(context)!
                          .translate('password_creation_page_pwd_field_title')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                  controller: _confirmpassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.translate(
                          'password_creation_page_pwdConf_field_error_noValue');
                    }
                    if (_confirmpassword.text != _password.text) {
                      return AppLocalizations.of(context)!.translate(
                          'password_creation_page_pwdConf_field_error_noMatch');
                    }
                    return null;
                  },
                  obscureText: !_isVisible2,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isVisible2 = !_isVisible2;
                          });
                        },
                        icon: _isVisible2
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
                          'password_creation_page_pwdConf_field_title'),
                      hintText: AppLocalizations.of(context)!.translate(
                          'password_creation_page_pwdConf_field_title')),
                ),
              ),
              TextButton(
                onPressed: () {
                  _preferencesService.saveWantPassword(false);
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/loginPage", (_) => false);

                  //Navigator.pushNamed(context, "/homePage");
                },
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('password_creation_page_no_pwd_msg'),
                  style: TextStyle(color: Colors.pinkAccent, fontSize: 15),
                ),
              ),
              Container(
                height: 45,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(5),
                 ),
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _preferencesService.saveWantPassword(true);
                      _preferencesService.savePassword(_passwordText);
                      _toast.showMsg(AppLocalizations.of(context)!
                          .translate('password_creation_page_toast_succ'));

                      Navigator.pushNamedAndRemoveUntil(
                          context, "/passwordAuthPage", (_) => false);
                      print("Successful");
                    } else {
                      _toast.showMsg(
                          AppLocalizations.of(context)!.translate('failed'));
                      print("Unsuccessful");
                    }
                    //Navigator.pushNamed(context, "/homePage");
                  },
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('password_creation_page_confirm_button'),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _password.dispose();
    _confirmpassword.dispose();
    super.dispose();
  }
}
