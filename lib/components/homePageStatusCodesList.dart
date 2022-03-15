import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sky_auth/components/background.dart';
import 'package:sky_auth/components/statusCodesWidget.dart';
import 'package:sky_auth/constants.dart';
import 'package:http/http.dart' as http;

class HomepageStatusCodesList extends StatefulWidget {
  const HomepageStatusCodesList({Key? key}) : super(key: key);

  @override
  State<HomepageStatusCodesList> createState() =>
      _HomepageStatusCodesListState();
}

class _HomepageStatusCodesListState extends State<HomepageStatusCodesList> {
  var authCodesOriginal = [];
  @override
  Widget build(BuildContext context) {
    getStatusCodes();
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
        itemCount: authCodesOriginal.length,
        itemBuilder: (BuildContext context, int index) {
          String progName = "";

          try {
            String test = authCodesOriginal[index]["auth_code"];
            for (int i = 0; i < programs.length; i++) {
              if (programs[i]["program_id"] ==
                  authCodesOriginal[index]["program_id"]) {
                progName = programs[i]["program_name"];
              }
            }
            // ignore: sized_box_for_whitespace
            return StatusCodeWidget(
                progName,
                authCodesOriginal[index]["time_to_live"],
                authCodesOriginal[index]["auth_code"]);
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

  getStatusCodes() async {
    print(individualIdentifier);
    var response = await http.get(
      Uri.parse("http://10.0.2.2:8081/sky-auth/auth_details?user_id=" +
          USERID.toString() +
          "&identifier=" +
          individualIdentifier),
      headers: {"access_token": ACCESSTOKEN},
    );

    if (response.statusCode == 200) {
      setState(() {
        try {
          authCodesOriginal = jsonDecode(response.body);
        } catch (e) {
          authCodesOriginal = [jsonDecode(response.body)];
        }
      });
    }
  }
}
