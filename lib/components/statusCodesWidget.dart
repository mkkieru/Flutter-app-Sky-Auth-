// ignore_for_file: file_names, prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sky_auth/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sky_auth/local_auth_api.dart';

class StatusCodeWidget extends StatefulWidget {
  StatusCodeWidget(this.programName, this.timeToLive, this.authCode, {Key? key})
      : super(key: key);

  var programName;
  var timeToLive;
  var authCode;

  @override
  State<StatusCodeWidget> createState() => _StatusCodeWidgetState();
}

class _StatusCodeWidgetState extends State<StatusCodeWidget> {
  var timer;

  void startTimer() {
    timer = Timer(const Duration(seconds: 1), () {
      if(mounted) {
        if (widget.timeToLive == 0) {
          getThisStatusCode();
        } else {
          setState(() {
            widget.timeToLive = widget.timeToLive - 1;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    startTimer();
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Card(
        child: ListTile(
          leading: Text(
            widget.timeToLive.toString(),
            style: const TextStyle(
              fontSize: 25,
              color: kPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          title: Text(
            widget.authCode,
            style: const TextStyle(
              fontSize: 30,
              color: kPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          trailing: Text(
            widget.programName,
            style: const TextStyle(
              color: kPrimary,
              fontSize: 15,
            ),
          ),
          onTap: () async {
            final isAuthenticated = await LocalAuthApi.authenticate();
            if (isAuthenticated) {
              await authenticate();
            }
            if (!isAuthenticated) {
              var snackBar = const SnackBar(
                content: Text(
                  'Fingerprint not registered',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                backgroundColor: Color.fromARGB(255, 255, 204, 204),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          onLongPress: () {
            Clipboard.setData(
              ClipboardData(text: widget.authCode),
            );
            const snackBar = SnackBar(
              backgroundColor: Color.fromARGB(255, 75, 181, 67),
              content: Text(
                'Code Copied',
                style: TextStyle(fontSize: 20),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),
      ),
    );
  }

  getThisStatusCode() async {
    var id;

    for (int i = 0; i < programs.length; i++) {
      if (programs[i]["program_name"] == widget.programName) {
        id = programs[i]["program_id"];
        break;
      }
    }
    var body = {
      "user_id": USERID,
      "identifier": individualIdentifier,
      "program_id": id,
    };

    var response = await http.post(
      Uri.parse("http://85.159.214.103:8081/sky-auth/auth_details/specific"),
      headers: {"access_token": ACCESSTOKEN},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      for (int i = 0; i < authCodes.length; i++) {
        if (authCodes[i]["program_id"] == id &&
            authCodes[i]["identifier"] == individualIdentifier) {
          var newAuthdetails = jsonDecode(response.body);

          setState(() {
            widget.timeToLive = newAuthdetails["time_to_live"] -
                newAuthdetails["age"]["wholeSeconds"];
            //widget.timeToLive = newAuthdetails["time_to_live"];
            widget.authCode = newAuthdetails["auth_code"];
          });

          authCodes.removeAt(i);
          authCodes.add(jsonDecode(response.body));
          break;
        }
      }
    } else {
      Navigator.of(context).pushReplacementNamed("/login");
    }
  }

  authenticate() async {
    var identifier_type;
    for (int i = 0; i < constantIdentifiers.length; i++) {
      if (constantIdentifiers[i]["identifier"] == individualIdentifier) {
        identifier_type = constantIdentifiers[i]["identifier_type"];
      }
    }

    var progID;
    for (int i = 0; i < programs.length; i++) {
      if (programs[i]["program_name"] == widget.programName) {
        progID = programs[i]["program_id"];
      }
    }

    Map<String, dynamic> body = {
      "identifier": individualIdentifier,
      "identifier_type": identifier_type,
      "program_id": progID
    };

    print(individualIdentifier);
    print(identifier_type);
    print(progID);

    var response = await http.post(
      Uri.parse(
          "http://85.159.214.103:8081/sky-auth/authorization/biometric/code_confirmation"),
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      var snackBar = const SnackBar(
        content: Text(
          'AUTHENTICATION SUCCESSFUL',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 75, 181, 67),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      var snackBar = const SnackBar(
        content: Text(
          'Please use code',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 204, 204),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
