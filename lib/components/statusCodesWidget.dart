// ignore_for_file: file_names, prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sky_auth/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sky_auth/local_auth_api.dart';

import '../API/ApiFunctions.dart';

class StatusCodeWidget extends StatefulWidget {
  StatusCodeWidget(this.programName, this.timeRemaining, this.timeToLive,
      this.authCode, this.identifier,
      {Key? key})
      : super(key: key);

  var programName;
  var timeRemaining;
  var timeToLive;
  var authCode;
  var identifier;

  @override
  State<StatusCodeWidget> createState() => _StatusCodeWidgetState();
}

class _StatusCodeWidgetState extends State<StatusCodeWidget> {
  final ValueNotifier<bool> _visibility = ValueNotifier(false);
  final ValueNotifier<bool> _authcodeVisibility = ValueNotifier(false);
  final ValueNotifier<bool> _angleChanged = ValueNotifier(false);
  final ValueNotifier<bool> _almostTimeOut = ValueNotifier(false);

  var timer;
  var isDarkMode;
  late int _duration = widget.timeRemaining;

  void startTimer() {
    timer = Timer(const Duration(seconds: 1), () async {
      if (mounted) {
        if (_duration <= 0) {
          await getThisStatusCode();
        } else {
          if (_duration <= 10) {
            _almostTimeOut.value = true;
          }
          setState(() {
            _duration = _duration - 1;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    var brightness = SchedulerBinding.instance!.window.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    Color COLOR = Colors.white24;
    if (isDarkMode) {
      COLOR = Colors.black12;
    }
    startTimer();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        //   child: ListTile(
        //     leading: Transform(
        //       alignment: Alignment.center,
        //       transform: Matrix4.rotationY(3.14159),
        //       child: CircularPercentIndicator(
        //         radius: 25,
        //         lineWidth: 3.0,
        //         percent: ((_duration / widget.timeToLive)),
        //         center: Transform(
        //           alignment: Alignment.center,
        //           transform: Matrix4.rotationY(3.14159),
        //           child: Text(_duration.toString()),
        //         ),
        //         progressColor: kPrimaryLightColor,
        //       ),
        //     ),
        //     title: SizedBox(
        //       //width: size.width * 0.6,
        //       child: Text(
        //         widget.authCode,
        //         maxLines: 2,
        //         style: const TextStyle(
        //           //fontSize: 28,
        //           fontWeight: FontWeight.bold,
        //           letterSpacing: 1,
        //         ),
        //       ),
        //     ),
        //     trailing: SizedBox(
        //       child: Row(
        //         mainAxisSize: MainAxisSize.min,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Text(
        //             widget.programName,
        //             style: const TextStyle(
        //               fontSize: 10,
        //             ),
        //           ),
        //           ValueListenableBuilder(
        //             valueListenable: _angleChanged,
        //             builder: (context, takenSurvey, child) {
        //               if (_angleChanged.value == false) {
        //                 return Transform.rotate(
        //                   angle: 0 * 3.142 / 180,
        //                   child: IconButton(
        //                     icon: const Icon(
        //                       Icons.arrow_drop_down,
        //                       size: 25,
        //                     ),
        //                     onPressed: () {
        //                       _visibility.value = true;
        //                       _angleChanged.value = true;
        //                     },
        //                   ),
        //                 );
        //               } else {
        //                 return Transform.rotate(
        //                   angle: 180 * 3.142 / 180,
        //                   child: IconButton(
        //                     icon: const Icon(
        //                       Icons.arrow_drop_down,
        //                       size: 25,
        //                     ),
        //                     onPressed: () {
        //                       _visibility.value = false;
        //                       _angleChanged.value = false;
        //                     },
        //                   ),
        //                 );
        //               }
        //             },
        //           ),
        //         ],
        //       ),
        //     ),
        //     onLongPress: () {
        //       Clipboard.setData(
        //         ClipboardData(text: widget.authCode),
        //       );
        //       Fluttertoast.showToast(
        //           msg: "Code copied",
        //           toastLength: Toast.LENGTH_SHORT,
        //           gravity: ToastGravity.BOTTOM,
        //           timeInSecForIosWeb: 1,
        //           backgroundColor: const Color.fromARGB(255, 75, 181, 67),
        //           textColor: Colors.white,
        //           fontSize: 16.0);
        //     },
        //     onTap: () {
        //       _visibility.value = !_visibility.value;
        //       _angleChanged.value = !_angleChanged.value;
        //     },
        //   ),
        // ),
        Container(
          //alignment: Alignment.topLeft,
          margin: const EdgeInsets.fromLTRB(18, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.programName + " (" + widget.identifier + ")",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _angleChanged,
                builder: (context, takenSurvey, child) {
                  if (_angleChanged.value == false) {
                    return Transform.rotate(
                      angle: 0 * 3.142 / 180,
                      // child: IconButton(
                      //   icon: const Icon(
                      //     Icons.keyboard_arrow_right_rounded,
                      //   ),
                      //   onPressed: () {
                      //     _visibility.value = true;
                      //     _angleChanged.value = true;
                      //   },
                      // ),
                      child: GestureDetector(
                        child: const Icon(
                          Icons.keyboard_arrow_right_rounded,
                        ),
                        onTap: () {
                          _visibility.value = true;
                          _angleChanged.value = true;
                        },
                      ),
                    );
                  } else {
                    return Transform.rotate(
                      angle: 180 * 3.142 / 180,
                      child: GestureDetector(
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                        ),
                        onTap: () {
                          _visibility.value = false;
                          _angleChanged.value = false;
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _authcodeVisibility,
          builder: (BuildContext context, bool value, Widget? child) {
            if (_authcodeVisibility.value == false) {
              return ValueListenableBuilder(
                valueListenable: _visibility,
                builder: (context, takenSurvey, child) {
                  if (_almostTimeOut.value == true) {
                    return ListTile(
                      trailing: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(3.14159),
                        child: CircularPercentIndicator(
                          radius: 15,
                          lineWidth: 15.0,
                          percent: ((_duration / widget.timeToLive)),
                          progressColor: Colors.red,
                          backgroundColor: COLOR,
                        ),
                      ),
                      leading: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: BlinkText(
                          widget.authCode,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                          endColor: Colors.red,
                        ),
                      ),
                      title: SizedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                _authcodeVisibility.value = true;
                              },
                              icon: const Icon(Icons.visibility_outlined,
                                  color: Colors.grey),
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
                            backgroundColor:
                                const Color.fromARGB(255, 75, 181, 67),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      onTap: () {
                        _visibility.value = !_visibility.value;
                        _angleChanged.value = !_angleChanged.value;
                      },
                    );
                  } else {
                    return ListTile(
                      leading: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: SizedBox(
                          //width: size.width * 0.6,
                          child: Text(
                            widget.authCode,
                            maxLines: 2,
                            style: const TextStyle(
                              color:kPrimary,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      title: SizedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                _authcodeVisibility.value = true;
                              },
                              icon: const Icon(
                                Icons.visibility_outlined,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(3.14159),
                        child: CircularPercentIndicator(
                          radius: 15,
                          lineWidth: 15.0,
                          percent: ((_duration / widget.timeToLive)),
                          progressColor: kPrimary,
                          backgroundColor: COLOR,
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
                            backgroundColor:
                                const Color.fromARGB(255, 75, 181, 67),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      onTap: () {
                        _visibility.value = !_visibility.value;
                        _angleChanged.value = !_angleChanged.value;
                      },
                    );
                  }
                },
              );
            } else {
              return ValueListenableBuilder(
                valueListenable: _visibility,
                builder: (context, takenSurvey, child) {
                  if (_almostTimeOut.value == true) {
                    return ListTile(
                      trailing: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(3.14159),
                        child: CircularPercentIndicator(
                          radius: 15,
                          lineWidth: 15.0,
                          percent: ((_duration / widget.timeToLive)),
                          progressColor: Colors.red,
                          backgroundColor: COLOR,
                        ),
                      ),
                      leading: BlinkText(
                        widget.authCode,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                        endColor: Colors.red,
                      ),
                      title: SizedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                _authcodeVisibility.value = false;
                              },
                              icon: const Icon(Icons.visibility_off_outlined,
                                  color: Colors.grey),
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
                            backgroundColor:
                                const Color.fromARGB(255, 75, 181, 67),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      onTap: () {
                        _visibility.value = !_visibility.value;
                        _angleChanged.value = !_angleChanged.value;
                      },
                    );
                  } else {
                    return ListTile(
                      trailing: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(3.14159),
                        child: CircularPercentIndicator(
                          radius: 15,
                          lineWidth: 15.0,
                          percent: ((_duration / widget.timeToLive)),
                          progressColor: kPrimary,
                          backgroundColor: COLOR,
                        ),
                      ),
                      leading: SizedBox(
                        //width: size.width * 0.6,
                        child: Text(
                          widget.authCode,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color:kPrimary,
                          ),
                        ),
                      ),
                      title: SizedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                _authcodeVisibility.value = false;
                              },
                              icon: const Icon(Icons.visibility_off_outlined,
                                  color: Colors.grey),
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
                            backgroundColor:
                                const Color.fromARGB(255, 75, 181, 67),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      onTap: () {
                        _visibility.value = !_visibility.value;
                        _angleChanged.value = !_angleChanged.value;
                      },
                    );
                  }
                },
              );
            }
          },
        ),
        ValueListenableBuilder(
          valueListenable: _visibility,
          builder: (context, takenSurvey, child) {
            if (_visibility.value == true) {
              return Visibility(
                visible: true,
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
                        width: MediaQuery.of(context).size.width * 0.05,
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
                                      msg:
                                          "Biometric not registered on device ",
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
                            "Use Biometric",
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
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
                            "Copy Code",
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Visibility(
                visible: false,
                child: SizedBox(),
              );
            }
          },
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
      "identifier": widget.identifier,
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
            authCodes[i]["identifier"] == widget.identifier) {
          var newAuthdetails = jsonDecode(response.body);
          if (newAuthdetails != null) {
            if (mounted) {
              setState(() {
                widget.timeRemaining = newAuthdetails["time_to_live"] -
                    newAuthdetails["age"]["wholeSeconds"] -
                    1;
                widget.authCode = newAuthdetails["auth_code"];
                widget.timeToLive = newAuthdetails["time_to_live"];
                _duration = newAuthdetails["time_to_live"] -
                    newAuthdetails["age"]["wholeSeconds"] -
                    1;
                _almostTimeOut.value = false;
              });
            }
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

      for (int i = 0; i < programs.length; i++) {
        if (programs[i]["program_id"] == qrData["program_id"]) {
          if (programs[i]["program_name"] == widget.programName &&
              qrData["identifier"] == widget.identifier) {
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
              return;
            } else {
              Fluttertoast.showToast(
                  msg: "Authentication failed",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            break;
          }
        }
      }

      Fluttertoast.showToast(
          msg: "Invalid QR code",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      Fluttertoast.showToast(
          msg: "Camera permission required",
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
// TODO: THIS IS THE CODE FOR BLINKING TEXT
/*
import 'package:blinking_text/blinking_text.dart';
child: BlinkText(
widget.authCode,
maxLines: 2,
style: const TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
letterSpacing: 1,
color:  Colors.white,
),
endColor: Colors.red,
),
*/
