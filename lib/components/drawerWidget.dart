// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sky_auth/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../API/ApiFunctions.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late String _defaultValue;

  @override
  void initState() {
    try {
      if (individualIdentifier != "") {
        _defaultValue = individualIdentifier;
      } else {
        _defaultValue = constantIdentifiers[0]["identifier"];
      }
    } catch (e) {
      _defaultValue = "No identifiers";
    }
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = SchedulerBinding.instance!.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    Color COLOR = Colors.black;
    if(isDarkMode) {
      COLOR = Colors.white;
    }
    try {
      if (individualIdentifier != "") {
        _defaultValue = individualIdentifier;
        getStatusCodes();
      } else if (constantIdentifiers.isNotEmpty) {
        _defaultValue = constantIdentifiers[0]["identifier"];
        getStatusCodes();
      }
    } catch (e) {
      _defaultValue = "No identifiers";
    }
    return Drawer(
      child: Material(
        child: Container(
          color: Colors.white70,
          child: Column(
            children: <Widget>[
              Container(
                color: kPrimary,
                height: size.height * .35,
                alignment: Alignment.center,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.brown.shade800,
                        radius: 50,
                        child: Text(
                          INITIALS,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          USERNAME,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          value: _defaultValue,
                          style:  TextStyle(
                            fontSize: 16,
                            color: COLOR,
                          ),
                          onChanged: (newValue) async {
                            if (newValue.toString() == "No identifiers") {
                              _defaultValue = newValue.toString();
                              return;
                            }
                            _defaultValue = newValue.toString();
                            individualIdentifier = newValue.toString();

                            await getStatusCodes();
                            Navigator.pushReplacementNamed(
                                context, '/homePage');
                          },
                          items: constantIdentifiers.map((identifiers) {
                            try {
                              return DropdownMenuItem(
                                child: SizedBox(
                                  child: Row(
                                    children: [
                                      Text(
                                        identifiers['identifier'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                value: identifiers['identifier'],
                              );
                            } catch (e) {
                              return const DropdownMenuItem(
                                child: Text(
                                  "No identifiers",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                value: "No identifiers",
                              );
                            }
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed("/homePage");
                },
                title: const Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/identifiers');
                },
                title: const Text(
                  'Add Account',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              ListTile(
                onTap: () async {
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
                              //borderRadius: BorderRadius.circular(20),
                              // ignore: deprecated_member_use
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
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            ClipRRect(
                              //borderRadius: BorderRadius.circular(20),
                              // ignore: deprecated_member_use
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
                                  prefs.setString('username', "");

                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(
                                      context, '/login');
                                },
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(
                                    fontSize: 16,
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
                },
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
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
