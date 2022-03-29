// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';

import '../constants.dart';
import 'package:http/http.dart' as http;

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

  @override
  Widget build(BuildContext context) {
    try {
      if (constantIdentifiers[widget.index]["state"] == "DISABLED") {
        return Container(
          margin: const EdgeInsets.all(2),
          color: const Color(0xFFB4B4CB),
          child: GestureDetector(
            onTap: () {
              confirmIdentifierDialogPopUp(
                  constantIdentifiers[widget.index]['identifier'],
                  constantIdentifiers[widget.index]["identifier_type"],
                  context,
                  _token);
              //getStatusCodes();
            },
            child: ListTile(
              title: Text(
                constantIdentifiers[widget.index]['identifier'],
                style: const TextStyle(fontSize: 20),
              ),
              trailing: Text(
                constantIdentifiers[widget.index]["identifier_type"],
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        );
      }
      return Container(
        margin: const EdgeInsets.all(2),
        color: const Color.fromARGB(255, 75, 181, 67),
        child: GestureDetector(
          onLongPress: () {},
          child: ListTile(
            enabled: true,
            title: Text(
              constantIdentifiers[widget.index]['identifier'],
              style: const TextStyle(fontSize: 20),
            ),
            trailing: Text(
              constantIdentifiers[widget.index]["identifier_type"],
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      );
    } catch (exception) {
      return Container(
        margin: const EdgeInsets.all(2),
        color: const Color.fromARGB(255, 75, 181, 67),
        child: const ListTile(
          enabled: true,
          title: Text(
            "Add an identifier to view it",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
  }

  Future confirmIdentifierDialogPopUp(
          var identifier, var identifierType, context, token) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            identifier,
            style: const TextStyle(fontSize: 20),
          ),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: const BoxDecoration(color: kPrimaryLightColor),
            child: TextField(
              controller: token,
              decoration: const InputDecoration(
                hintText: 'Token',
                border: InputBorder.none,
              ),
            ),
          ),
          actions: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              // ignore: deprecated_member_use
              child: FlatButton(
                // ignore: prefer_const_constructors
                padding: EdgeInsets.all(10),
                color: kPrimary,
                onPressed: () async  {
                  await confirmIdentifier(
                      context, identifier, identifierType, token.text);
                  //await getStatusCodes();
                },
                child: const Text(
                  'confirm',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
          elevation: 20,
        ),
      );

  confirmIdentifier(context, identifier, identifierType, text) async {
    var body = {
      "identifier": identifier,
      "identifier_type": identifierType,
      "user_id": USERID,
      "token": text,
    };

    var response = await http.post(
      Uri.parse("http://85.159.214.103:8081/sky-auth/identifier/confirm_identifier"),
      body: jsonEncode(body),
      headers: {"access_token": ACCESSTOKEN},
    );

    if (response.statusCode == 200) {
      var snackBar = const SnackBar(
        content: Text(
          'IDENTIFIER CONFIRMED',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 75, 181, 67),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        getIdentifierAndTypes(context);
        getStatusCodes();
      });
      return;
    }

    var snackBar = SnackBar(
      content: Text(
        response.body,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 204, 204),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void getIdentifierAndTypes(context) async {
    var responseIdentifiers = await http.get(
        Uri.parse("http://85.159.214.103:8081/sky-auth/identifier"),
        headers: {"access_token": ACCESSTOKEN});

    var responseIdentifierTypes = await http.get(
        Uri.parse('http://85.159.214.103:8081/sky-auth/identifier_type'),
        headers: {"access_token": ACCESSTOKEN});

    if (responseIdentifiers.statusCode == 200 ||
        responseIdentifierTypes.statusCode == 200) {
      var identifiersFromDB = jsonDecode(responseIdentifiers.body);
      var identifierTypesFromDB = jsonDecode(responseIdentifierTypes.body);

      constantIdentifiers.clear();
      constantIdentifierTypes.clear();

      try {
        if (identifiersFromDB["Message"]) {}
      } catch (exception) {
        for (int i = 0; i < identifiersFromDB.length; i++) {
          constantIdentifiers.add(identifiersFromDB[i]);
        }
      }

      for (int i = 0; i < identifierTypesFromDB.length; i++) {
        constantIdentifierTypes.add(identifierTypesFromDB[i]);
      }
      return;
    }

    if (jsonDecode(responseIdentifiers.body)["Error"] ==
        "Please log in to continue") {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  getStatusCodes() async {
    var response = await http.get(
      Uri.parse("http://85.159.214.103:8081/sky-auth/auth_details?user_id=" +
          USERID.toString() +
          "&identifier=" +
          individualIdentifier),
      headers: {"access_token": ACCESSTOKEN},
    );

    if (response.statusCode == 200) {
      try {
        setState(() {
          authCodes = jsonDecode(response.body);
        });
      } catch (e) {
        setState(() {
          authCodes = [jsonDecode(response.body)];
        });
      }
    }
  }
}
