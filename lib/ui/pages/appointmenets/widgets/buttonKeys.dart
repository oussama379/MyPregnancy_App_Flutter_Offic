import 'package:flutter/material.dart';

class ButtonKeys extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0,left: 30.0,top: 8.0,bottom: 8.0,),
      child: Container(
        //alignment: ,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
                  'reserved',
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
            SizedBox(
              width: 20,
            ),
            // Row(
            //   //crossAxisAlignment: CrossAxisAlignment.stretch,
            //   children: [
            //     Container(
            //       width: 13,
            //       height: 13,
            //       decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           color: Colors.orange),
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     Text(
            //       'Selected',
            //       style: TextStyle(
            //         color: Color(0xff363636),
            //         fontSize: 15,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
