// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:sky_auth/components/background.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sky_auth/components/loginButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_auth/constants.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // SchedulerBinding.instance
    //     ?.addPostFrameCallback((_) => checkLoginState(context));

    return Scaffold(
      body: SingleChildScrollView(
        child: Background(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Sky Authenticator',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SvgPicture.asset(
                "assets/icons/chat.svg",
                height: size.height * 0.55,
              ),
              const SizedBox(
                height: 10,
              ),
              LoginButton(
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () async {
                    Navigator.pushReplacementNamed(context, '/login');
                  }),
              Container(
                width: size.width * 0.7,
                padding: const EdgeInsets.all(5),
                //padding: const EdgeInsets.symmetric(vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: FlatButton(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    color: kPrimaryLightColor,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: const Text(
                      'Signup',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
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
    checkLoginState(context);
  }

  void checkLoginState(var context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final ip_address = prefs.getString("ip_address");
    final access_token = prefs.getString("access_token");

    if (ip_address != null && access_token != null) {
      String? UserId = prefs.getString("user_id");
      final userId = int.parse(UserId!);

      confirmAccessTokenIsValid(userId, ip_address, access_token);
    }
  }

  confirmAccessTokenIsValid(var userId, var ipAddress, var access_token) async {
    var body = {"user_id": userId, "ip_address": ipAddress};
    var response = await http.post(
      Uri.parse("http://85.159.214.103:8081/sky-auth/users/checkAccessToken"),
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      ACCESSTOKEN = access_token;
      USERID = userId;
      await getIdentifierAndTypes();
      await getPrograms();
      await getStatusCodes();
      Navigator.of(context).pushReplacementNamed("/homePage");
    }
  }

  Future<int> getIdentifierAndTypes() async {
    var responseIdentifiers = await http.get(
        Uri.parse("http://85.159.214.103:8081/sky-auth/identifier"),
        headers: {"access_token": ACCESSTOKEN});
    var responseIdentifierTypes = await http.get(
        Uri.parse('http://85.159.214.103:8081/sky-auth/identifier_type'),
        headers: {"access_token": ACCESSTOKEN});

    if (responseIdentifiers.statusCode == 200 ||
        responseIdentifierTypes.statusCode == 200) {
      var identifiersFromDB = jsonDecode(responseIdentifiers.body);
      var identifierTypesFromDB = jsonDecode(responseIdentifierTypes.body);

      constantIdentifiers.clear();
      constantIdentifierTypes.clear();

      try {
        if (identifiersFromDB["Message"]) {}
      } catch (exception) {
        for (int i = 0; i < identifiersFromDB.length; i++) {
          constantIdentifiers.add(identifiersFromDB[i]);
        }
      }

      for (int i = 0; i < identifierTypesFromDB.length; i++) {
        constantIdentifierTypes.add(identifierTypesFromDB[i]);
      }
      try {
        individualIdentifier = constantIdentifiers[0]["identifier"];
      } catch (e) {}
    }
    return 1;
  }

  Future<int> getPrograms() async {
    var programsFromDB;

    var response = await http.get(
      Uri.parse("http://85.159.214.103:8081/sky-auth/programs"),
      headers: {"access_token": ACCESSTOKEN},
    );

    programsFromDB = jsonDecode(response.body);
    programs = programsFromDB;
    return 1;
  }

  Future<int> getStatusCodes() async {
    var response = await http.get(
      Uri.parse("http://85.159.214.103:8081/sky-auth/auth_details?user_id=" +
          USERID.toString() +
          "&identifier=" +
          individualIdentifier),
      headers: {"access_token": ACCESSTOKEN},
    );
    if (response.statusCode == 200) {
      try {
        authCodes = jsonDecode(response.body);
      } catch (e) {
        authCodes = [jsonDecode(response.body)];
      }
    }
    return 1;
  }
}
