// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sky_auth/constants.dart';
import 'package:http/http.dart' as http;

class IdentifierDropDownButton extends StatefulWidget {
  const IdentifierDropDownButton({Key? key}) : super(key: key);

  @override
  State<IdentifierDropDownButton> createState() =>
      _IdentifierDropDownButtonState();
}

class _IdentifierDropDownButtonState extends State<IdentifierDropDownButton> {
  var _defaultValue;

  @override
  void initState() {
    try {
        _defaultValue = constantIdentifiers[0]["identifier"];
    } catch (e) {
        _defaultValue = "No identifiers";
    }
  }

  @override
  Widget build(BuildContext context) {
    return
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
      onChanged: (newValue) {
        if(newValue.toString() == "No identifiers"){
          _defaultValue = newValue.toString();
          return;
        }
        setState(() {
          _defaultValue = newValue.toString();
          individualIdentifier = newValue.toString();
          getStatusCodes();
        });
      },
      items: constantIdentifiers.map((identifiers) {
        try {
          return DropdownMenuItem(
            child: Text(
              identifiers['identifier'],
              style: const TextStyle(color: Colors.black),
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
    );
  }
  getStatusCodes() async {
    print("Getting the codes of $individualIdentifier");
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
          print(authCodes);
        });
      }
    }
  }
}
