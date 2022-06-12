import 'package:flutter/material.dart';

class PhrBar extends StatelessWidget {
  final String title;

  PhrBar(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.pinkAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.5, 0.9],
          ),
        ),
        child: ListTile(
          title: Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
