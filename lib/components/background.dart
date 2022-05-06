// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class Background extends StatelessWidget {

  Widget child ;

  Background (this.child, {Key? key}) : super(key: key);
  //Background ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Get total height and width of the user screen
    Size size = MediaQuery.of(context).size;
    // ignore: sized_box_for_whitespace
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/top1.png',
              //width: size.width * 1,
            ),
          ),
          Positioned(
            top: 0,
            child: Image.asset(
              'assets/images/top2.png',
              //width: size.width * 1,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Image.asset(
              'assets/images/bottom1.png',
              //width: size.width * 1,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Image.asset(
              'assets/images/bottom2.png',
              //width: size.width * 1,
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   child: Image.asset(
          //     'assets/images/main_bottom.png',
          //     width: size.width * 0.3,
          //   ),
          // ),
          SingleChildScrollView(child: child),
          //child,
        ],
      ),
    );
  }
}
