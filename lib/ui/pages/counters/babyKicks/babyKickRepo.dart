import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '/../../globals.dart' as globals;

class BabyKickRepo   {


  Future<void> SaveBabyKicks(Map<dynamic, dynamic> json) async {
    String key = FirebaseDatabase.instance
        .reference()
        .child('Patientes')
        .child(globals.UID.toString())
        .child("counters")
        .child("babyKicks")
        .push()
        .key;
    await FirebaseDatabase.instance
        .reference()
        .child('Patientes')
        .child(globals.UID.toString())
        .child("counters")
        .child("babyKicks")
        .child(key)
        .set(json);
  }

  final Query _babyKicksHistory = FirebaseDatabase.instance
      .reference()
      .child('Patientes')
      .child(globals.UID.toString())
      .child("counters")
      .child("babyKicks")
      .orderByChild('dateInt');

  Query getBabyKicksHistory() {
    return _babyKicksHistory;
  }

  DatabaseReference reference = FirebaseDatabase.instance
      .reference()
      .child('Patientes')
      .child(globals.UID.toString())
      .child("counters")
      .child("babyKicks");

  Future<bool> deleteBabyKicks(String key) async {
    print('key : ');
    print(key);
    reference.child(key).remove().whenComplete(() { print('Done'); return true;});
    return true;
  }
  BabyKickRepo();
}
