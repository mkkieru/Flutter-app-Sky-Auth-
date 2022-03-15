// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sky_auth/components/companyDropDownButtun.dart';
import 'package:sky_auth/components/homePageStatusCodesList.dart';
import 'package:sky_auth/constants.dart';
import 'components/drawerWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: const [
          CompanyDropDownButton(),
        ],
      ),
      backgroundColor: kPrimaryLightColorHomePageBackground,
      body:const HomepageStatusCodesList(),
    );
  }
}
