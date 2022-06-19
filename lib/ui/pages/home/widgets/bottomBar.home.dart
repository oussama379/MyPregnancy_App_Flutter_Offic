// import 'package:ff_navigation_bar/ff_navigation_bar.dart';
// import 'package:ff_navigation_bar/ff_navigation_bar_item.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../app_localizations.dart';
// import '../../../../locator.dart';
// import '../../../../preferencesService.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../weightMeasurments/weightRepo.dart';
//
// class HomeBottomBar extends StatefulWidget {
//
//   @override
//   State<HomeBottomBar> createState() => _HomeBottomBarState();
// }
//
// class _HomeBottomBarState extends State<HomeBottomBar> {
//   final _preferencesService = locator.get<PreferencesService>();
//   int? selectedIndex = null;
//   //TODO to be removed (test)
//   final _weightRepo = locator.get<WeightRepo>();
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context);
//     return FFNavigationBar(
//       theme: FFNavigationBarTheme(
//         barBackgroundColor: Colors.white,
//         selectedItemBorderColor: Colors.pink,
//         selectedItemBackgroundColor: Colors.pinkAccent,
//         selectedItemIconColor: Colors.white,
//         selectedItemLabelColor: Colors.pink,
//       ),
//       selectedIndex: selectedIndex,
//       onSelectTab: (index) {
//         setState(() {
//           selectedIndex = index;
//           print(index);
//           if(index == 2){
//             selectedIndex = null;
//             Navigator.pushNamed(context, '/measurements');
//           }
//           if(index == 0 ){
//             //TODO To be removed
//             // _preferencesService.deleteDPA();
//             // _preferencesService.deleteLastPeriodDate();
//           }
//         });
//       },
//       items: [
//         // FFNavigationBarItem(
//         //   iconData: Icons.home,
//         //   label: AppLocalizations.of(context)!.translate('home_page_Navig_Btn_0'),
//         //   selectedBackgroundColor: Colors.pinkAccent,
//         //   selectedForegroundColor: Colors.white,
//         // ),
//         FFNavigationBarItem(
//           itemWidth: 60.w,
//           iconData: Icons.calendar_today,
//           label: AppLocalizations.of(context)!.translate('home_page_Navig_Btn_1'),
//           selectedBackgroundColor: Colors.pinkAccent,
//           selectedForegroundColor: Colors.white,
//         ),
//         FFNavigationBarItem(
//           itemWidth: 60.w,
//           iconData: Icons.timer,
//           label: AppLocalizations.of(context)!.translate('home_page_Navig_Btn_2'),
//         ),
//         FFNavigationBarItem(
//           itemWidth: 60.w,
//           iconData: Icons.monitor_weight,
//           label: AppLocalizations.of(context)!.translate('home_page_Navig_Btn_3'),
//         ),
//       ],
//     );
//   }
// }
