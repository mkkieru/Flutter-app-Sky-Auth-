import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class BottomNav extends StatefulWidget {
  var selectedIndex;


  BottomNav(this.selectedIndex);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
      selectedIndex: widget.selectedIndex,
      items: [
        BottomNavyBarItem(
          icon: const Icon(Icons.home),
          title: const Text("Home"),
          activeColor: Colors.blueAccent,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.add_card_rounded),
          title: const Text("Identifiers"),
          activeColor: Colors.blueAccent,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.logout),
          title: const Text("Logout"),
          activeColor: Colors.blueAccent,
        ),
      ],
      onItemSelected: (int value) async {
        if (value == 0) {
          Navigator.of(context).pushReplacementNamed("/homePage");
        } else if (value == 1) {
          Navigator.of(context).pushReplacementNamed("/identifiers");
        } else if (value == 2) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              actionsPadding: const EdgeInsets.all(10),
              title: const Text(
                "Are you sure you want to log out?",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      child: FlatButton(
                        // ignore: prefer_const_constructors
                        //padding: EdgeInsets.all(5),
                        color: kPrimary,
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    ClipRRect(
                      //borderRadius: BorderRadius.circular(20),
                      child: FlatButton(
                        // ignore: prefer_const_constructors
                        //padding: EdgeInsets.all(5),
                        color: kPrimary,
                        onPressed: () async {
                          final SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                          prefs.setString('user_id', "");
                          prefs.setString('ip_address', "");
                          prefs.setString('access_token', "");

                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
              elevation: 20,
            ),
          );
        }
        setState(() {});
      },
    );
  }
}
