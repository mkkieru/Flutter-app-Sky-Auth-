// ignore_for_file: file_names, prefer_typing_uninitialized_variables

//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:sky_auth/components/identifiersDropDownButtun.dart';
import 'package:sky_auth/constants.dart';
import 'components/drawerWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'components/homePageStatusCodesList.dart';
import 'package:permission_handler/permission_handler.dart';

import 'local_auth_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var _defaultValue;

  Widget currentPage = HomepageStatusCodesList();

  @override
  void initState() {
    try {
      _defaultValue = constantIdentifiers[0]["identifier"];
    } catch (e) {
      _defaultValue = "No identifiers";
    }
    getStatusCodes();
  }

  void callback() {
    setState(() {
      this.currentPage = HomepageStatusCodesList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const DrawerWidget(),
        appBar: AppBar(
          // ignore: prefer_const_constructors
          backgroundColor: kPrimary,
          elevation: 10,
          title: const Text(
            'Sky-Auth',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
              letterSpacing: 3,
            ),
          ),
          actions: [
            //IdentifierDropDownButton(),
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
                _defaultValue = newValue.toString();
                individualIdentifier = newValue.toString();

                getStatusCodes();
                callback();

                // setState(() {
                //   _defaultValue;
                // });
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
            )
          ],
        ),
        backgroundColor: kPrimaryLightColorHomePageBackground,
        body: Stack(
          children: [
            currentPage,
          ],
        ),
      ),
    );
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
