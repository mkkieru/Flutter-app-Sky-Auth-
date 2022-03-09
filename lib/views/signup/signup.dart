import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sky_auth/components/background.dart';
import 'package:sky_auth/components/loginButton.dart';
import 'package:sky_auth/constants.dart';

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

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
            SvgPicture.asset(
              "assets/icons/signup.svg",
              width: size.width * 0.5,
              height: size.height * 0.3,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(30)),
              child: const TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.person,
                      color: kPrimary,
                    ),
                    hintText: "Enter Username"),
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
                    hintText: "Enter Password"),
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
                    hintText: "Confirm Password"),
              ),
            ),
            LoginButton(
              child: const Text(
                'Signup',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {var snackBar = const SnackBar(
                content: Text(
                  'Off to Login',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: kPrimaryLightColor,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                    var snackBar = const SnackBar(
                      content: Text(
                        'Off to Login',
                        style: TextStyle(color: Colors.black),
                      ),
                      backgroundColor: kPrimaryLightColor,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
