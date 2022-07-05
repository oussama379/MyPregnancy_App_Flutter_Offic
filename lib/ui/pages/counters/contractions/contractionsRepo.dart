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
  ContractionsRepo();
}
