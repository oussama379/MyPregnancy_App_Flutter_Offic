import 'package:flutter/material.dart';

class ButtonKeys extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.redAccent),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Booked',
                  style: TextStyle(
                    color: Color(0xff363636),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Row(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.lightGreenAccent),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Available',
                  style: TextStyle(
                    color: Color(0xff363636),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
