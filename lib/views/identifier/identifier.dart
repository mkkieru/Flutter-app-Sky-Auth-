// ignore_for_file: unused_import, deprecated_member_use

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
import '../../homePage.dart';
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
  var items = [
    const Text(
      'Logout',
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
    )
  ];

  TextEditingController _identifier = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final ThemeData mode = Theme.of(context);
    var whichMode = mode.brightness;
    Color COLOR = Colors.white;
    if (whichMode == Brightness.dark) {
      COLOR = Colors.black;
    }

    if(show){
      show = false;
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            isScrollControlled:true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            builder: (builder){
              return Padding(
                  child:  FractionallySizedBox(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child:Row(
                              children:   [
                                const Text(
                                  "Add Identifier",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child:const Icon(Icons.cancel_outlined,size: 25,),
                                )

                              ],
                            ) ,
                          ),
                          const Divider(thickness: 2,),
                          Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: DropdownButtonFormField2(
                              decoration: const InputDecoration(
                                isDense: true,
                                labelText: "Identifier Type",
                                border: OutlineInputBorder(
                                ),
                              ),
                              isExpanded: true,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                              ),
                              iconOnClick: const Icon(
                                Icons.arrow_drop_up,
                              ),
                              iconSize: 30,
                              buttonHeight: 60,
                              //buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              onChanged: (newValue) {
                                defaultValue = newValue;
                              },
                              items: constantIdentifierTypes.map((identifierType) {
                                return DropdownMenuItem(
                                  child: Text(
                                    identifierType["identifier_type"],
                                  ),
                                  value: identifierType["identifier_type"],
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select identifier.';
                                }
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  VALUE = _identifier.text;
                                });
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: _identifier,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Identifier',
                                labelStyle: TextStyle(fontSize: 16),
                                //border: InputBorder.none,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              String Identifier = VALUE;

                              if(defaultValue == null){
                                Fluttertoast.showToast(
                                    msg: "Select Identifier Type",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                                return;
                              }else if(Identifier == null || Identifier == ""){
                                Fluttertoast.showToast(
                                    msg: "Identifier Can't Be Empty ",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                                return;
                              }
                              String identifierType = defaultValue;
                              await addIdentifierToDB(Identifier, identifierType);
                              Navigator.of(context).pushReplacementNamed("/identifiers");
                              setState(() {});
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: const BoxDecoration(
                                color: kPrimaryLightColor,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const Text(
                                    "Add Identifier",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //CustomDropDown(VALUE),
                        ],
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom));
            }
        );
      });
    }

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
          title: SizedBox(
            width: size.width * 0.6,
            child: const Text(
              "IDENTIFIERS",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FocusedMenuHolder(
                blurBackgroundColor: Colors.blueGrey[900],
                openWithTap: true,
                onPressed: () {},
                animateMenuItems: true,
                menuItems: items
                    .map((e) => FocusedMenuItem(
                        title: e,
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: const Text(
                                  "Are you sure you want to logout?"),
                              actions: <Widget>[
                                FlatButton(
                                  child: const Text(
                                    "No",
                                    //style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.red),
                                  ),
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
                                ),
                              ],
                            ),
                          );
                        }))
                    .toList(),
                child: CircleAvatar(
                  radius: size.height * 0.035,
                  backgroundColor: Colors.brown.shade800,
                  child: Text(INITIALS),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.height * 0.9,
                child: ListView.builder(
                  itemCount: constantIdentifiers.length,
                  itemBuilder: (context, int index) {
                      return Column(children: [
                        IdentifierListTile(index),
                        const Divider(
                          thickness: 2,
                        ),
                      ],
                      );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                isScrollControlled:true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                builder: (builder){
                  return Padding(
                      child:  FractionallySizedBox(
                        //heightFactor: 0.8,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child:Row(
                                  children:   [
                                    const Text(
                                      "Add Identifier",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child:const Icon(Icons.cancel_outlined,size: 25,),
                                    )

                                  ],
                                ) ,
                              ),
                              const Divider(thickness: 2,),
                              Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: double.infinity,
                                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: DropdownButtonFormField2(
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    labelText: "Identifier Type",
                                    border: OutlineInputBorder(
                                    ),
                                  ),
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                  iconOnClick: const Icon(
                                    Icons.arrow_drop_up,
                                  ),
                                  iconSize: 30,
                                  buttonHeight: 60,
                                  //buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  onChanged: (newValue) {
                                    defaultValue = newValue;
                                  },
                                  items: constantIdentifierTypes.map((identifierType) {
                                    return DropdownMenuItem(
                                      child: Text(
                                        identifierType["identifier_type"],
                                      ),
                                      value: identifierType["identifier_type"],
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select identifier.';
                                    }
                                  },
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: double.infinity,
                                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      VALUE = _identifier.text;
                                    });
                                  },
                                  style: const TextStyle(fontSize: 14),
                                  controller: _identifier,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Identifier',
                                    labelStyle: TextStyle(fontSize: 16),
                                    //border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                width: double.infinity,
                                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: kPrimaryLightColor,
                                ),
                                child: FlatButton(
                                  onPressed: () async {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    String Identifier = VALUE;

                                    if(defaultValue == null){
                                      Fluttertoast.showToast(
                                          msg: "Select Identifier Type",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 14.0);
                                      return;
                                    }else if(Identifier == null || Identifier == ""){
                                      Fluttertoast.showToast(
                                          msg: "Identifier Can't Be Empty ",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 14.0);
                                      return;
                                    }
                                    String identifierType = defaultValue;
                                    await addIdentifierToDB(Identifier, identifierType);
                                    Navigator.of(context).pushReplacementNamed("/identifiers");
                                    setState(() {});
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Text(
                                        "Add Identifier",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //CustomDropDown(VALUE),
                            ],
                          ),
                        ),
                      ),
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom));
                }
            );
          },
          icon: Icon(
            Icons.add,
            color: COLOR,
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
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.35,

                //margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: DropdownButtonFormField2(
                  value: defaultValue,
                  decoration: InputDecoration(
                    //Add isDense true and zero Padding.
                    //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    //Add more decoration as you want here
                    //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                  ),
                  isExpanded: true,
                  hint: const Text(
                    'Select Identifier Type',
                    style: TextStyle(fontSize: 14),
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                  iconOnClick: const Icon(
                    Icons.arrow_drop_up,
                    color: Colors.black45,
                  ),
                  iconSize: 30,
                  buttonHeight: 60,
                  buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onChanged: (newValue) {
                    defaultValue = newValue;
                  },
                  items: constantIdentifierTypes.map((identifierType) {
                    return DropdownMenuItem(
                      child: Text(
                        identifierType["identifier_type"],
                        //style: const TextStyle(fontSize: 16),
                      ),
                      value: identifierType["identifier_type"],
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select identifier.';
                    }
                  },
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  String Identifier = widget.identifier;
                  String identifierType = defaultValue;
                  await addIdentifierToDB(Identifier, identifierType);
                  Navigator.of(context).pushReplacementNamed("/identifiers");
                  setState(() {});
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue,
                          Colors.lightBlueAccent,
                        ]),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        "Add Identifier",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                          //padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: const Icon(
                            Icons.add,
                            color: Colors.lightBlueAccent,
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
