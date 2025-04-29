import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

abstract interface class BiometricRepository {
  Future<bool> authenticate();
}

class FakeBiometricRepositoryImpl implements BiometricRepository {
  @override
  Future<bool> authenticate() async {
    return true;
  }
}

class RealBiometricRepositoryImpl implements BiometricRepository {
  RealBiometricRepositoryImpl({required LocalAuthentication localAuth})
    : _localAuth = localAuth;

  final LocalAuthentication _localAuth;

  @override
  Future<bool> authenticate() async {
    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate',

        options: AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: false,
        ),
      );
      return didAuthenticate;
    } on PlatformException {
      rethrow;
    }
  }
}
