// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sky_auth/components/background.dart';
import 'package:sky_auth/components/loginButton.dart';
import 'package:sky_auth/constants.dart';
import 'package:http/http.dart' as http;

import 'dart:collection';
import 'dart:convert';

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Background(Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'SIGNUP',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                autofocus: false,
                controller: _firstname,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.person,
                      color: kPrimary,
                    ),
                    hintText: "Firstname"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                autofocus: false,
                controller: _lastname,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.person,
                      color: kPrimary,
                    ),
                    hintText: "Lastname"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                autofocus: false,
                controller: _username,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.person,
                      color: kPrimary,
                    ),
                    hintText: "Username"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                autofocus: false,
                controller: _nationalID,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.add_card_sharp,
                      color: kPrimary,
                    ),
                    hintText: "National ID "),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                autofocus: false,
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: const Icon(
                    Icons.lock,
                    color: kPrimary,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () {},
                  ),
                  hintText: "Password",
                ),
              ),
            ),
            LoginButton(
              child: const Text(
                'Signup',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                String fName = _firstname.text;
                String lName = _lastname.text;
                String uName = _username.text;
                var natID = _nationalID.text;
                String pass = _password.text;
                signUp(fName, lName, uName, natID, pass, context);
                Navigator.pushReplacementNamed(context, '/signup');
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Already have an account ? ',
                  style: TextStyle(fontSize: 18),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/login');
                  },
                  child: const Text(
                    'Login ',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kPrimary),
                  ),
                ),
              ],
            )
          ],
        )),
      ),
    );
  }
}

void signUp(String fName, String lName, String uName, String natID, String pass,
    context) async {
  Map<String, dynamic> userSignupDetails = {
    'first_name': fName,
    'last_name': lName,
    'username': uName,
    'national_id': int.parse(natID),
    'password': pass,
    'user_type': 'MEMBER',
  };

  try {
    var response = await http.post(
        Uri.parse("http://10.0.2.2:8081/sky-auth/users"),
        body: json.encode(userSignupDetails));

    // var response = await http.post(
    //     Uri.parse("http://85.159.214.103:8081/sky-auth/users"),
    //     body: jsonEncode(userSignupDetails));

    LinkedHashMap<String, dynamic> responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/homePage');
      const snackBar = SnackBar(
        content: Text(
          'SIGN UP SUCCESSFUL',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 75, 181, 67),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      //print(responseBody);
      var snackBar = SnackBar(
        content: Text(
          responseBody.values.first,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 148, 148),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } catch (exception) {
    print('Exception : ' + exception.toString());
  }
}
