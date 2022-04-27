// ignore_for_file: file_names, prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'package:permission_handler/permission_handler.dart';

import 'package:sky_auth/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sky_auth/local_auth_api.dart';

import '../API/ApiFunctions.dart';

class StatusCodeWidget extends StatefulWidget {
  StatusCodeWidget(this.programName, this.timeToLive, this.authCode, {Key? key})
      : super(key: key);

  var programName;
  var timeToLive;
  var authCode;

  @override
  State<StatusCodeWidget> createState() => _StatusCodeWidgetState();
}

class _StatusCodeWidgetState extends State<StatusCodeWidget>
    with TickerProviderStateMixin {
  var timer;
  var angle = 0;
  var controllerValue;
  var visibility = false;
  var notSet = true;

  late AnimationController controller;

  void setAnimationController() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.timeToLive),
    );
  }

  void startTimer() {
    timer = Timer(const Duration(seconds: 1), () async {
      if (mounted) {
        if (widget.timeToLive <= 0) {
          await getThisStatusCode();
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
  void initState() {
    setAnimationController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    setAnimationController();
    startTimer();
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: ListTile(
            leading: Text(
              widget.timeToLive.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            // leading: CircularProgressIndicator(
            //   value: controller.value,
            // ),
            title: SizedBox(
              //width: size.width * 0.6,
              child: Text(
                widget.authCode,
                maxLines: 2,
                style: const TextStyle(
                  //fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
            trailing: SizedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.programName,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Transform.rotate(
                    angle: angle * 3.142 / 180,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        size: 25,
                      ),
                      onPressed: () {
                        if (angle == 0) {
                          timer.cancel();
                          setState(() {
                            angle = 180;
                            visibility = true;
                          });
                        } else if (angle == 180) {
                          timer.cancel();
                          setState(() {
                            angle = 0;
                            visibility = false;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            onLongPress: () {
              Clipboard.setData(
                ClipboardData(text: widget.authCode),
              );
              Fluttertoast.showToast(
                  msg: "Code copied",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color.fromARGB(255, 75, 181, 67),
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
            onTap: () {
              if (angle == 0) {
                timer.cancel();
                setState(() {
                  angle = 180;
                  visibility = true;
                });
              } else if (angle == 180) {
                timer.cancel();
                setState(() {
                  angle = 0;
                  visibility = false;
                });
              }
            },
          ),
        ),
        Visibility(
          visible: visibility,
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        scan();
                      },
                      icon: const Icon(Icons.qr_code),
                      iconSize: 30,
                    ),
                    const Text(
                      "Scan QR",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        try {
                          final isAuthenticated =
                              await LocalAuthApi.authenticate();
                          if (isAuthenticated) {
                            await authenticate(widget.programName);
                          }
                          if (!isAuthenticated) {
                            Fluttertoast.showToast(
                                msg: "Biometric not registered on device ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: "Please use code for authentication",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          return;
                        }
                      },
                      icon: const Icon(Icons.fingerprint),
                      iconSize: 30,
                    ),
                    const Text(
                      "use biometric",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: widget.authCode),
                        );
                        Fluttertoast.showToast(
                            msg: "Code copied",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor:
                                const Color.fromARGB(255, 75, 181, 67),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      icon: const Icon(Icons.copy),
                      iconSize: 30,
                    ),
                    const Text(
                      "copy code",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(
          thickness: 2,
        ),
      ],
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
      Uri.parse("http://$ipAddress:8081/sky-auth/auth_details/specific"),
      headers: {"access_token": ACCESSTOKEN},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      for (int i = 0; i < authCodes.length; i++) {
        if (authCodes[i]["program_id"] == id &&
            authCodes[i]["identifier"] == individualIdentifier) {
          var newAuthdetails = jsonDecode(response.body);
          print(newAuthdetails);

          if (newAuthdetails != null) {
            setState(() {
              widget.timeToLive = newAuthdetails["time_to_live"] -
                  newAuthdetails["age"]["wholeSeconds"] -
                  1;
              widget.authCode = newAuthdetails["auth_code"];
            });
          }
          authCodes.removeAt(i);
          authCodes.add(jsonDecode(response.body));
          break;
        }
      }
    } else {
      Navigator.of(context).pushReplacementNamed("/login");
    }
  }

  scan() async {
    var status = await Permission.camera.request();

    if (status.isGranted) {
      // Either the permission was already granted before or the user just granted it.
      var cameraScanResult = await scanner.scan();
      Map qrData = jsonDecode(cameraScanResult!);

      qrData.remove("auth_code");

      var response = await http.post(
        Uri.parse(
            "http://$ipAddress:8081/sky-auth/authorization/biometric/code_confirmation"),
        headers: {"access_token": ACCESSTOKEN},
        body: jsonEncode(qrData),
      );
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Authentication successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromARGB(255, 75, 181, 67),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Authentication failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
    } else {
      Fluttertoast.showToast(
          msg: "Unknown QR code",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
  }
}
