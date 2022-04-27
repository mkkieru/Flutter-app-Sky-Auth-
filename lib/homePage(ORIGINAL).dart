// ignore_for_file: file_names, prefer_typing_uninitialized_variables

//import 'dart:html';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_auth/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'components/homePageStatusCodesList.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _defaultValue;
  var selectedIndex = 0;

  Widget currentPage = const HomepageStatusCodesList();

  @override
  void initState() {
    super.initState();
    try {
      if (individualIdentifier != "") {
        _defaultValue = individualIdentifier;
      } else {
        _defaultValue = constantIdentifiers[0]["identifier"];
      }
    } catch (e) {
      _defaultValue = "No identifiers";
    }
    getProgramsForIdentifier();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var none = "No identifiers";
    try {
      if (individualIdentifier != "") {
        _defaultValue = individualIdentifier;
        getStatusCodes();
      } else if (constantIdentifiers.isNotEmpty) {
        _defaultValue = constantIdentifiers[0]["identifier"];
        getStatusCodes();
      } else {
        _defaultValue = none;
      }
    } catch (e) {
      _defaultValue = "No identifiers";
    }
    return SafeArea(
      child: Scaffold(
        //drawer: const DrawerWidget(),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: selectedIndex,
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
                    style: TextStyle(fontSize: 20),
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
                                fontSize: 18,
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
        ),
        appBar: AppBar(
          // ignore: prefer_const_constructors
          backgroundColor: kPrimary,
          elevation: 10,
          title: SizedBox(
            width: size.width * 0.6,
            child: const Text(
              'Sky-Auth',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                letterSpacing: 3,
              ),
            ),
          ),
          actions: [
            DropdownButton(
              icon: const Icon(
                Icons.arrow_drop_down_sharp,
                color: Colors.white,
              ),
              value: _defaultValue,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.blue,
              ),
              onChanged: (newValue) async {
                if (newValue.toString() == "No identifiers") {
                  _defaultValue = newValue.toString();
                  return;
                }
                _defaultValue = newValue.toString();
                individualIdentifier = newValue.toString();

                await getStatusCodes();
                Navigator.pushReplacementNamed(context, '/homePage');
              },
              items: constantIdentifiers.map((identifiers) {
                try {
                  return DropdownMenuItem(
                    child: SizedBox(
                      width: size.width * 0.4,
                      child: Text(
                        identifiers['identifier'],
                        style: const TextStyle(color: Colors.black,
                        ),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    value: identifiers['identifier'],
                  );
                } catch (e) {
                  return const DropdownMenuItem(
                    child: Text(
                      "No identifiers",
                      style: TextStyle(color: Colors.black),
                    ),
                    value: "No identifiers",
                  );
                }
              }).toList(),
            )
          ],
        ),
        //backgroundColor: kPrimaryLightColorHomePageBackground,
        body: Stack(
          children: const [
            HomepageStatusCodesList(),
          ],
        ),
      ),
    );
  }

  getStatusCodes() async {
    var response = await http.get(
      Uri.parse("http://$ipAddress:8081/sky-auth/auth_details?user_id=" +
          USERID.toString() +
          "&identifier=" +
          individualIdentifier),
      headers: {"access_token": ACCESSTOKEN},
    );

    if (response.statusCode == 200) {
      try {
        authCodes = jsonDecode(response.body);
      } catch (e) {
        authCodes = [jsonDecode(response.body)];
      }
    }
  }

  getProgramsForIdentifier() async {
    var body = {"user_id": USERID};
    var response = await http.post(
      Uri.parse(
          "http://$ipAddress:8081/sky-auth/programs/user/identifier/programs"),
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      try {
        programIDs = jsonDecode(response.body);
        for (int i = 0; i < programIDs.length; i++) {
          programStatus.add({
            "program_id": programIDs[i]["program_id"],
            "status": programIDs[i]["status"]
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        programIDs = [jsonDecode(response.body)];
      }
    }
  }
}
