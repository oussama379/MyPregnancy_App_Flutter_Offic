import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:ff_navigation_bar/ff_navigation_bar_item.dart';
import 'package:flutter/material.dart';

import '../../../../app_localizations.dart';
import '../../../../locator.dart';
import '../../../../preferencesService.dart';

class HomeBottomBar extends StatefulWidget {

  @override
  State<HomeBottomBar> createState() => _HomeBottomBarState();
}

class _HomeBottomBarState extends State<HomeBottomBar> {
  final _preferencesService = locator.get<PreferencesService>();
  int selectedIndex = 0;
  @override



  Widget build(BuildContext context) {
    return FFNavigationBar(
      theme: FFNavigationBarTheme(
        //itemWidth: 40.0,
        barBackgroundColor: Colors.white,
        selectedItemBorderColor: Colors.pink,
        selectedItemBackgroundColor: Colors.pinkAccent,
        selectedItemIconColor: Colors.white,
        selectedItemLabelColor: Colors.pink,
      ),
      selectedIndex: selectedIndex,
      onSelectTab: (index) {
        setState(() {
          selectedIndex = index;
          print(index);
          if(index == 3){
            Navigator.pushNamed(context, '/measurements');
          }
          if(index == 0 ){
            //TODO To be removed
            _preferencesService.deleteDPA();
            _preferencesService.deleteLastPeriodDate();
          }
        });
      },
      items: [
        FFNavigationBarItem(
          iconData: Icons.home,
          label: AppLocalizations.of(context)!.translate('home_page_Navig_Btn_0'),
          selectedBackgroundColor: Colors.pinkAccent,
          selectedForegroundColor: Colors.white,
        ),
        FFNavigationBarItem(
          iconData: Icons.calendar_today,
          label: AppLocalizations.of(context)!.translate('home_page_Navig_Btn_1'),
          selectedBackgroundColor: Colors.pinkAccent,
          selectedForegroundColor: Colors.white,
        ),
        FFNavigationBarItem(
          iconData: Icons.timer,
          label: AppLocalizations.of(context)!.translate('home_page_Navig_Btn_2'),
        ),
        FFNavigationBarItem(
          iconData: Icons.monitor_weight,
          label: AppLocalizations.of(context)!.translate('home_page_Navig_Btn_3'),
        ),
      ],
    );
  }
}
