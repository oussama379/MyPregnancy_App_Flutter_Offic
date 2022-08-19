import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app_localizations.dart';
import '../../../../localeProvider.dart';

class LanguageSection extends StatefulWidget {
  const LanguageSection({Key? key}) : super(key: key);

  @override
  State<LanguageSection> createState() => _LanguageSectionState();
}

class _LanguageSectionState extends State<LanguageSection> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      // add icon, by default "3 dot" icon
        icon: Icon(Icons.language),
        itemBuilder: (context){
          return [
            PopupMenuItem<int>(
              value: 0,
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.translate('language_en')),
                  SizedBox(width: 5,),
                  Image.asset('icons/flags/png/gb-eng.png', package: 'country_icons', height: 20, width: 20),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            ),

            PopupMenuItem<int>(
              value: 1,
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.translate('language_fr')),
                  SizedBox(width: 5,),
                  Image.asset('icons/flags/png/fr.png', package: 'country_icons', height: 20, width: 20),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            ),

            PopupMenuItem<int>(
              value: 2,
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.translate('language_ar')),
                  SizedBox(width: 5,),
                  Image.asset('icons/flags/png/sa.png', package: 'country_icons', height: 20, width: 20),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            ),
          ];
        },
        onSelected:(value){
          if(value == 0){
            _changeLang('en');
          }else if(value == 1){
            _changeLang('fr');
          }else if(value == 2){
            _changeLang('ar');
          }
        }
    );
  }

  void _changeLang(String lang){
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    provider.setLocale(Locale(lang, ''));
    print('lang changed');
  }
}
