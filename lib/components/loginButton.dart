// ignore_for_file: must_be_immutable, file_names, deprecated_member_use

import 'package:flutter/material.dart';

import '../constants.dart';

class LoginButton extends StatelessWidget {
  
  Widget child;
  Function onPressed;

  LoginButton({Key? key, required this.child, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.7,
      padding: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: FlatButton(
          padding: const EdgeInsets.symmetric(vertical:13, horizontal: 40),
          onPressed: (){onPressed();},
          color: kPrimary,
          child: child,
        ),
      ),
    );
  }
}
