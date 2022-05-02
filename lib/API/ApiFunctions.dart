import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_auth/constants.dart';
import 'package:crypto/crypto.dart';
import 'dart:collection';

confirmIdentifier(identifier, identifierType, text) async {
  var body = {
    "identifier": identifier,
    "identifier_type": identifierType,
    "user_id": USERID,
    "token": text,
  };

  var response = await http.post(
    Uri.parse("http://$ipAddress:8081/sky-auth/identifier/confirm_identifier"),
    body: jsonEncode(body),
    headers: {"access_token": ACCESSTOKEN},
  );
  if (response.statusCode == 200) {
    individualIdentifier = identifier;
    Fluttertoast.showToast(
        msg: "Identifier confirmed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 75, 181, 67),
        textColor: Colors.white,
        fontSize: 14.0);
    await getProgramsForIdentifier();
    await getIdentifierAndTypes();
    await getStatusCodes();
    return;
  }

  Fluttertoast.showToast(
      msg: "Invalid token",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0);
}

getProgramsForIdentifier() async {
  var body = {"user_id": USERID};

  try {
    var response = await http.post(
      Uri.parse(
          "http://$ipAddress:8081/sky-auth/programs/user/identifier/programs"),
      body: jsonEncode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 400) {
        programIDs = jsonDecode(response.body);

        try {
          for (int i = 0; i < programIDs.length; i++) {
            programStatus.add({
              "program_id": programIDs[i]["program_id"],
              "status": programIDs[i]["status"]
            });
          }

        }catch(e){
          programIDs = null;
        }
    }
  } catch (e) {
    Fluttertoast.showToast(
        msg: "Something went wrong. Try again later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}

deleteIdentifier(var identifierType, var identifier, context) async {
  var body = {
    "user_id": USERID,
    "identifier_type": identifierType,
    "identifier": identifier
  };

  try {
    var response = await http.post(
      Uri.parse("http://$ipAddress:8081/sky-auth/identifier/delete"),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {

      individualIdentifier = "";
      await getStatusCodes();
      Fluttertoast.showToast(
          msg: "Identifier deleted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 75, 181, 67),
          textColor: Colors.white,
          fontSize: 14.0);
    } else {}
  } catch (e) {
    Fluttertoast.showToast(
        msg: "Something went wrong. Try again later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}

authenticate(var programName) async {
  var identifier_type;
  for (int i = 0; i < constantIdentifiers.length; i++) {
    if (constantIdentifiers[i]["identifier"] == individualIdentifier) {
      identifier_type = constantIdentifiers[i]["identifier_type"];
    }
  }

  var progID;
  for (int i = 0; i < programs.length; i++) {
    if (programs[i]["program_name"] == programName) {
      progID = programs[i]["program_id"];
    }
  }

  Map<String, dynamic> body = {
    "identifier": individualIdentifier,
    "identifier_type": identifier_type,
    "program_id": progID
  };
  var response = await http.post(
    Uri.parse(
        "http://$ipAddress:8081/sky-auth/authorization/biometric/code_confirmation"),
    headers: {"access_token": ACCESSTOKEN},
    body: jsonEncode(body),
  );
  if (response.statusCode == 200) {
    Fluttertoast.showToast(
        msg: "Authentication successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 75, 181, 67),
        textColor: Colors.white,
        fontSize: 14.0);
  } else {
    Fluttertoast.showToast(
        msg: "Please use provided code",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}

addIdentifierToDB(String identifier, String identifierType) async {
  if (identifier == null || identifier == "") {
    Fluttertoast.showToast(
        msg: "Identifier can't be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0);
    getIdentifierAndTypes();
    return;
  }
  var body = {
    "user_id": USERID,
    "identifier_type": identifierType,
    "identifier": identifier,
  };

  var response = await http.post(
    Uri.parse("http://$ipAddress:8081/sky-auth/identifier"),
    headers: {"access_token": ACCESSTOKEN},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    individualIdentifier = identifier;
    Fluttertoast.showToast(
        msg: "Identifier added",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 75, 181, 67),
        textColor: Colors.white,
        fontSize: 14.0);
    await getIdentifierAndTypes();
  } else if (response.statusCode == 400) {
    Fluttertoast.showToast(
        msg: "Identifier already exists",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0);
  } else {
    Fluttertoast.showToast(
        msg: "Something went wrong. Tyr again later ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}

void LoginToApp(var name, var pass, var context) async {
  String password = pass;
  String username = name;

  var bytes = utf8.encode(password);
  var usernameBytes = utf8.encode(username);

  var hashedPasswordString = sha256.convert(bytes).toString();
  var hashedPasswordBytes = utf8.encode(hashedPasswordString);

  var auth = sha256.convert(usernameBytes + hashedPasswordBytes).toString();

  Map<String, String> headerValues = {
    'auth': auth,
  };

  final response = await http.post(
    Uri.parse('http://$ipAddress:8081/sky-auth/authorization/login?username=' +
        username),
    headers: headerValues,
  );

  if (response.statusCode == 200) {
    LinkedHashMap<String, dynamic> responseBody = jsonDecode(response.body);

    String accessToken = responseBody['access_token'];
    // ignore: non_constant_identifier_names
    int user_id = responseBody['user_id'];

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', responseBody['user_id'].toString());
    prefs.setString('ip_address', responseBody['ip_address']);
    prefs.setString('username', username);
    prefs.setString('access_token', accessToken);

    ACCESSTOKEN = accessToken;
    USERID = user_id;
    USERNAME = username;
    INITIALS = "${USERNAME[0]}${USERNAME[1]}";

    await getIdentifierAndTypes();
    await getPrograms(context);
    await getStatusCodes();

    Navigator.pushReplacementNamed(context, '/homePage');

    Fluttertoast.showToast(
        msg: "Login successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 75, 181, 67),
        textColor: Colors.white,
        fontSize: 14.0);
  } else {
    Fluttertoast.showToast(
        msg: "INVALID CREDENTIALS",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}

Future<int> getIdentifierAndTypes() async {
  var body = {"user_id": USERID};

  var responseIdentifiers = await http.post(
      Uri.parse("http://$ipAddress:8081/sky-auth/identifier/get"),
      headers: {"access_token": ACCESSTOKEN},
      body: jsonEncode(body));
  var responseIdentifierTypes = await http.get(
      Uri.parse('http://$ipAddress:8081/sky-auth/identifier_type'),
      headers: {"access_token": ACCESSTOKEN});
  try {
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
      try {
        individualIdentifier = constantIdentifiers[0]["identifier"];
      } catch (e) {}
    }
  } catch (e) {
    Fluttertoast.showToast(
        msg: "Something went wrong. Try again later",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  return 1;
}

Future<int> getPrograms(var context) async {
  var programsFromDB;

  var response = await http.get(
    Uri.parse("http://$ipAddress:8081/sky-auth/programs"),
    headers: {"access_token": ACCESSTOKEN},
  );

  programsFromDB = jsonDecode(response.body);
 try{
   programs = programsFromDB;
 }catch(e){
   Navigator.of(context).pushReplacementNamed('/login');
 }
  return 1;
}

Future<int> getStatusCodes() async {
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
  return 1;
}

signUp(String fName, String lName, String uName, String natID, String pass,
    context) async {
  try {
    if (fName == "" ||
        lName == "" ||
        uName == "" ||
        natID == "" ||
        pass == "") {
      Fluttertoast.showToast(
          msg: "Please fill in all fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
      return;
    }

    Map<String, dynamic> userSignupDetails = {
      'first_name': fName,
      'last_name': lName,
      'username': uName,
      'national_id': int.parse(natID),
      'password': pass,
      'user_type': 'MEMBER',
    };

    var response = await http.post(
        Uri.parse("http://$ipAddress:8081/sky-auth/users"),
        body: json.encode(userSignupDetails));

    LinkedHashMap<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Sing up successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 75, 181, 67),
          textColor: Colors.white,
          fontSize: 14.0);
      LoginToApp(uName, pass, context);
    } else {
      context.loaderOverlay.hide();
      Fluttertoast.showToast(
          msg: responseBody.values.first,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 255, 148, 148),
          textColor: Colors.white,
          fontSize: 14.0);
      return;
    }
  } catch (exception) {
    context.loaderOverlay.hide();
    Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 255, 148, 148),
        textColor: Colors.white,
        fontSize: 14.0);
  }
}

deleteProgram(identifier, progid) async {
  var body = {
    "user_id": USERID,
    "identifier": identifier,
    "program_id": progid
  };

  try {
    var response = await http.post(
        Uri.parse("http://$ipAddress:8081/sky-auth/programs/remove"),
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      return;
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
