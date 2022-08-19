import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../extrasWidgets/icons_counters.dart';
import 'home/widgets/roundButton.home.dart';

class CountersPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('counters_page_title')),
    ),
    body: Center(
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(100),
        shrinkWrap: true, // to get around infinite size error
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 1,
        children: <Widget>[
          RoundButton(
              buttonText: AppLocalizations.of(context)!.translate('counters_page_btn1'),
              icon: Icon(
                DBIcons.image2vector__1_,
                color: Colors.white,
                size: 45,
              ),
              color: Colors.pinkAccent,
              onTap: () {
                Navigator.pushNamed(context, '/contractionsPage');
              }),
          RoundButton(
              buttonText: AppLocalizations.of(context)!.translate('counters_page_btn2'),
              icon: Icon(DBIcons.feet, color: Colors.white,
                size: 45,),
              color:  Colors.pinkAccent,
              onTap: () {
                Navigator.pushNamed(context, '/babyKicksPage');
              }),
        ],
      ),
    )
    );
  }
}
