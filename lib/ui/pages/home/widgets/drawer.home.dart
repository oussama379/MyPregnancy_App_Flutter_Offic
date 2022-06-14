import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../app_localizations.dart';
import '../../../../locator.dart';
import '../../../../preferencesService.dart';
import 'aboutAlertDialog.dart';


class HomeDrawer extends StatefulWidget {
  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}
class _HomeDrawerState extends State<HomeDrawer> {
  final _preferencesService = locator.get<PreferencesService>();


  Future<String?> openDialog(BuildContext context) => showDialog<String>(
      context: context,
      builder: (BuildContext context) => AboutAlertDialog()
  );


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(30),
            child: Image.asset('assets/images/appIcon.png',),
            decoration: BoxDecoration(
                color: Colors.pink.shade300
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
            ),
            title: Text(AppLocalizations.of(context)!.translate('home_page_drawer_settings')),
            onTap: () {
              Navigator.pushNamed(context, '/settingsPage');
            },
          ),
          Divider(
            indent: 30,
            endIndent: 30,
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.logout_rounded,
            ),
            title: Text(AppLocalizations.of(context)!
                .translate('settings_page_logout')),
            onTap: () {
              FirebaseAuth.instance.signOut();
              _preferencesService.deleteLoggedIn();
              Navigator.pushNamedAndRemoveUntil(
                  context, "/loginPage", (_) => false);
            },
          ),
          Divider(
            indent: 30,
            endIndent: 30,
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.info,
            ),
            title: Text(AppLocalizations.of(context)!.translate('home_page_drawer_aboutUs')),
            onTap: () async {
              await openDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
