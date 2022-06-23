import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
        return await _auth.authenticate(
          // authMessages: const IOSAuthMessages(
          //     localizedFallbackTitle: "Biometric required for authentication"),
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: false,
            sensitiveTransaction: true,
            biometricOnly: false,
          ),
          localizedReason: 'Scan face or fingerprint to Authenticate',
        );
    } on PlatformException {
      return false;
    }
  }
}
