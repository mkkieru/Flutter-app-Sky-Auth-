import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sky_auth/components/loginButton.dart';
import 'package:sky_auth/constants.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
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
                      onChanged: (value) => print(value),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: kPrimary,
                        ),
                        hintText: 'Your Email',
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
                      onChanged: (value) => print(value),
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
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const Login())),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Don\'t have an account ? ",
                        style: TextStyle(fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () {
                          var snackBar = const SnackBar(
                            content: Icon(Icons.thumb_up),
                            backgroundColor: kPrimaryLightColor,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
}
