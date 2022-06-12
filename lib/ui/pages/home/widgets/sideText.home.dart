import 'package:flutter/material.dart';

class SideText extends StatelessWidget {
  final String text;

  const SideText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromARGB(255, 116, 111, 111),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
    );
  }

}
