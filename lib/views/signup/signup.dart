// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sky_auth/components/background.dart';
import 'package:sky_auth/constants.dart';


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
          child: Background(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  //alignment: Alignment.center,
                  width: size.width * 0.9,
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: const Text(
                    "Sign Up",
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
                    controller: _firstname,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: size.width * 0.9,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: TextField(
                    controller: _lastname,
                    decoration: const InputDecoration(
                      labelText: "Last Name",
                      labelStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: size.width * 0.9,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: TextField(
                    controller: _username,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      labelStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: size.width * 0.9,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: TextField(
                    controller: _nationalID,
                    decoration: const InputDecoration(
                      labelText: "National ID",
                      labelStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(),
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
                        width: size.width * 0.9,
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: TextField(
                          controller: _password,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: const TextStyle(fontSize: 16),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _visibility.value = true;
                              },
                              icon: const Icon(Icons.visibility),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: size.width * 0.9,
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: TextField(
                          controller: _password,
                          obscureText: false,
                          decoration:  InputDecoration(
                            labelText: "Password",
                            labelStyle: const TextStyle(fontSize: 16),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _visibility.value = false;
                              },
                              icon: const Icon(Icons.visibility_off_rounded ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                Container(
                  height: 50,
                  width: size.width * 0.9,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: kPrimary,
                  ),
                  child: TextButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      String fName = _firstname.text;
                      String lName = _lastname.text;
                      String uName = _username.text;
                      var natID = _nationalID.text;
                      String pass = _password.text;
                      context.loaderOverlay.show();
                      var result = await signUp(fName, lName, uName, natID, pass, context);
                      context.loaderOverlay.hide();
                      if(result == "OK"){
                        Navigator.pushReplacementNamed(
                            context, '/homePage');
                      }
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
                            color:Colors.white,
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
                      Navigator.popAndPushNamed(context, '/login');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Already have an account?  ",

                        ),
                        Text(
                          "Log In",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kPrimaryLightColor,
                            //fontSize: 14,
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
      ),
    );
  }
}
