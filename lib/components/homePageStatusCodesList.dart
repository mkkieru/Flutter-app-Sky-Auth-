// ignore_for_file: unused_import, file_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            if(authCodes[index]["isnew"] == 'YES'){
              return StatusCodeWidget
                (
                progName,
                authCodes[index]["time_remaining"],
                authCodes[index]["time_to_live"],
                authCodes[index]["auth_code"],
                authCodes[index]["identifier"],
              );
            }
            return StatusCodeWidget(
              progName,
              authCodes[index]["time_to_live"] -
                  authCodes[index]["age"]["wholeSeconds"],
              authCodes[index]["time_to_live"],
              authCodes[index]["auth_code"],
                authCodes[index]["identifier"],
            );
          } catch (e) {
            return Container(
              height: size.height - size.height * 0.3,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    "assets/icons/missing.svg",
                    height: size.height * 0.30,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    alignment: Alignment.center,
                    width: size.width ,
                    child: const Text(
                      "NO CODES FOUND",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF2661FA),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    ]);
  }
}
