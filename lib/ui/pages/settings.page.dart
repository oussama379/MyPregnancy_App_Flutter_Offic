import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:ma_grossesse/ui/pages/login/loginServices.dart';
import 'package:ma_grossesse/ui/pages/settings/widgets/firebasePasswordConfAlert.dart';
import 'package:ma_grossesse/ui/pages/settings/widgets/listItem.widget.dart';
import 'package:ma_grossesse/ui/pages/settings/widgets/passwordConfAlert.dart';

import '../../app_localizations.dart';
import '../../locator.dart';
import '../../preferencesService.dart';
import '../shared/toasts.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var wantPassVar;
  final _preferencesService = locator.get<PreferencesService>();
  final _loginService = locator.get<LoginServices>();
  final _toast = locator.get<toastMsg>();
  var _passwordFromPref;

  void getPasswordFromPref() async {
    final pass = await _preferencesService.getPassword();
    setState(() {
      _passwordFromPref = pass;
    });
  }

  @override
  void initState() {
    super.initState();
    getPasswordFromPref();
    getWantPasswordFromPref();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getWantPasswordFromPref() async {
    final wantPass = await _preferencesService.getWantPassword();
    setState(() {
      wantPassVar = wantPass;
    });
  }

  Future<void> contactUs(BuildContext context) async {
    final Email email = Email(
      recipients: ["spm.contact.magrossesse@gmail.com"],
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print(error);
    }
  }

  Future<String?> openDialog(BuildContext context) => showDialog<String>(
      context: context, builder: (BuildContext context) => MyAlertDialog());

  Future<String?> openFirebaseDialog(BuildContext context) => showDialog<String>(
      context: context, builder: (BuildContext context) => MyFirebaseAlertDialog());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
              AppLocalizations.of(context)!.translate('settings_page_title')),
        ),
        body: ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
            wantPassVar != false
                ? ListTile(
                    title: Row(
                      children: [
                        Icon(
                          Icons.toggle_on_outlined,
                          size: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('settings_page_deCode'),
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                    onTap: () async {
                      try {
                        var oldpPass = await openDialog(context);
                        if (oldpPass == _passwordFromPref) {
                          _preferencesService.deletePassword();
                          _preferencesService.saveWantPassword(false);
                          _toast.showMsg(AppLocalizations.of(context)!
                              .translate('settings_page_deCode_msg_ok'));
                        } else if (oldpPass == null || oldpPass.isEmpty) {
                          _toast.showMsg(AppLocalizations.of(context)!
                              .translate('settings_page_popUp_dialogError'));
                        } else {
                          _toast.showMsg(AppLocalizations.of(context)!
                              .translate(
                                  'settings_page_popUp_dialog_ErrorPwd'));
                        }
                      } on Exception catch (e) {
                        _toast.showMsg(AppLocalizations.of(context)!
                            .translate('password_auth_page_other_error'));
                      }
                      Navigator.popAndPushNamed(context, "/settingsPage");
                    })
                : ListTile(
                    title: Row(
                      children: [
                        Icon(
                          Icons.toggle_off_outlined,
                          size: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('settings_page_acCode'),
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                    onTap: () {
                      var fromSettings = true;
                      Navigator.pushNamed(context, "/createPasswordPage",
                          arguments: fromSettings);
                    }),
            Divider(color: Colors.black87),
            ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.vpn_key_outlined,
                      size: 35,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .translate('settings_page_changeLock'),
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                onTap: () async {
                  print(wantPassVar);
                  if (wantPassVar != false) {
                    var oldpPass = await openDialog(context);
                    if (oldpPass == _passwordFromPref) {
                      print('Hi');
                      var fromSettings = true;
                      Navigator.pushNamed(context, "/createPasswordPage",
                          arguments: fromSettings);
                    } else if (oldpPass == null || oldpPass.isEmpty) {
                      _toast.showMsg(AppLocalizations.of(context)!.translate(
                          'password_creation_page_pwd_field_error_noValue'));
                    } else {
                      _toast.showMsg(AppLocalizations.of(context)!
                          .translate('password_auth_page_wrongPass'));
                    }
                  } else {
                    var fromSettings = true;
                    Navigator.pushNamed(context, "/createPasswordPage",
                        arguments: fromSettings);
                  }
                }),
            Divider(color: Colors.black87),
            ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      size: 35,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .translate('settings_page_dicl'),
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/disclaimerPage");
                }),
            Divider(color: Colors.black87),
            ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.policy_outlined,
                      size: 35,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .translate('settings_page_privacy'),
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/privacyPolicyPage");
                }),
            Divider(color: Colors.black87),
            ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.contacts,
                      size: 35,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .translate('settings_page_contact'),
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                onTap: () {
                  contactUs(context);
                }),
            Divider(color: Colors.black87),
            ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 35,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .translate('settings_page_logout'),
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  _preferencesService.deleteLoggedIn();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/loginPage", (_) => false);
                  print('logged out');
                }),
            Divider(color: Colors.black87),
            ListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.restore_from_trash_rounded,
                      size: 35,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .translate('settings_page_delete'),
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                onTap: () async {
                  var firebasePwd = await openFirebaseDialog(context);
                  print(firebasePwd);
                  if(firebasePwd != null && firebasePwd.isNotEmpty) _showDeleteDialog(firebasePwd!);
                }),
          ],
        ));
  }

  void _showDeleteDialog(String pwd) {
    showDialog(
        context: this.context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!
                .translate('settings_page_delete_dialog_title')),
            content: Text(AppLocalizations.of(context)!
                .translate('settings_page_delete_dialog_text')),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!
                      .translate('weight_history_dialog_cancel'))),
              TextButton(
                  onPressed: () {
                    setState(() {
                      final FirebaseAuth _auth = FirebaseAuth.instance;
                      if (_auth.currentUser != null) {
                          String? email1 = _auth.currentUser?.email;
                          _loginService.deleteUser(email1!, pwd, context);
                      }
                    });
                  },
                  child: Text(AppLocalizations.of(context)!
                      .translate('weight_history_dialog_confirm'))),
            ],
          );
        });
  }
}
