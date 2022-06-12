import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final text;
  final IconData icon;
  final VoidCallback? onTap;


  ListItem({required this.text, required this.icon , required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,// Handle your callback
      child: Container(
        height: 50,
        //color: Colors.amber[500],
        child: Row(
          mainAxisAlignment : MainAxisAlignment.center,
          children: [
            Icon( // <-- Icon
              icon,
              size: 30.0,
            ),
            SizedBox(
              width: 10,
            ),
            Text(text, style: TextStyle(color: Colors.black, fontSize: 17)),
          ],
        ),
      ),
    );
  }

}
