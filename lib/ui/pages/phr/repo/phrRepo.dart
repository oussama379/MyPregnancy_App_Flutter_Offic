import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ma_grossesse/ui/pages/phr/model/phrPresonalProfile.dart';

import '../model/phrMedicalProfile.dart';


class PhrDao {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // final User? user = _auth.currentUser;
  // final uid = user?.uid;

  MedicalProfile getMedicalProfile(){
    DatabaseReference _patientsRefMedicalProfile = FirebaseDatabase.instance.reference().child('Patientes').child('223W4blkvCQ1aaoCFDD0BMPC2TJ3').child('profil').child('medical');
    var medicalProfile ;
    _patientsRefMedicalProfile.onValue.listen((event) {
      final data = event.snapshot.value;
      //print(data);
      medicalProfile = MedicalProfile.fromJson(data);
      //print(medicalProfile.toString());
      //if(medicalProfile == null) print('Yes');
      //else print('No');
    });
    return medicalProfile;
  }

  Future<PersonalProfile> getPersonalProfile() async {
    DatabaseReference _patientsRefPersonalProfile = FirebaseDatabase.instance.reference().child('Patientes').child('223W4blkvCQ1aaoCFDD0BMPC2TJ3').child('profil').child('personel');
    var personalProfile ;
    _patientsRefPersonalProfile.onValue.listen((event) {
      final data = event.snapshot.value;
      //print(data);
      personalProfile = PersonalProfile.fromJson(data);
      //if(personalProfile == null) print('Yes');
      //else print('No');
      //print(personalProfile.toString());
    });
    return personalProfile;
  }


  PhrDao();

}







