// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sky_auth/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: Material(
        color: kPrimaryLightColor,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
          children: <Widget>[
            const Text(
              'SKY-AUTH',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: kPrimary,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                //shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(20),
              ),
              child: GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/icons/signup.svg',
                  height: size.height * 0.3,
                ),
              ),
            ),
            const Divider(
              thickness: 2,
              color: kPrimary,
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed("/homePage");
              },
              leading: const Icon(
                Icons.person,
                color: kPrimary,
                size: 25,
              ),
              title: const Text(
                'Home',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/identifiers');
              },
              leading: const Icon(
                Icons.person,
                color: kPrimary,
                size: 25,
              ),
              title: const Text(
                'Identifiers',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                prefs.setString('user_id', "");
                prefs.setString('ip_address', "");
                prefs.setString('access_token', "");

                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              leading: const Icon(
                Icons.logout_outlined,
                color: kPrimary,
                size: 25,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(
              thickness: 2,
              color: kPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
