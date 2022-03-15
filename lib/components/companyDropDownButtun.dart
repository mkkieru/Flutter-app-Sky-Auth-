import 'package:flutter/material.dart';
import 'package:sky_auth/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompanyDropDownButton extends StatefulWidget {
  const CompanyDropDownButton({Key? key}) : super(key: key);

  @override
  State<CompanyDropDownButton> createState() => _CompanyDropDownButtonState();
}

class _CompanyDropDownButtonState extends State<CompanyDropDownButton> {
  var _defaultValue = constantIdentifiers[0]["identifier"];

  @override
  Widget build(BuildContext context) {
    getPrograms();
    return DropdownButton(
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
        setState(() {
          _defaultValue = newValue.toString();
          individualIdentifier = newValue.toString();
        });
      },
      items: constantIdentifiers.map((identifiers) {
        return DropdownMenuItem(
          child: Text(
            identifiers['identifier'],
            style: const TextStyle(color: Colors.black),
          ),
          value: identifiers['identifier'],
        );
      }).toList(),
    );
  }

  getPrograms() async {
    var response2 = await http.get(
      Uri.parse("http://10.0.2.2:8081/sky-auth/programs"),
      headers: {"access_token": ACCESSTOKEN},
    );
    programs.clear();
    programs = jsonDecode(response2.body);
  }
}
