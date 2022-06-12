import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ma_grossesse/ui/pages/passwordAuth/passwordAuthServices.dart';

import '../../app_localizations.dart';
import '../../locator.dart';


class RecoverPasswordPage extends StatefulWidget {
  @override
  _RecoverPasswordPageState createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final _passwordAuthenServices = locator.get<PasswordAuthServices>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('recoverPass_page_title')),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 150.0, left: 30, right: 30),
                child: Center(
                  child: Container(
                    //
                    // width: 150,
                    // height: 100,
                      child: Text(
                        AppLocalizations.of(context)!.translate('recoverPass_page_text'),
                        style: TextStyle(color: Color.fromARGB(255, 116, 111, 111), fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.translate('login_page_email_field_error_noValue');
                    }
                    if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                      return AppLocalizations.of(context)!.translate('recoverPass_page_email_field_noValid');
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.translate('login_page_email_field_title'),
                      hintText: 'abc@gmail.com'),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 45,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      _passwordAuthenServices.resetPassword(context, _emailController.text);
                      print ("Successful");
                    }else{
                      print ("Unsuccessful");
                    }
                  },
                  child: Text(
                      AppLocalizations.of(context)!.translate('recoverPass_page_title'),
                    style: TextStyle(color: Colors.white, fontSize: 17,)
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
    _emailController.dispose();
    super.dispose();
  }
}
