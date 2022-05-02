// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sky_auth/components/background.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

    return Scaffold(
      body: SingleChildScrollView(
        child: Background(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                alignment: Alignment.center,
                child: const Text(
                  "SKY AUTH",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF0D47A1),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SvgPicture.asset(
                "assets/icons/lock.svg",
                height: size.height * 0.55,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  alignment: Alignment.centerRight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: RaisedButton(
                    onPressed: () async {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),
                    ),
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      //width: size.width * 0.5,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D47A1),
                        borderRadius: BorderRadius.circular(80),
                      ),
                      padding: const EdgeInsets.all(0),
                      child: const Text(
                        "LOGIN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
              Container(
                alignment: Alignment.centerRight,
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    //width: size.width * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(80),
                    ),
                    padding: const EdgeInsets.all(0),
                    child: const Text(
                      "SIGNUP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
      await getIdentifierAndTypes();
      await getPrograms(context);
      await getStatusCodes();
      if(mounted){
        Navigator.of(context).pushReplacementNamed("/homePage");
        context.loaderOverlay.hide();
      }
    }
  }
}
