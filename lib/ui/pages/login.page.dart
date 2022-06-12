import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ma_grossesse/ui/pages/login/loginServices.dart';

import '../../app_localizations.dart';
import '../../locator.dart';
import '../../preferencesService.dart';
import '../shared/toasts.dart';
import 'home/widgets/sideText.home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isVisible1 = false;
  final _toast = locator.get<toastMsg>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // TextEditingControllers are used for tracking changes to those text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _preferencesService = locator.get<PreferencesService>();
  final _loginService = locator.get<LoginServices>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text(AppLocalizations.of(context)!.translate('login_page_title')),
      // ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(
                  child: Container(
                      //
                      // width: 150,
                      // height: 100,
                      child: Column(
                        children: [
                          Image.asset('assets/images/appIcon.png',  width: 100, height: 100),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'MyPregnancy',
                            style: TextStyle(color: Colors.pinkAccent, fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          //SideText('My Pregnancy',),
                        ],
                      )
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
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.translate('password_creation_page_pwd_field_error_noValue');
                    }
                    // if(value != _passwordFromPref){
                    //   return AppLocalizations.of(context)!.translate('password_auth_page_wrongPass');
                    // }
                    return null;
                  },
                  obscureText: !_isVisible1,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
                      labelText: AppLocalizations.of(context)!.translate('password_creation_page_pwd_field_title'),
                      hintText: AppLocalizations.of(context)!.translate('password_creation_page_pwd_field_title')),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/recoverPasswordPage");
                },
                child: Text(
                  AppLocalizations.of(context)!.translate('login_page_forgot_button'),
                  style: TextStyle(color: Colors.pinkAccent, fontSize: 15),
                ),
              ),
              Container(
                height: 45,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(5),),
                child: TextButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      _loginService.signInWithEmailAndPassword(context, _emailController.text, _passwordController.text);
                      print ("Successful");
                    }else{
                      print ("Unsuccessful");
                    }
                  },
                  child: Text(
                      AppLocalizations.of(context)!.translate('login_page_title'),
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 45,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(5),),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/createAccountPage");
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('login_page_create_button'),
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
