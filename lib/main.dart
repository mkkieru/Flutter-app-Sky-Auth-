import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sky_auth/constants.dart';
import 'package:sky_auth/homePage.dart';
import 'package:sky_auth/views/identifier/identifier.dart';
import 'package:sky_auth/views/login/login.dart';
import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:sky_auth/views/startup/welcome_screen.dart';
import 'views/signup/signup.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });

  FlutterCryptography.enable();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/images/add.png"), context);
    precacheImage(const AssetImage("assets/images/bottom1.png"), context);
    precacheImage(const AssetImage("assets/images/bottom2.png"), context);
    precacheImage(const AssetImage("assets/images/login_bottom.png"), context);
    precacheImage(const AssetImage("assets/images/main.png"), context);
    precacheImage(const AssetImage("assets/images/main_bottom.png"), context);
    precacheImage(const AssetImage("assets/images/main_top.png"), context);
    precacheImage(const AssetImage("assets/images/notFound.png"), context);
    precacheImage(const AssetImage("assets/images/signup_top.png"), context);
    precacheImage(const AssetImage("assets/images/top1.png"), context);
    precacheImage(const AssetImage("assets/images/top2.png"), context);
    precacheImage(const AssetImage("assets/images/user.png"), context);
    precacheImage(
        const AssetImage("assets/images/Sky-World-Logo-no-bg.png"), context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mark Kieru',
      theme: ThemeData(
        primaryColor: kPrimary,
        fontFamily: 'Roboto',
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primaryColor: kPrimary,
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
      ),
      home: const LoaderOverlay(
        child: WelcomeScreen(),
      ),
      routes: {
        '/login': (context) => const LoaderOverlay(child: Login()),
        '/signup': (context) => const LoaderOverlay(child: Signup()),
        '/homePage': (context) => const LoaderOverlay(child: HomePage()),
        '/identifiers': (context) => const LoaderOverlay(child: Identifiers()),
      },
    );
  }
}
