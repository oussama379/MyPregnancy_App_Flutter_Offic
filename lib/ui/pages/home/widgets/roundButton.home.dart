import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RoundButton extends StatelessWidget {
  final String buttonText;
  final Icon icon;
  final Color color;
  final VoidCallback? onTap;
  //onPressed
  const RoundButton({required this.buttonText, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SizedBox.fromSize(
      size: Size(30, 30), // button width and height
      child: ClipOval(
        child: Material(
          color: color, // button color
          child: InkWell(
            splashColor: Colors.pink[100], // splash color
            onTap: onTap, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon, // icon
                Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                  //   style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
                ), // text
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
