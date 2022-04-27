// ignore_for_file: unused_import, deprecated_member_use

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_auth/components/drawerWidget.dart';
import 'package:sky_auth/components/identifierListTile.dart';
import 'package:sky_auth/constants.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../../API/ApiFunctions.dart';
import '../../components/BottomNav.dart';
import '../login/login.dart';

class Identifiers extends StatefulWidget {
  const Identifiers({Key? key}) : super(key: key);

  @override
  State<Identifiers> createState() => _IdentifiersState();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}

class _IdentifiersState extends State<Identifiers> {
  var selectedIndex = 1;
  var VALUE;
  TextEditingController _identifier = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        drawer: const DrawerWidget(),
        appBar: AppBar(
          toolbarHeight: size.height * 0.1,
          backgroundColor: kPrimary,
          elevation: 10,
          title: const Text(
            'Sky-Auth',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 3,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: TextField(
                  onChanged: (value) {
                    VALUE = _identifier.text;
                  },
                  style: const TextStyle(fontSize: 14),
                  controller: _identifier,
                  decoration: const InputDecoration(
                    labelText: 'Add identifier',
                    labelStyle: TextStyle(fontSize: 16),
                    //border: InputBorder.none,
                  ),
                ),
              ),
              CustomDropDown(VALUE),
              const Divider(
                thickness: 2,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: const Text(
                  'IDENTIFIERS',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                height: size.height * 0.45,
                alignment: Alignment.centerLeft,
                //margin: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: ListView.builder(
                  itemCount: constantIdentifiers.length,
                  itemBuilder: (context, int index) {
                    try {
                      var identifier = constantIdentifiers[index]['identifier'];

                      if (programIDs == null) {
                        return FocusedMenuHolder(
                          blurBackgroundColor: Colors.blueGrey[900],
                          openWithTap: false,
                          onPressed: () {},
                          menuItems: const [],
                          child: IdentifierListTile(index),
                        );
                      }

                      List<String> programNames = [];

                      try {
                        for (int i = 0; i < programIDs.length; i++) {
                          if (programIDs[i]["identifier"] == identifier) {
                            for (int j = 0; j < programs.length; j++) {
                              if (programIDs[i]["program_id"] ==
                                  programs[j]["program_id"]) {
                                programNames.add(programs[j]["program_name"]);
                              }
                            }
                          }
                        }
                      } catch (e) {
                      }

                      return FocusedMenuHolder(
                        blurBackgroundColor: Colors.blueGrey[900],
                        openWithTap: false,
                        onPressed: () {},
                        menuItems: programNames
                            .map(
                              (e) => FocusedMenuItem(
                                title: Text(
                                  e,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      var isSwitched;
                                      var id;

                                      for (int i = 0;
                                          i < programs.length;
                                          i++) {
                                        if (programs[i]["program_name"] == e) {
                                          id = programs[i]["program_id"];
                                        }
                                      }

                                      for (int i = 0;
                                          i < programStatus.length;
                                          i++) {
                                        if (id ==
                                            programStatus[i]["program_id"]) {
                                          if (programStatus[i]["status"] ==
                                              "ACTIVE") {
                                            isSwitched = true;
                                          } else {
                                            isSwitched = false;
                                          }
                                        }
                                      }

                                      return AlertDialog(
                                        title: Text(
                                          e,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        content: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 20),
                                          decoration: const BoxDecoration(
                                              color: kPrimaryLightColor),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: const Text(
                                                  "Enabled",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                                trailing: Switch(
                                                  value: isSwitched,
                                                  onChanged: (value) async {
                                                    setState(() {
                                                      isSwitched = value;
                                                    });
                                                    var PROGID;
                                                    for (int j = 0;
                                                        j < programs.length;
                                                        j++) {
                                                      if (e ==
                                                          programs[j][
                                                              "program_name"]) {
                                                        PROGID = programs[j]
                                                            ["program_id"];
                                                        break;
                                                      }
                                                    }
                                                    if (value == true) {
                                                      for (int i = 0;
                                                          i <
                                                              programStatus
                                                                  .length;
                                                          i++) {
                                                        if (id ==
                                                            programStatus[i][
                                                                "program_id"]) {
                                                          programStatus[i]
                                                                  ["status"] =
                                                              "ACTIVE";
                                                          break;
                                                        }
                                                      }
                                                      await updateStatusCode(
                                                          "ACTIVE",
                                                          identifier,
                                                          PROGID);
                                                      Future.delayed(
                                                          const Duration(
                                                              seconds: 1),
                                                          () async {
                                                        await getStatusCodes();
                                                      });
                                                    } else {
                                                      for (int i = 0;
                                                          i <
                                                              programStatus
                                                                  .length;
                                                          i++) {
                                                        if (id ==
                                                            programStatus[i][
                                                                "program_id"]) {
                                                          programStatus[i]
                                                                  ["status"] =
                                                              "INACTIVE";
                                                          break;
                                                        }
                                                      }
                                                      await updateStatusCode(
                                                          "INACTIVE",
                                                          identifier,
                                                          PROGID);
                                                      await getStatusCodes();
                                                    }
                                                    Navigator.pop(context);
                                                  },
                                                  activeTrackColor:
                                                      Colors.lightGreenAccent,
                                                  activeColor: Colors.green,
                                                ),
                                              ),
                                              ListTile(
                                                title: const Text(
                                                  "Remove",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                                trailing: const Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.black,
                                                ),
                                                onTap: () async {
                                                  var PROGID;
                                                  for (int j = 0;
                                                      j < programs.length;
                                                      j++) {
                                                    if (e ==
                                                        programs[j]
                                                            ["program_name"]) {
                                                      PROGID = programs[j]
                                                          ["program_id"];
                                                      break;
                                                    }
                                                  }
                                                  await deleteProgram(
                                                      identifier, PROGID);
                                                  await getStatusCodes();
                                                  await getProgramsForIdentifier();
                                                  Navigator.of(context)
                                                      .pushReplacementNamed(
                                                          "/identifiers");
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        elevation: 20,
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                            .toList(),
                        child: IdentifierListTile(index),
                      );
                    } catch (e) {
                      return IdentifierListTile(index);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateStatusCode(String status, var identifier, var progID) async {
    var body = {
      "user_id": USERID,
      "status": status,
      "identifier": identifier,
      "program_id": progID
    };

    var response = await http.post(
      Uri.parse("http://$ipAddress:8081/sky-auth/auth_details/disable"),
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 75, 181, 67),
          textColor: Colors.white,
          fontSize: 14.0);
      return;
    }

    var snackBar = const SnackBar(
      content: Text(
        'Something went wrong. Try again later',
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 204, 204),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return;
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
}

class CustomDropDown extends StatefulWidget {
  var identifier;

  CustomDropDown(this.identifier, {Key? key}) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance!.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    Color COLOR = Colors.black;
    if (isDarkMode) {
      COLOR = Colors.white;
    }
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: const BoxDecoration(
            color: kPrimaryLightColor,
          ),
          child: DropdownButton(
            value: defaultValue,
            style: TextStyle(
              fontSize: 20,
              color: COLOR,
            ),
            onChanged: (newValue) {
              setState(() {
                defaultValue = newValue;
              });
            },
            items: constantIdentifierTypes.map((identifierType) {
              return DropdownMenuItem(
                child: Text(
                  identifierType["identifier_type"],
                  style: const TextStyle(fontSize: 16),
                ),
                value: identifierType["identifier_type"],
              );
            }).toList(),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          color: kPrimary,
          child: FlatButton(
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              String Identifier = widget.identifier;
              print(Identifier);
              String identifierType = defaultValue;
              await addIdentifierToDB(Identifier, identifierType, context);
              Navigator.of(context).pushReplacementNamed("/identifiers");
              setState(() {});
            },
            child: const Text(
              'ADD IDENTIFIER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
