import 'package:flutter/material.dart';
import 'package:sky_auth/components/background.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sky_auth/components/loginButton.dart';
import 'package:sky_auth/constants.dart';
import 'package:sky_auth/views/login/login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                child:const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Login())),

              ),
              Container(
                width: size.width * 0.7,
                padding: const EdgeInsets.all(5),
                //padding: const EdgeInsets.symmetric(vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: FlatButton(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    color: kPrimaryLightColor,
                    onPressed: () {},
                    onLongPress: () {
                      const snackBar =
                          SnackBar(content: Text('Yay! A SnackBar!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
}

