// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_auth/components/background.dart';
import 'package:sky_auth/components/statusCodesWidget.dart';
import 'package:sky_auth/constants.dart';


import 'components/drawerWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Make Query to the db for active states
  Timer? timer;

  //d | user_id | program_id | auth_code | time_to_live | time_to_live_units | date_created | date_updated | status

  void runTimer() {
    Timer.periodic(const Duration(seconds: 1), (_) {
      /*setState(() {
        if(seconds == 0){
          timer?.cancel();
          seconds = seconds;
        }
        seconds = seconds - 1;
      });*/
    });
  }

  @override
  Widget build(BuildContext context) {
    runTimer();
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: kPrimary,
        elevation: 10,
        title: const Text(
          'Sky-Auth',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
            letterSpacing: 3,
          ),
        ),
      ),
      backgroundColor: kPrimaryLightColorHomePageBackground,
      body: Stack(children: [
        Background(
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/login_bottom.png',
              width: size.width * 0.6,
            ),
          ),
        ),
        ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            // ignore: sized_box_for_whitespace
            return StatusCodeWidget();
          },
        ),
      ]),
    );
  }
}

getStatusCodes() async {
  //var response = await http.get(Uri.parse(uri));
}
