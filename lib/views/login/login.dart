// ignore_for_file: non_constant_identifier_names, duplicate_ignore
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sky_auth/components/background.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sky_auth/constants.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import 'dart:collection';
import 'dart:convert';

import '../../API/ApiFunctions.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final ValueNotifier<bool> _visibility = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          // ignore: sized_box_for_whitespace
          child: Container(
            height: size.height,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Background(
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        //alignment: Alignment.center,
                        width: size.width * 0.9,
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: size.width * 0.9,
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: TextField(
                          controller: _username,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            labelStyle: TextStyle(fontSize: 16),
                            //border: InputBorder.none,
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _visibility,
                        builder: (context, takenSurvey, child) {
                          if (_visibility.value == false) {
                            return Container(
                              alignment: Alignment.center,
                              height: 50,
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              width: size.width * 0.9,
                              child: TextField(
                                controller: _password,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Password",
                                  labelStyle: const TextStyle(fontSize: 16),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      _visibility.value = true;
                                    },
                                    icon: const Icon(Icons.visibility),
                                  ),
                                  //border: InputBorder.none,
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              alignment: Alignment.center,
                              height: 50,
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              width: size.width * 0.9,
                              child: TextField(
                                controller: _password,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Password",
                                  labelStyle: const TextStyle(fontSize: 16),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      _visibility.value = false;
                                    },
                                    icon: const Icon(
                                        Icons.visibility_off_rounded),
                                  ),
                                  //border: InputBorder.none,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 5,
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
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.loaderOverlay.show();
                            var username = _username.text;
                            var password = _password.text;
                            context.loaderOverlay.show();
                            var result = await LoginToApp(username, password, context);
                            context.loaderOverlay.hide();

                            if(result == "OK") {
                              Navigator.pushReplacementNamed(
                                  context, '/homePage');
                            }
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
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.popAndPushNamed(context, '/signup');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Don't have an account?  ",
                              ),
                              Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryLightColor,
                                  //fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
