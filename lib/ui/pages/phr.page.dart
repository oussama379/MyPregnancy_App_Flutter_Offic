import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ma_grossesse/ui/pages/phr/model/phrMedicalProfile.dart';
import 'package:ma_grossesse/ui/pages/phr/model/phrPresonalProfile.dart';
import 'package:ma_grossesse/ui/pages/phr/repo/phrRepo.dart';
import 'package:ma_grossesse/ui/pages/phr/widgets/phrBar.dart';
import 'package:ma_grossesse/ui/pages/phr/widgets/phrInfoListTile.dart';
import 'package:ma_grossesse/ui/sharedServices/checkInternetConnection.dart';

import '../../app_localizations.dart';
import '../../locator.dart';
//this global variable contains the UID of the logged in user
import '../../globals.dart' as globals;
class PHRPage extends StatefulWidget {
  @override
  _PHRPageState createState() => _PHRPageState();
}
class _PHRPageState extends State<PHRPage> {
  final _phrRepo = locator.get<PhrDao>();
  late Map _source = {ConnectivityResult.wifi: true};
  final MyConnectivity _connectivity = MyConnectivity.instance;
  var  _personalProfile;
  var _medicalProfile;

  //return the status of the internet cnx
  void updateCnx(){
    _connectivity.myStream.listen((source) {
      if (this.mounted) {
        setState(() {
          _source = source;
          print(_source.keys.toList()[0]);
        });
      }
    });
  }



  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    updateCnx();
    DatabaseReference _patientsRefPersonalProfile = FirebaseDatabase.instance.reference().child('Patientes').child(globals.UID.toString()).child('profil').child('personel');
    _patientsRefPersonalProfile.onValue.listen((event) {
      final data = event.snapshot.value;
          setState(() {
              _personalProfile = PersonalProfile.fromJson(data);
          });
      print(_personalProfile.toString());
    });
    DatabaseReference _patientsRefMedicalProfile = FirebaseDatabase.instance.reference().child('Patientes').child(globals.UID.toString()).child('profil').child('medical');
    _patientsRefMedicalProfile.onValue.listen((event) {
      final data = event.snapshot.value;
      setState(() {
        _medicalProfile = MedicalProfile.fromJson(data);
      });
      print(_medicalProfile.toString());
    });
  }





  @override
  Widget build(BuildContext context){
    return _source.keys.toList()[0] == ConnectivityResult.none ?
    Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('phr_page_title')),
      ),
      body: Center(
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
                child: new Text(AppLocalizations.of(context)!.translate('info_page_cnx_error_msg'),
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),
              )),
        ),
      ), )
        : Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('phr_page_title')),
      ),
        body: _personalProfile != null && _medicalProfile != null ? ListView(
                  children: <Widget>[
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.pinkAccent, Colors.pink],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [0.5, 0.9],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.white70,
                                minRadius: 60.0,
                                child: CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage:
                                  NetworkImage(_personalProfile.image),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Text(
                              _personalProfile.nom == '' ? AppLocalizations.of(context)!.translate('phr_page_noPhrYet_msg') : _personalProfile.nom + ' ' + _personalProfile.prenom,
                              //personalInfo[6] + ' ' + personalInfo[8],
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PhrBar(AppLocalizations.of(context)!.translate('phr_page_personalProfile_title')),
                    Container(
                      child: Column(
                        children: <Widget>[
                          PhrListTile(AppLocalizations.of(context)!.translate('login_page_email_field_title'), _personalProfile.email, Icon(Icons.email, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_mobile'), _personalProfile.numero, Icon(Icons.phone_android_sharp, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_Birthday'), _personalProfile.date_naissance, Icon(Icons.cake, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_FamilySituation'), _personalProfile.situation_familiale, Icon(Icons.family_restroom, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_Address'), _personalProfile.adresse, Icon(Icons.home, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_AgeofMarriage'), _personalProfile.age_mariage, Icon(Icons.family_restroom, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_Profession'), _personalProfile.profession, Icon(Icons.work, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_Instruction'), _personalProfile.instruction, Icon(Icons.directions, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_Height'),_personalProfile.taille, Icon(Icons.woman, color: Colors.black87,)),
                        ],
                      ),
                    ),
                    PhrBar(AppLocalizations.of(context)!.translate('phr_page_medicalProfile_title')),
                    Container(
                      child: Column(
                        children: <Widget>[
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_Doctor'), _medicalProfile.medecin_traitant, Icon(Icons.medical_services, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_Blood'), _medicalProfile.groupe_sanguin, Icon(Icons.bloodtype, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_Pre_pregnancyWeight'), _medicalProfile.poids_av_gross, Icon(Icons.monitor_weight, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_ExpectedDateOfBirth'), _medicalProfile.date_prevue_accouchement, Icon(Icons.pregnant_woman_rounded, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_Children'), _medicalProfile.nbr_enfant, Icon(Icons.child_friendly_rounded, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_previousPregnancies'), _medicalProfile.nbr_grossesse_prece, Icon(Icons.local_hospital, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_Chronic'), _medicalProfile.maladies_chroniques, Icon(Icons.location_history_rounded, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_Genetic'), _medicalProfile.maladies_genetiques, Icon(Icons.location_history_rounded, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_Contraceptive'), _medicalProfile.methode_contraception_utilise, Icon(Icons.medication, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_Surgical'), _medicalProfile.antecedents_chirurgicaux, Icon(Icons.location_history_rounded, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_Gynecological'), _medicalProfile.antecedents_gynecologiques, Icon(Icons.location_history_rounded, color: Colors.black87,)),
                          Divider(),
                          PhrListTile(AppLocalizations.of(context)!.translate('phr_page_field_Obstetrical'), _medicalProfile.antecedents_obstetricaux, Icon(Icons.location_history_rounded, color: Colors.black87,)),
                        ],
                      ),
                    ),
                  ],
                ) :  Center(child: CircularProgressIndicator()),
    );
            }

  @override
  void dispose() {
    //_connectivity.disposeStream();
    super.dispose();
  }
  }
