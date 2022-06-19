import 'package:flutter/material.dart';

class TimeTextButton extends StatelessWidget {
  String time;
  bool isSelected;

  TimeTextButton(this.time, this.isSelected);

  Widget doctorTimingsData(String time, bool isSelected) {
    return isSelected
        ? Container(
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(5),
      ),
      //margin: EdgeInsets.only(left: 2),
      child: Container(
        //margin: EdgeInsets.only(left: 2),
          child: OutlinedButton.icon(
            // foreground
            onPressed: () {},
            icon: const Icon(
              Icons.access_time,
              color: Colors.black,
            ),
            label: Text(
              time,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          )),
    )
        : Container(
      decoration: BoxDecoration(
        color: Colors.lightGreenAccent,
        borderRadius: BorderRadius.circular(5),
      ),
      //margin: EdgeInsets.only(left: 2),
      child: Container(
        //margin: EdgeInsets.only(left: 2),
          child: OutlinedButton.icon(
            // foreground
            onPressed: () {},
            icon: const Icon(
              Icons.access_time,
              color: Colors.black,
            ),
            label: Text(
              time,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          )),
    );
  }
  @override
  Widget build(BuildContext context) {
    return doctorTimingsData(time, isSelected);
  }
}
