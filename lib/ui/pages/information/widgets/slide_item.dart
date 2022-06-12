import 'package:flutter/material.dart';

import '../model/slide.dart';

class SlideItem extends StatelessWidget {
  //final Month month;
  final String image;
  final String title;
  final String desc;

  SlideItem(this.image, this.title, this.desc);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(this.image),
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              this.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight:FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            this.desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight:FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          // SizedBox(
          //   height: 20,
          // ),
        ],
      ),
    );
  }
}
