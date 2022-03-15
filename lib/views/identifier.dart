import 'package:flutter/material.dart';
import 'package:sky_auth/components/identifierListTile.dart';
import 'package:sky_auth/constants.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'login/login.dart';

class Identifiers extends StatefulWidget {
  const Identifiers({Key? key}) : super(key: key);

  @override
  State<Identifiers> createState() => _IdentifiersState();
}

class _IdentifiersState extends State<Identifiers> {
  var _defaultValue = constantIdentifierTypes[0]["identifier_type"];

  @override
  Widget build(BuildContext context) {
    TextEditingController _identifier = TextEditingController();
    Size size = MediaQuery.of(context).size;
    setState(() {
      getIdentifierAndTypes(context);
    });
    return Scaffold(
      appBar: AppBar(
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
      ),
      backgroundColor: kPrimaryLightColorHomePageBackground,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(7),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: kPrimaryLightColor,
              ),
              child: TextField(
                controller: _identifier,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.add_card,
                    color: kPrimary,
                    size: 30,
                  ),
                  hintText: 'Identifier',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(7),
                  decoration: const BoxDecoration(
                    color: kPrimaryLightColor,
                  ),
                  child: DropdownButton(
                    value: _defaultValue,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        _defaultValue = newValue;
                      });
                    },
                    items: constantIdentifierTypes.map((identifierType) {
                      return DropdownMenuItem(
                        child: Text(identifierType["identifier_type"]),
                        value: identifierType["identifier_type"],
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  // width: size.width * 0.8,
                  padding: const EdgeInsets.all(7),
                  color: kPrimary,
                  child: FlatButton(
                    onPressed: () {
                      String identifier = _identifier.text;
                      String identifierType = _defaultValue;
                      addidentifierToDB(identifier, identifierType, context);
                    },
                    child: const Text(
                      'add identifier',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: size.height * 0.6,
              margin: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: constantIdentifiers.length,
                itemBuilder: (context, int index) {
                  //getIdentifierAndTypes(context);
                  return IdentifierListTile(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  addidentifierToDB(String identifier, String identifierType, context) async {

    if (identifier == ""){
      var snackBar = const SnackBar(
        content: Text(
          'IDENTIFIER CAN\'T BE EMPTY',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 204, 204),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    var body = {
      "user_id": USERID,
      "identifier_type": identifierType,
      "identifier": identifier,
    };

    var response = await http.post(
      Uri.parse("http://10.0.2.2:8081/sky-auth/identifier"),
      headers: {"access_token": ACCESSTOKEN},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var snackBar = const SnackBar(
        content: Text(
          'IDENTIFIER ADDED',
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
      });
    }
  }
  void getIdentifierAndTypes(context) async {
    var responseIdentifiers = await http.get(
        Uri.parse("http://10.0.2.2:8081/sky-auth/identifier"),
        headers: {"access_token": ACCESSTOKEN});

    var responseIdentifierTypes = await http.get(
        Uri.parse('http://10.0.2.2:8081/sky-auth/identifier_type'),
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
}


