import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../../app_localizations.dart';
import '../../locator.dart';
import '../shared/toasts.dart';
import 'home/widgets/sideText.home.dart';
import 'login/loginServices.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _toast = locator.get<toastMsg>();
  final _loginService = locator.get<LoginServices>();


  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _nbPregController = TextEditingController();

  var email_Msg ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('createAccount_page_title')),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Container(
                    height: 100.0,
                    width: 300.0,
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                        decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        child: new Center(
                          child: new Text(AppLocalizations.of(context)!.translate('createAccount_page_text_msg'),
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,),
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
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
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                  controller: _mobileController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.translate('createAccount_page_phone_field_error_noValue');
                    }
                    if(int.tryParse(value) == null){
                      return AppLocalizations.of(context)!.translate('createAccount_page_phone_field_noValid');
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.phone,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.translate('createAccount_page_mobile_field_title'),
                      hintText: 'xx-xx-xx-xx-xx'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                  controller: _ageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.translate('createAccount_page_age_field_error_noValue');
                    }
                    if(int.tryParse(value) == null){
                      return AppLocalizations.of(context)!.translate('createAccount_page_phone_field_noValid');
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.cake,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.translate('createAccount_page_age_field_title'),
                      hintText: AppLocalizations.of(context)!.translate('createAccount_page_age_field_title')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                  controller: _nbPregController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.translate('createAccount_page_nbPreg_field_error_noValue');
                    }
                    if(int.tryParse(value) == null){
                      return AppLocalizations.of(context)!.translate('createAccount_page_phone_field_noValid');
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.child_friendly_rounded,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.translate('createAccount_page_nbPreg_field_title'),
                      hintText: AppLocalizations.of(context)!.translate('createAccount_page_nbPreg_field_title')),
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
                    borderRadius: BorderRadius.circular(5)),
                child: TextButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      email_Msg = "Bonjour, \n Une patiente vient de faire une demande de création de compte dans l'application du suivi prénatal, ci-dessous ses informations: \n\n"+ 'Email : '+ _emailController.text +"\n" +'Numéro de téléphone : '+ _mobileController.text+"\n"
                          +'Age : '+ _ageController.text +"\n"  +'Nombre de grossesses précédentes : '+ _nbPregController.text;

                      _loginService.sendEmail(context, email_Msg);
                      print ("Successful");
                    }else{
                      _toast.showMsg(AppLocalizations.of(context)!.translate('failed'));
                      print ("Unsuccessful");
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('createAccount_page_send_button'),
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _nbPregController.dispose();
    _ageController.dispose();
  }
}
