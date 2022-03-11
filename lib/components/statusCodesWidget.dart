import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sky_auth/constants.dart';
class StatusCodeWidget extends StatelessWidget {
  StatusCodeWidget({Key? key}) : super(key: key);

  var seconds = 60;
  var statusCode = '303030';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: kPrimaryLightColor,
        child: ListTile(
          leading: Text(
            '$seconds',
            style: const TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
          title: Text(
            statusCode,
            style: const TextStyle(
              fontSize: 30,
              color: kPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          trailing: const Text(
            'Company name',
            style: TextStyle(
              color: kPrimary,
              fontSize: 18,
            ),
          ),
          onLongPress: () {
            Clipboard.setData(
              ClipboardData(text: statusCode),
            );
            const snackBar = SnackBar(
                backgroundColor: Color.fromARGB(255, 75, 181, 67),
                content: Text(
                  'Code Copied',
                  style: TextStyle(fontSize: 20),
                ));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),
      ),
    );
  }
}
