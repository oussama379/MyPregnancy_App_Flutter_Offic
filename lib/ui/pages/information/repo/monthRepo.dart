import 'package:firebase_database/firebase_database.dart';


class MonthDao {


  final Query _monthsRefFrench =
  FirebaseDatabase.instance.reference().child('Data1').orderByChild('title');
  final Query _monthsRefEnglish =
  FirebaseDatabase.instance.reference().child('Data2').orderByChild('title');
  final Query _monthsRefArab =
  FirebaseDatabase.instance.reference().child('Data3').orderByChild('title');

  Query getMonthQueryFrench() {
    return _monthsRefFrench;
  }
  Query getMonthQueryEnglish() {
    return _monthsRefEnglish;
  }
  Query getMonthQueryArab() {
    return _monthsRefArab;
  }


  MonthDao();

}
