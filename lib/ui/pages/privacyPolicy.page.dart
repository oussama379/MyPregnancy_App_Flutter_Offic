import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';

import '../../app_localizations.dart';

class PrivacyPolicyPage extends StatelessWidget {
  PrivacyPolicyPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('privacyPolicy_page_title')),
    ),
    body: Accordion(
      maxOpenSections: 2,
      children: [
        AccordionSection(
          isOpen: true,
          header: Text(AppLocalizations.of(context)!.translate('privacyPolicy_page_section1_title'), style: TextStyle(color: Colors.white, fontSize: 17)),
          content: Text(AppLocalizations.of(context)!.translate('privacyPolicy_page_section1_text')),
          leftIcon: Icon(Icons.accessibility_sharp, color: Colors.white),
        ),


    AccordionSection(
          header: Text(AppLocalizations.of(context)!.translate('privacyPolicy_page_section2_title'), style: TextStyle(color: Colors.white, fontSize: 17)),
          content: Text(AppLocalizations.of(context)!.translate('privacyPolicy_page_section2_text')),
         leftIcon: Icon(Icons.security, color: Colors.white),
    ),

    AccordionSection(
          header: Text(AppLocalizations.of(context)!.translate('privacyPolicy_page_section3_title'), style: TextStyle(color: Colors.white, fontSize: 17)),
          content: Text(AppLocalizations.of(context)!.translate('privacyPolicy_page_section3_text')),
         leftIcon: Icon(Icons.info, color: Colors.white),
        ),
    AccordionSection(
          header: Text(AppLocalizations.of(context)!.translate('privacyPolicy_page_section4_title'), style: TextStyle(color: Colors.white, fontSize: 17)),
          content: Text(AppLocalizations.of(context)!.translate('privacyPolicy_page_section4_text')),
       leftIcon: Icon(Icons.share, color: Colors.white),
        ),
    AccordionSection(
          header: Text(AppLocalizations.of(context)!.translate('privacyPolicy_page_section5_title'), style: TextStyle(color: Colors.white, fontSize: 17)),
          content: Text(AppLocalizations.of(context)!.translate('privacyPolicy_page_section5_text')),
          leftIcon: Icon(Icons.data_usage, color: Colors.white),
        ),

        AccordionSection(
          header: Text(AppLocalizations.of(context)!.translate('privacyPolicy_page_section6_title'), style: TextStyle(color: Colors.white, fontSize: 17)),
          content: Text(AppLocalizations.of(context)!.translate('privacyPolicy_page_section6_text')),
          leftIcon: Icon(Icons.delete, color: Colors.white),
        ),
        AccordionSection(
          header: Text(AppLocalizations.of(context)!.translate('privacyPolicy_page_section7_title'), style: TextStyle(color: Colors.white, fontSize: 17)),
          content: Text(AppLocalizations.of(context)!.translate('privacyPolicy_page_section7_text')),
          leftIcon: Icon(Icons.update, color: Colors.white),
        ),
      ],
    ));
  }

}