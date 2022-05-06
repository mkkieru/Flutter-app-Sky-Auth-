// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, duplicate_ignore

import 'package:flutter/material.dart';

//const ipAddress = "192.168.100.100";
//const ipAddress = "172.20.106.107";
//const ipAddress = "10.0.2.2";
const ipAddress = "85.159.214.103";

const kPrimary = Color.fromARGB(255,21,57,128);
const kPrimaryLightColor = Color.fromARGB(255,0,167,225);
const kPrimaryLightColorHomePageBackground = Color(0xFFDFDFEA);
// ignore: prefer_typing_uninitialized_variables

var defaultValue;
var show = false;


var ACCESSTOKEN;
int USERID = 0;

var programStatus = [];
var programIDs;
var USERNAME;
var INITIALS;

var authCodes = [];

var individualIdentifier = "";

List programs = [
  {"program_name": "AIRTEL"},
];

List constantIdentifierTypes = [
  {
    "identifier_type": "MSISDN",
    "date_created": "2022-02-03 05:34:23.0",
    "date_updated": "2022-02-03 05:34:26.0"
  },
  {
    "identifier_type": "mail",
    "date_created": "2022-02-04 07:25:19.686",
    "date_updated": "2022-02-04 07:25:19.686"
  }
];

List constantIdentifiers = [
  {"Message": "No records found"},
];
