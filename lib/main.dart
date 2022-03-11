import 'package:flutter/material.dart';
import 'package:sky_auth/constants.dart';
import 'package:sky_auth/homePage.dart';
import 'package:sky_auth/views/login/login.dart';
import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:sky_auth/views/startup/welcome_screen.dart';


import 'views/signup/signup.dart';

void main() {
  runApp(const MyApp());
  FlutterCryptography.enable();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mark Kieru',
      theme: ThemeData(
        primaryColor: kPrimary,
        fontFamily: 'Kaushan_Script',
        //brightness: Brightness.dark,
        brightness: Brightness.light,
      ),
      home: const WelcomeScreen(),
      routes: {
        '/login': (context) => const Login(),
        '/signup': (context) => const Signup(),
        '/homePage': (context) => const HomePage(),
      },
    );
  }
}
