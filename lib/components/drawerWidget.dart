// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sky_auth/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API/ApiFunctions.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();

  Duration get transitionDuration => const Duration(milliseconds: 0);
}

class _DrawerWidgetState extends State<DrawerWidget> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Drawer(
      child: Material(
        child: Container(
          color: Colors.white,
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
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: CircleAvatar(
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
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          USERNAME,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // DropdownButtonHideUnderline(
                      //   child: DropdownButton2(
                      //     isExpanded: true,
                      //     value: _defaultValue,
                      //     style: const TextStyle(
                      //       fontSize: 16,
                      //     ),
                      //     icon: const Icon(
                      //       Icons.arrow_drop_down,
                      //     ),
                      //     iconOnClick: const Icon(
                      //       Icons.arrow_drop_up,
                      //     ),
                      //     dropdownDecoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(15),
                      //       color: Colors.blueGrey,
                      //     ),
                      //     onChanged: (newValue) async {
                      //       if (newValue.toString() == "No identifiers") {
                      //         _defaultValue = newValue.toString();
                      //         return;
                      //       }
                      //       _defaultValue = newValue.toString();
                      //       individualIdentifier = newValue.toString();
                      //
                      //       await getStatusCodes();
                      //       Navigator.of(context).pushReplacementNamed('/homePage');
                      //     },
                      //     items: constantIdentifiers.map((identifiers) {
                      //       try {
                      //         return DropdownMenuItem(
                      //           child: SizedBox(
                      //             child: Row(
                      //               children: [
                      //                 Text(
                      //                   identifiers['identifier'],
                      //                   style: const TextStyle(
                      //                     color: Colors.white,
                      //                     fontSize: 16,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           value: identifiers['identifier'],
                      //         );
                      //       } catch (e) {
                      //         return const DropdownMenuItem(
                      //           child: Text(
                      //             "No identifiers",
                      //             style: TextStyle(
                      //               fontSize: 16,
                      //             ),
                      //           ),
                      //           value: "No identifiers",
                      //         );
                      //       }
                      //     }).toList(),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () async {
                  //Navigator.of(context).pop();
                  await getStatusCodes();
                  Navigator.of(context).pushReplacementNamed('/homePage');
                },
                leading: const Icon(Icons.home,color: Colors.black,),
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
                leading: const Icon(Icons.credit_card,color: Colors.black,),
                title: const Text(
                  'Identifiers',
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
                      content: const Text("Are you sure you want to logout?"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            "No",
                            //style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
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
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        ),
                      ],
                    ),
                  );
                },
                leading: const Icon(
                    Icons.logout,
                color: Colors.black,),
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
