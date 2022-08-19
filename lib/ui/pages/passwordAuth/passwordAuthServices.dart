import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../app_localizations.dart';

class PasswordAuthServices {


  final FirebaseAuth auth = FirebaseAuth.instance;

  Future sendEmail(BuildContext context, var email_Msg, var password) async {
    email_Msg = AppLocalizations.of(context)!.translate('email_recovery_msg') + password;
    final User? user = auth.currentUser;
    String? recipient = user?.email;
    String greeting  = AppLocalizations.of(context)!.translate('email_recovery_greeting');
    String emailSubject = AppLocalizations.of(context)!.translate('email_recovery_subject');
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = 'service_lv198kr';
    const templateId = 'template_72jwim8';
    const userId = 'J5LC2vTtG6SqdeMYw';
    try{
      final response = await http.post(url,
          headers: {
            'origin' : 'http://localhost',
            'Content-Type': 'application/json'},
          //This line makes sure it works for all platforms.
          body: json.encode({
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': userId,
            'template_params': {
              'user_greeting': greeting,
              'user_email': recipient,
              'user_message': email_Msg,
              'user_subject': emailSubject,
            }
          }));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.translate('password_auth_page_pwd_sent'))));
    } catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.translate('password_auth_page_other_error'))));
    }
  }
  Future<void> resetPassword(BuildContext context, String email)  async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.translate('recoverPass_page_check_email'))));
      Navigator.popUntil(context, ModalRoute.withName('/loginPage'));
    }on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found')
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.translate('login_page_email_field_error_notFound'), style: TextStyle(fontSize: 17),)));
      if(e.code == 'invalid-email')
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.translate('recoverPass_page_email_field_noValid'), style: TextStyle(fontSize: 17),)));
      else
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.translate('internet_errors1'), style: TextStyle(fontSize: 17),)));

    }
  }

  PasswordAuthServices();
}