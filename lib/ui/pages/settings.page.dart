import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
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
//TODO translate some text (PopUpDialogue)
class _SettingsPageState extends State<SettingsPage> {
  var wantPassVar;
  final _preferencesService = locator.get<PreferencesService>();
  final _toast = locator.get<toastMsg>();
  var _passwordFromPref ;

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
    }catch (error) {
      print(error);
    }
  }
  Future<String?> openDialog(BuildContext context) => showDialog<String>(
      context: context,
      builder: (BuildContext context) => MyAlertDialog()
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.translate('settings_page_title')),
        ),
        body: ListView(

          padding: const EdgeInsets.only(top: 8),
          children: <Widget>[
            ListItem(text: AppLocalizations.of(context)!.translate('settings_page_logout'), icon: Icons.logout_rounded, onTap: (){
              FirebaseAuth.instance.signOut();
              _preferencesService.deleteLoggedIn();
              Navigator.pushNamedAndRemoveUntil(context, "/loginPage", (_) => false);
              print('logged out');
            }),
            // Divider(indent: 30, endIndent: 30, color: Colors.black87),
            // ListItem(text: AppLocalizations.of(context)!.translate('settings_page_pregnancyInfo'), icon: Icons.info_outline_rounded, onTap: () async {
            //
            // }),
            Divider(indent: 30, endIndent: 30, color: Colors.black87),
            ListItem(text: AppLocalizations.of(context)!.translate('settings_page_changeLock'), icon: Icons.vpn_key_outlined, onTap: () async {
              print(wantPassVar);
              if(wantPassVar != false) {
                var oldpPass = await openDialog(context);
                if (oldpPass == _passwordFromPref) {
                  print('Hi');
                  var fromSettings = true;
                  Navigator.pushNamed(
                      context, "/createPasswordPage", arguments: fromSettings);
                } else if (oldpPass == null || oldpPass.isEmpty) {
                  _toast.showMsg(AppLocalizations.of(context)!.translate('password_creation_page_pwd_field_error_noValue'));
                }
                else {
                  _toast.showMsg(AppLocalizations.of(context)!.translate('password_auth_page_wrongPass'));
                }
              }else{
                var fromSettings = true;
                Navigator.pushNamed(
                    context, "/createPasswordPage", arguments: fromSettings);
              }
    }),
            Divider(indent: 30, endIndent: 30, color: Colors.black87),
            ListItem(text: AppLocalizations.of(context)!.translate('settings_page_contact'), icon: Icons.contacts, onTap: (){
              contactUs(context);
            }),
            Divider(indent: 30, endIndent: 30, color: Colors.black87),
            ListItem(text: AppLocalizations.of(context)!.translate('settings_page_dicl'), icon: Icons.warning_amber_outlined, onTap: (){
              Navigator.pushNamed(context, "/disclaimerPage");
            }),
            Divider(indent: 30, endIndent: 30, color: Colors.black87),
            ListItem(text: AppLocalizations.of(context)!.translate('settings_page_privacy'), icon: Icons.policy_outlined, onTap: (){
              Navigator.pushNamed(context, "/privacyPolicyPage");
            }),
            Divider(indent: 30, endIndent: 30, color: Colors.black87),
            wantPassVar != false
                ? ListItem(
                    text: AppLocalizations.of(context)!.translate('settings_page_deCode'), icon: Icons.toggle_on_outlined, onTap: () async {
                      try {
                          var oldpPass = await openDialog(context);
                          if (oldpPass == _passwordFromPref) {
                            _preferencesService.deletePassword();
                            _preferencesService.saveWantPassword(false);
                            _toast.showMsg(
                                AppLocalizations.of(context)!.translate(
                                    'settings_page_deCode_msg_ok'));
                          } else if (oldpPass == null || oldpPass.isEmpty) {
                            _toast.showMsg('Please enter your old password');
                          }
                          else {
                            _toast.showMsg('Incorrect Password');
                          }

                      } on Exception catch (e) {
                        _toast.showMsg(AppLocalizations.of(context)!.translate('password_auth_page_other_error'));
                      }
              Navigator.popAndPushNamed(context, "/settingsPage");
            })
                : ListItem(
                    text: AppLocalizations.of(context)!.translate('settings_page_acCode'), icon: Icons.toggle_off_outlined, onTap: (){
              var fromSettings = true;
              Navigator.pushNamed(context, "/createPasswordPage", arguments: fromSettings);
            }),
          ],
        )
        );


  }
}
