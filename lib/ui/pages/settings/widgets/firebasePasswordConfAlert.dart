import 'package:flutter/material.dart';

import '../../../../app_localizations.dart';

class MyFirebaseDialog {

  Future<String> showMyDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) => MyFirebaseAlertDialog(),
    );
    return result;
  }

}

class MyFirebaseAlertDialog extends StatefulWidget {
  @override
  MyFirebaseAlertDialogState createState() => MyFirebaseAlertDialogState();
}
class MyFirebaseAlertDialogState extends State<MyFirebaseAlertDialog> {

  // for this example, it's safe to instantiate the controller inline
  TextEditingController oldPwd = new TextEditingController();
  bool _isVisible = false;
  @override
  void dispose() {
    // attempt to dispose controller when Widget is disposed
    super.dispose();
    try {
      oldPwd.dispose();
    } catch (e) {

    }
  }

  void submit(){
    Navigator.of(context).pop(oldPwd.text);
    oldPwd.clear();
  }

  Widget build(BuildContext context) {
    return AlertDialog(
        titlePadding:  EdgeInsets.only(top: 10,bottom: 20.0, left: 20),
        contentPadding: EdgeInsets.all(10.0),
        title : Text(AppLocalizations.of(context)!.translate('settings_page_popUp_dialog_firebasePwd'),style: TextStyle(fontSize: 17),),
        content : TextField(
          autofocus: true,
          controller: oldPwd,
          obscureText: !_isVisible,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  print('yes');
                  setState(() {
                    _isVisible = !_isVisible;
                  });
                },
                icon: _isVisible
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
          onSubmitted: (_) => submit(),
        ),
        actions : [
          TextButton(
              onPressed: submit, child: Text(AppLocalizations.of(context)!.translate('settings_page_popUp_dialog_btn_submit'),style: TextStyle(fontSize: 18))
          ),
        ]
    );
  }

}