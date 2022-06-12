import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ma_grossesse/ui/pages/information/repo/monthRepo.dart';

import '../../locator.dart';
import 'information/model/slide.dart';
import 'information/widgets/slide_dots.dart';
import 'information/widgets/slide_item.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';




class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final _monthRepo = locator.get<MonthDao>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Information'),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    // FirebaseAnimatedList(
                    //   controller: _pageController,
                    //   query: _monthRepo.getMonthQuery(),
                    //   scrollDirection: Axis.vertical,
                    //   itemBuilder: (context, snapshot, animation, index) {
                    //     final json = snapshot.value as Map<dynamic, dynamic>;
                    //     final message = Month.fromJson(json);
                    //     return SlideItem(message);
                    //   },
                    // ),
                    // PageView.builder(
                    //   scrollDirection: Axis.horizontal,
                    //   controller: _pageController,
                    //   onPageChanged: _onPageChanged,
                    //   itemCount: monthList.length,
                    //   itemBuilder: (ctx, i) => SlideItem(i),
                    // ),
                    // Stack(
                    //   alignment: AlignmentDirectional.topStart,
                    //   children: <Widget>[
                    //     Container(
                    //       margin: const EdgeInsets.only(bottom: 5),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: <Widget>[
                    //           for(int i = 0; i<monthList.length; i++)
                    //             if( i == _currentPage )
                    //               SlideDots(true)
                    //             else
                    //               SlideDots(false)
                    //         ],
                    //       ),
                    //     )
                    //   ],
                    // )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}