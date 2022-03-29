import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print("LocalAuthApi: $e");
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      // List<BiometricType> available_biometrics =
      //     await _auth.getAvailableBiometrics();
      //
      // if (available_biometrics.contains(BiometricType.face)) {
      //   print("yes it contains ... ");
      // }

      if (Platform.isIOS) {
        return await _auth.authenticateWithBiometrics(
          iOSAuthStrings: const IOSAuthMessages(
            localizedFallbackTitle: "Fingerprint required for authentication"
          ),
          localizedReason: 'Scan fingerprint to Authenticate',
          useErrorDialogs: false,
          stickyAuth: false,
        );
      } else {
        return await _auth.authenticateWithBiometrics(
          androidAuthStrings: const AndroidAuthMessages(
            signInTitle: 'Fingerprint Required',
          ),
          localizedReason: 'Scan fingerprint to Authenticate',
          useErrorDialogs: false,
          stickyAuth: false,
        );
      }
    } on PlatformException catch (e) {
      print("Authenticate: $e");
      return false;
    }
  }
}
