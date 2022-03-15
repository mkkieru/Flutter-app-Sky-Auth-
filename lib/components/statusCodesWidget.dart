
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import 'package:sky_auth/constants.dart';

class StatusCodeWidget extends StatefulWidget {
  StatusCodeWidget(this.programName, this.timeToLive, this.authCode);

  var programName;
  var timeToLive;
  var authCode;

  @override
  State<StatusCodeWidget> createState() => _StatusCodeWidgetState();
}

class _StatusCodeWidgetState extends State<StatusCodeWidget> {

  var controller;

  @override
  void initState() {
    super.initState();
    controller = CountdownTimerController(
      endTime: widget.timeToLive,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        // leading: Text(
        //   widget.timeToLive.toString(),
        //   style: const TextStyle(
        //     fontSize: 30,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        leading: CountdownTimer(
          controller: controller,
          endTime: widget.timeToLive,
          widgetBuilder: (_, CurrentRemainingTime? time) {
            if (time == null) {
              return const Text(
                "0",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
            return Text(
              "$time.sec",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            );
          },
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
            fontSize: 18,
          ),
        ),
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
    );
  }
}
