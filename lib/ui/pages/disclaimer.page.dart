import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';

import '../../app_localizations.dart';

class DisclaimerPage extends StatelessWidget {
  DisclaimerPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        title: Text('Disclaimer'),
    ),
    body: Accordion(
      maxOpenSections: 2,
      children: [
        AccordionSection(
          isOpen: true,
          header: Text(AppLocalizations.of(context)!.translate('disclaimer_page_section1_title'), style: TextStyle(color: Colors.white, fontSize: 17)),
          content: Text(AppLocalizations.of(context)!.translate('disclaimer_page_section1_text')),
          leftIcon: Icon(Icons.accessibility_sharp, color: Colors.white),
        ),

    AccordionSection(
          header: Text(AppLocalizations.of(context)!.translate('disclaimer_page_section2_title'), style: TextStyle(color: Colors.white, fontSize: 17)),
          content: Text(AppLocalizations.of(context)!.translate('disclaimer_page_section2_text')),
      leftIcon: Icon(Icons.medical_services, color: Colors.white),
    ),
        AccordionSection(
          header: Text(AppLocalizations.of(context)!.translate('disclaimer_page_section3_title'), style: TextStyle(color: Colors.white, fontSize: 17)),
          content: Text(AppLocalizations.of(context)!.translate('disclaimer_page_section3_text')),
          leftIcon: Icon(Icons.help_outlined, color: Colors.white),
        ),
    AccordionSection(
          header: Text(AppLocalizations.of(context)!.translate('disclaimer_page_section4_title'), style: TextStyle(color: Colors.white, fontSize: 17)),
          content: Text(AppLocalizations.of(context)!.translate('disclaimer_page_section4_text')),
          leftIcon: Icon(Icons.warning, color: Colors.white),
        ),
        AccordionSection(
          header: Text(AppLocalizations.of(context)!.translate('disclaimer_page_section5_title'), style: TextStyle(color: Colors.white, fontSize: 17)),
          content: Text(AppLocalizations.of(context)!.translate('disclaimer_page_section5_text')),
          leftIcon: Icon(Icons.label_important_outlined, color: Colors.white),
        ),

      ],
    ));
  }

}