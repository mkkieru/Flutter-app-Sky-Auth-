// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_auth/components/background.dart';
import 'package:sky_auth/constants.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import 'dart:collection';
import 'dart:convert';

import '../../API/ApiFunctions.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _nationalID = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Background(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "SIGNUP",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF2661FA),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: _firstname,
                    decoration: const InputDecoration(
                      labelText: 'Firstname',
                      labelStyle: TextStyle(fontSize: 16),
                      //border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: _lastname,
                    decoration: const InputDecoration(
                      labelText: "Lastname",
                      labelStyle: TextStyle(fontSize: 16),
                      //border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: _username,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      labelStyle: TextStyle(fontSize: 16),
                      //border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: _nationalID,
                    decoration: const InputDecoration(
                      labelText: "National ID",
                      labelStyle: TextStyle(fontSize: 16),
                      //border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: _password,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(fontSize: 16),
                      //border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: RaisedButton(
                      onPressed: () async {
                        String fName = _firstname.text;
                        String lName = _lastname.text;
                        String uName = _username.text;
                        var natID = _nationalID.text;
                        String pass = _password.text;
                        context.loaderOverlay.show();
                        await signUp(fName, lName, uName, natID, pass, context);
                        context.loaderOverlay.hide();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            gradient: const LinearGradient(colors: [
                              // Color.fromARGB(255, 255, 136, 34),
                              // Color.fromARGB(255, 255, 177, 41),
                              Color.fromARGB(255, 34, 71, 255),
                              Color.fromARGB(255, 120, 124, 173),
                            ])),
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
                    )),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.popAndPushNamed(context, '/login');
                    },
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0XFF2661FA),
                      ),
                    ),
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


