// ignore_for_file: unused_import, file_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sky_auth/components/background.dart';
import 'package:sky_auth/components/statusCodesWidget.dart';
import 'package:sky_auth/constants.dart';
import 'package:http/http.dart' as http;

class HomepageStatusCodesList extends StatefulWidget {
  const HomepageStatusCodesList({Key? key}) : super(key: key);

  @override
  State<HomepageStatusCodesList> createState() => _HomepageStatusCodesList();
}

class _HomepageStatusCodesList extends State<HomepageStatusCodesList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(children: [
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
        itemCount: authCodes.length,
        itemBuilder: (BuildContext context, int index) {
          String progName = "";

          try {
            // ignore: unused_local_variable
            String test = authCodes[index]["auth_code"];
            for (int i = 0; i < programs.length; i++) {
              if (programs[i]["program_id"] == authCodes[index]["program_id"]) {
                progName = programs[i]["program_name"];
              }
            }
            // ignore: sized_box_for_whitespace
            return StatusCodeWidget(
              progName,
              authCodes[index]["time_to_live"] -
                  authCodes[index]["age"]["wholeSeconds"],
              authCodes[index]["auth_code"],
            );
          } catch (e) {
            return const Card(
              child: ListTile(
                title: Text(
                  "No status codes found",
                  style: TextStyle(
                    fontSize: 30,
                    color: kPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            );
          }
        },
      ),
    ]);
  }
}
