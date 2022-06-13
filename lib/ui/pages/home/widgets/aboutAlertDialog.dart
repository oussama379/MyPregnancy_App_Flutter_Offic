import 'package:flutter/material.dart';
import 'package:ma_grossesse/ui/pages/home/widgets/sideText.home.dart';

import '../../../../app_localizations.dart';


class AboutAlertDialog extends StatefulWidget {
  @override
  MyAlertDialogState createState() => MyAlertDialogState();
}
class MyAlertDialogState extends State<AboutAlertDialog> {

  Widget build(BuildContext context) {
    return AlertDialog(
        titlePadding:  EdgeInsets.only(top: 10,bottom: 10.0, left: 20),
        contentPadding: EdgeInsets.all(10.0),
        title : Text('About app'),
        content :  Container(
          width: 200,
          height: 270,
            child: Column(
              children: [
                Image.asset('assets/images/USAID-logo.png',
                    width: 90, height: 90),
                SizedBox(
                  height: 10,
                ),
                SideText(AppLocalizations.of(context)!
                    .translate('intro_acknowledgment')),
              ],
            )),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

}