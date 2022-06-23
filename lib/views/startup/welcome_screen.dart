// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sky_auth/components/background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_auth/constants.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../../API/ApiFunctions.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final ThemeData mode = Theme.of(context);
    var whichMode = mode.brightness;
    Color COLOR = kPrimary;
    if (whichMode == Brightness.dark) {
      COLOR = kPrimaryLightColor;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Background(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                alignment: Alignment.center,
                child: Text(
                  "SKY AUTH",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: COLOR,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/Sky-World-Logo-no-bg.png',
                width: size.width * 0.9,
                height: size.height * 0.55,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                width: size.width * 0.9,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: kPrimary,
                ),
                child: FlatButton(
                  onPressed: () async {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
                width: size.width * 0.9,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: kPrimaryLightColor,
                ),
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkLoginState(context);
  }

  void checkLoginState(var context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final ip_addressLogin = prefs.getString("ip_address");
    final access_token = prefs.getString("access_token");

    if (ip_addressLogin != null && access_token != null) {
      String? UserId = prefs.getString("user_id");
      USERNAME = prefs.getString("username");
      INITIALS = "${USERNAME[0]}${USERNAME[1]}";
      final userId;
      try {
        userId = int.parse(UserId!);
      } catch (e) {
        return;
      }

      confirmAccessTokenIsValid(userId, ip_addressLogin, access_token);
    }
  }

  confirmAccessTokenIsValid(
      var userId, var ip_addressLogin, var access_token) async {
    var body = {"user_id": userId, "ip_address": ip_addressLogin};
    var response = await http.post(
      Uri.parse("http://$ipAddress:8081/sky-auth/users/checkAccessToken"),
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      context.loaderOverlay.show();
      ACCESSTOKEN = access_token;
      USERID = userId;
      try {
        await getIdentifierAndTypes();
        await getPrograms();
        await getAllStatusCodes();
        if (mounted) {
          Navigator.of(context).pushReplacementNamed("/homePage");
          context.loaderOverlay.hide();
        }
      } catch (e) {
        Navigator.of(context).pushReplacementNamed("/login");
        context.loaderOverlay.hide();
      }
    }
  }
}
