import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      print("Trying ...");
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      if (Platform.isIOS) {
        return await _auth.authenticate(
          biometricOnly: true,
          iOSAuthStrings: const IOSAuthMessages(
              localizedFallbackTitle: "Biometric required for authentication"
          ),
          localizedReason: 'Scan face or fingerprint to Authenticate',
          useErrorDialogs: false,
          stickyAuth: false,
        );
      } else {
        return await _auth.authenticate(
          biometricOnly: true,
          androidAuthStrings: const AndroidAuthMessages(
            signInTitle: 'Biometric Required',
          ),
          localizedReason: 'Scan face or fingerprint to Authenticate',
          useErrorDialogs: false,
          stickyAuth: false,
        );
      }
    } on PlatformException catch (e) {
      return false;
    }
  }
}
