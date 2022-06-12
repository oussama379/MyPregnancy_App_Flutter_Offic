import 'package:flutter/material.dart';

class PhrListTile extends StatelessWidget {
  final String title;
  final String value;
  final Icon icon;

  PhrListTile(this.title, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: icon,
      title:
      Text(
        title,
        style: TextStyle(
          color: Colors.pinkAccent,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        value != null ? value : '',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
