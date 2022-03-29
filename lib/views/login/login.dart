// ignore_for_file: non_constant_identifier_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_auth/components/loginButton.dart';
import 'package:sky_auth/constants.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import 'dart:collection';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        // ignore: sized_box_for_whitespace
        child: Container(
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "assets/images/main_top.png",
                  width: size.width * 0.4,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/login_bottom.png",
                  width: size.width * 0.5,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "LOGIN",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SvgPicture.asset(
                    "assets/icons/login.svg",
                    height: size.height * 0.35,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(29)),
                    child: TextField(
                      controller: _username,
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: kPrimary,
                        ),
                        hintText: 'Your Username',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(29)),
                    child: TextField(
                      controller: _password,
                      onChanged: (value) {},
                      obscureText: true,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          color: kPrimary,
                        ),
                        suffixIcon: Icon(Icons.visibility, color: kPrimary),
                        hintText: 'Password',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  LoginButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () {
                      var username = _username.text;
                      var password = _password.text;
                      LoginToApp(username, password, context);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Don't have an account ? ",
                        style: TextStyle(fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.popAndPushNamed(context, '/signup');
                        },
                        child: const Text(
                          "Signup ",
                          style: TextStyle(
                            fontSize: 15,
                            color: kPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void LoginToApp(var name, var pass, var context) async {
    String password = pass;
    String username = name;

    var bytes = utf8.encode(password);
    var usernameBytes = utf8.encode(username);

    var hashedPasswordString = sha256.convert(bytes).toString();
    var hashedPasswordBytes = utf8.encode(hashedPasswordString);

    var auth = sha256.convert(usernameBytes + hashedPasswordBytes).toString();

    Map<String, String> headerValues = {
      'auth': auth,
    };

    print("Before db query ... ");

    final response = await http.post(
      Uri.parse(
          'http://85.159.214.103:8081/sky-auth/authorization/login?username=' +
              username),
      headers: headerValues,
    );
    print("After db query ... ");

    if (response.statusCode == 200) {
      LinkedHashMap<String, dynamic> responseBody = jsonDecode(response.body);

      String accessToken = responseBody['access_token'];
      // ignore: non_constant_identifier_names
      int user_id = responseBody['user_id'];

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_id', responseBody['user_id'].toString());
      prefs.setString('ip_address', responseBody['ip_address']);
      prefs.setString('access_token', accessToken);

      ACCESSTOKEN = accessToken;
      USERID = user_id;

      await getIdentifierAndTypes();
      await getPrograms();
      await getStatusCodes();

      Navigator.pushReplacementNamed(context, '/homePage');

      var snackBar = const SnackBar(
        content: Text(
          'LOGIN SUCCESSFUL',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 75, 181, 67),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      var snackBar = const SnackBar(
        content: Text(
          'INVALID CREDENTIALS',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 204, 204),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // void getIdentifierAndTypes(context) async {
  //   var responseIdentifiers = await http.get(
  //       Uri.parse("http://85.159.214.103:8081/sky-auth/identifier"),
  //       headers: {"access_token": ACCESSTOKEN});
  //
  //   var responseIdentifierTypes = await http.get(
  //       Uri.parse('http://85.159.214.103:8081/sky-auth/identifier_type'),
  //       headers: {"access_token": ACCESSTOKEN});
  //
  //   if (responseIdentifiers.statusCode == 200 ||
  //       responseIdentifierTypes.statusCode == 200) {
  //     var identifiersFromDB = jsonDecode(responseIdentifiers.body);
  //     var identifierTypesFromDB = jsonDecode(responseIdentifierTypes.body);
  //
  //     constantIdentifiers.clear();
  //     constantIdentifierTypes.clear();
  //
  //     try {
  //       if (identifiersFromDB["Message"]) {}
  //     } catch (exception) {
  //       for (int i = 0; i < identifiersFromDB.length; i++) {
  //         constantIdentifiers.add(identifiersFromDB[i]);
  //       }
  //     }
  //
  //     for (int i = 0; i < identifierTypesFromDB.length; i++) {
  //       constantIdentifierTypes.add(identifierTypesFromDB[i]);
  //     }
  //     try{
  //       individualIdentifier = constantIdentifiers[0]["identifier"];
  //     }
  //     catch (e){
  //
  //     }
  //
  //     Navigator.pushReplacementNamed(context, '/homePage');
  //
  //     var snackBar = const SnackBar(
  //       content: Text(
  //         'LOGIN SUCCESSFUL',
  //         style: TextStyle(
  //           color: Colors.black,
  //           fontSize: 15,
  //           fontWeight: FontWeight.normal,
  //         ),
  //       ),
  //       backgroundColor: Color.fromARGB(255, 75, 181, 67),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     return;
  //   }
  // }
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
