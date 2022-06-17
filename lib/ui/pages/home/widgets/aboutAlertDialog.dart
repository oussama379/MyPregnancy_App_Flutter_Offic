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
        titlePadding:  EdgeInsets.only(top: 10,bottom: 5, left: 20, right: 20),
        contentPadding: EdgeInsets.all(10.0),
        title : Text(AppLocalizations.of(context)!.translate('home_page_drawer_aboutUs')),
        content :  Container(
          width: 200,
          height: 270,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/images/USAID-logo.png',
                      width: 80, height: 80),
                  SizedBox(
                    height: 10,
                  ),
                  SideText(AppLocalizations.of(context)!
                      .translate('intro_acknowledgment')),
                ],
              ),
            )),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.translate('home_page_LPD_alert_conf')),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

}