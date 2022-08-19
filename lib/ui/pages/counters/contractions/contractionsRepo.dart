import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '/../../globals.dart' as globals;

class ContractionsRepo   {


  Future<void> SaveContractions(Map<dynamic, dynamic> json) async {
    String key = FirebaseDatabase.instance
        .reference()
        .child('Patientes')
        .child(globals.UID.toString())
        .child("counters")
        .child("contractions")
        .push()
        .key;
    await FirebaseDatabase.instance
        .reference()
        .child('Patientes')
        .child(globals.UID.toString())
        .child("counters")
        .child("contractions")
        .child(key)
        .set(json);
  }

  final Query _contractionsHistory = FirebaseDatabase.instance
      .reference()
      .child('Patientes')
      .child(globals.UID.toString())
      .child("counters")
      .child("contractions")
      .orderByChild('dateInt');

  Query getContractionsHistory() {
    return _contractionsHistory;
  }

  DatabaseReference reference = FirebaseDatabase.instance
      .reference()
      .child('Patientes')
      .child(globals.UID.toString())
      .child("counters")
      .child("contractions");

  Future<bool> deleteContractions(String key) async {
    print('key : ');
    print(key);
    reference.child(key).remove().whenComplete(() { print('Done'); return true;});
    return true;
  }

  int calculateDur(String dur){
    var tab;
    int min, sec;
    tab = dur.split(":");
    min = int.parse(tab[0]);
    sec = int.parse(tab[1]);
    min = min*60;
    return min + sec;

  }

  ContractionsRepo();
}
