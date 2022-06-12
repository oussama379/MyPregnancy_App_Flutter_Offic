import 'package:fluttertoast/fluttertoast.dart';

class toastMsg {

  toastMsg();

void showMsg(String Msg) => Fluttertoast.showToast(
    msg: Msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    //backgroundColor: Colors.red,
    //textColor: Colors.white,
    fontSize: 14.0
);


}


