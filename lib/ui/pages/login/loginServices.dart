
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import '../../../app_localizations.dart';
import '../../../locator.dart';
import '../../../preferencesService.dart';
import '../../shared/toasts.dart';
import '../../../globals.dart' as globals;
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';



class LoginServices {


  final _preferencesService = locator.get<PreferencesService>();
  final _toast = locator.get<toastMsg>();

  void signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      print(email);
      print(password);
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _preferencesService.saveLoggedIn(true);
      _toast.showMsg(AppLocalizations.of(context)!.translate('login_page_loggedIn_succ'));
      globals.UID = FirebaseAuth.instance.currentUser!.uid;
      print('after login UID :');
      print(globals.UID);
      Navigator.pushNamedAndRemoveUntil(context, "/homePage", (_) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.translate('login_page_email_field_error_notFound'))));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.translate('login_page_email_field_error_wrong'))));
      }else
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.translate('password_auth_page_other_error'))));
      print(e.code);
    }
  }
  Future<void> sendEmail(BuildContext context,var email_Msg) async {
    //New Begin
    if (Platform.isIOS) {
        final toEmail = "spm.contact.magrossesse@gmail.com";
        final subject = 'Créer un compte';
        final body = email_Msg;

        final url = 'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';
        if (!await launchUrl(Uri.parse(url))) {
          throw 'Could not launch $url';
        }

      // final bool canSend = await FlutterMailer.canSendMail();
      // if (!canSend) {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
      //       AppLocalizations.of(context)!.translate('email_error_msg'))));
      //   return;
      // } else {
      //   final MailOptions mailOptions = MailOptions(
      //     body: email_Msg,
      //     subject: "Créer un compte",
      //     recipients: ["spm.contact.magrossesse@gmail.com"],
      //     isHTML: false,
      //   );
      //   String platformResponse;
      //   final MailerResponse response = await FlutterMailer.send(mailOptions);
      //   switch (response) {
      //     case MailerResponse.saved: /// ios only
      //       platformResponse = 'mail was saved to draft';
      //       break;
      //     case MailerResponse.sent: /// ios only
      //       platformResponse = 'mail was sent';
      //       break;
      //     case MailerResponse.cancelled: /// ios only
      //       platformResponse = 'mail was cancelled';
      //       break;
      //     case MailerResponse.android:
      //       platformResponse = 'intent was successful';
      //       break;
      //     default:
      //       platformResponse = 'unknown';
      //       break;
      //   }
      //   print('platformResponse : $platformResponse');
      // }
    } else {
      //New End
      final Email email = Email(
        body: email_Msg,
        subject: "Créer un compte",
        recipients: ["spm.contact.magrossesse@gmail.com"],
        isHTML: false,
      );
      try {
        await FlutterEmailSender.send(email);
        Navigator.popUntil(context, ModalRoute.withName('/loginPage'));
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Your request was sent.')));
      } on PlatformException catch (e) {
        if (e.code == 'not_available')
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
              AppLocalizations.of(context)!.translate('email_error_msg'))));
        print(e.code);
        //if(error == 'PlatformException')
      }
    }
  }

  DatabaseReference reference = FirebaseDatabase.instance
      .reference()
      .child('Patientes');

  Future<bool> deletePatientInfo() async {
    reference.child(globals.UID.toString()).remove().whenComplete(() { print('Done'); return true;});
    return true;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future deleteUser(String email, String password, BuildContext context) async {
    try {
      AuthCredential credentials = EmailAuthProvider.credential(email: email, password: password);
      await _auth.currentUser!.reauthenticateWithCredential(credentials);
      await  _auth.currentUser?.delete();
      _preferencesService.deleteLoggedIn();
      _toast.showMsg(AppLocalizations.of(context)!
          .translate('contractions_page_dialog_conf'));
      Navigator.pushNamedAndRemoveUntil(context, "/loginPage", (_) => false);
      print('logged out');
      return Future.value(true);
    } catch (e) {
      print(e.toString());
      _toast.showMsg(AppLocalizations.of(context)!
          .translate('settings_page_popUp_dialog_ErrorPwd'));
      Navigator.pop(context);
      print('Error Delete');
      return Future.value(false);
    }
  }

  LoginServices();
}