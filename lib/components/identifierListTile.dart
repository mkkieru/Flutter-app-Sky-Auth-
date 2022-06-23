// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../API/ApiFunctions.dart';
import '../constants.dart';

// ignore: must_be_immutable
class IdentifierListTile extends StatefulWidget {
  var index;

  // ignore: use_key_in_widget_constructors
  IdentifierListTile(this.index);

  @override
  State<IdentifierListTile> createState() => _IdentifierListTileState();
}

class _IdentifierListTileState extends State<IdentifierListTile> {
  // ignore: prefer_final_fields
  TextEditingController _token = TextEditingController();
  var token;

  @override
  Widget build(BuildContext context) {
    try {
      return Dismissible(
        key: Key(constantIdentifiers[widget.index]['identifier']),
        background: Container(
          color: Colors.red,
          child: Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const <Widget>[
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                Text(
                  "Swipe Left To Delete ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            alignment: Alignment.centerLeft,
          ),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          child: Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const <Widget>[
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                Text(
                  " Delete",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            alignment: Alignment.centerRight,
          ),
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            setState(() {});
          }
        },
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            final bool res = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                        "Are you sure you want to delete ${constantIdentifiers[widget.index]['identifier']}?"),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          "Cancel",
                          //style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () async {
                          await deleteIdentifier(
                              constantIdentifiers[widget.index]
                                  ["identifier_type"],
                              constantIdentifiers[widget.index]['identifier'],
                              context);
                          await getIdentifierAndTypes();
                          Navigator.of(context)
                              .pushReplacementNamed('/identifiers');
                        },
                      ),
                    ],
                  );
                });
            return res;
          }
        },
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                var identifier = constantIdentifiers[widget.index]['identifier'];
                if (programIDs == null) {

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
                  //
                }
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
                      return FractionallySizedBox(
                        heightFactor: 0.5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children:[
                              Container(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child:Row(
                                  children:   [
                                    Text(
                                      "Programs for ${constantIdentifiers[widget.index]['identifier']}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Spacer(),
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
                              ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {

                                  final ValueNotifier<bool> isSwitched = ValueNotifier(false);
                                  var id;

                                  for (int i = 0;
                                  i < programs.length;
                                  i++) {
                                    if (programs[i]["program_name"] == programNames[index]) {
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
                                        isSwitched.value = true;
                                      } else {
                                        isSwitched.value = false;
                                      }
                                    }
                                  }
                                  return Dismissible(
                                    key: Key(programNames[index]),
                                    background: Container(
                                      child: const Align(),
                                    ),
                                    secondaryBackground: Container(
                                      color: Colors.red,
                                      child: Align(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: const <Widget>[
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              " Delete",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.centerRight,
                                      ),
                                    ),
                                    onDismissed: (direction) {
                                      if (direction == DismissDirection.endToStart) {
                                        setState(() {});
                                      }
                                    },
                                    confirmDismiss: (direction) async {
                                      if (direction == DismissDirection.endToStart) {
                                        final bool res = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Text(
                                                    "Are you sure you want to remove ${programNames[index]}?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text(
                                                      "Cancel",
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text(
                                                      "Delete",
                                                      style: TextStyle(color: Colors.red),
                                                    ),
                                                    onPressed: () async {

                                                        var PROGID;
                                                        for (int j = 0;
                                                        j < programs.length;
                                                        j++) {
                                                          if (programNames[index] ==
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
                                              );
                                            });
                                        return res;
                                      }
                                    },
                                    child: ListTile(
                                      title: Text(programNames[index]),
                                      trailing: ValueListenableBuilder(
                                        valueListenable: isSwitched ,
                                        builder: (context, takenSurvey, child) {
                                          if(isSwitched.value) {
                                            return Switch(
                                              value: true,
                                              onChanged: (value) async {
                                                var PROGID;
                                                for (int j = 0;
                                                j < programs.length;
                                                j++) {
                                                  if (programNames[index] ==
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
                                                  isSwitched.value = !isSwitched.value;
                                                  await updateStatusCode(
                                                      "ACTIVE",
                                                      identifier,
                                                      PROGID);
                                                  await getStatusCodes();
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
                                                  isSwitched.value = !isSwitched.value;
                                                  await updateStatusCode(
                                                      "INACTIVE",
                                                      identifier,
                                                      PROGID);
                                                  await getStatusCodes();
                                                }
                                              },
                                              activeTrackColor:
                                              kPrimaryLightColor,
                                              activeColor: kPrimary,
                                            );
                                          }
                                          return Switch(
                                            value: false,
                                            onChanged: (value) async {
                                              var PROGID;
                                              for (int j = 0;
                                              j < programs.length;
                                              j++) {
                                                if (programNames[index] ==
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
                                                isSwitched.value = !isSwitched.value;
                                                await updateStatusCode(
                                                    "ACTIVE",
                                                    identifier,
                                                    PROGID);
                                                await getStatusCodes();
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
                                                isSwitched.value = !isSwitched.value;
                                                await updateStatusCode(
                                                    "INACTIVE",
                                                    identifier,
                                                    PROGID);
                                                await getStatusCodes();
                                              }
                                            },
                                            activeTrackColor:
                                            kPrimaryLightColor,
                                            activeColor: kPrimary,
                                          );
                                          },
                                      ),
                                    ),
                                  );
                                },
                                itemCount: programNames.length,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                );
              },
              child: ListTile(
                enabled: true,
                title: SizedBox(
                  child: Text(
                    constantIdentifiers[widget.index]['identifier'],
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                trailing: Text(
                  constantIdentifiers[widget.index]['identifier_type'],
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),

          ],
        ),
      );
    } catch (exception) {
      return Column(
        children: const [
          ListTile(
            enabled: true,
            title: SizedBox(
              //width: size.width * 0.6,
              child: Text(
                "Add an identifier to view it",
                maxLines: 2,
                style: TextStyle(
                  //fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      );
    }
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
      await getProgramsForIdentifier();
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

  Future confirmIdentifierDialogPopUp(
          var identifier, var identifierType, context) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
              "Link ${constantIdentifiers[widget.index]['identifier']} to a program"),
          actions: <Widget>[
            TextButton(
              child: TextField(
                controller: _token,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  labelText: 'Enter token ',
                  labelStyle: TextStyle(fontSize: 16),
                ),
              ),
              onPressed: () {},
            ),
            TextButton(
              child: const Text(
                "Confirm",
              ),
              onPressed: () async {
                await confirmIdentifier(
                    constantIdentifiers[widget.index]['identifier'],
                    constantIdentifiers[widget.index]["identifier_type"],
                    _token.text);
                await getIdentifierAndTypes();
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
}
