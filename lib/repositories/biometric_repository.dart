import 'dart:io';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

abstract interface class BiometricRepository {
  Future<bool> authenticate();
}

bool get isIntegrationTest => Platform.environment.containsKey('FLUTTER_TEST');

class BiometricRepositoryImpl implements BiometricRepository {
  BiometricRepositoryImpl({required LocalAuthentication localAuth})
    : _localAuth = localAuth;

  final LocalAuthentication _localAuth;

  @override
  Future<bool> authenticate() async {
    try {
      if (isIntegrationTest) {
        return true;
      }
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate',

        options: AuthenticationOptions(useErrorDialogs: true),
      );
      return didAuthenticate;
    } on PlatformException {
      rethrow;
    }
  }
}
