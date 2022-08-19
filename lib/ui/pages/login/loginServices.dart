import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import '../../../app_localizations.dart';
import '../../../locator.dart';
import '../../../preferencesService.dart';
import '../../shared/toasts.dart';
import '../../../globals.dart' as globals;

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
    }catch (error) {
      print(error);
    }
  }


  LoginServices();
}