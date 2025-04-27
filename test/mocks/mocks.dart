import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/types/auth_messages_ios.dart';
import 'package:local_auth_windows/types/auth_messages_windows.dart';
import 'package:secure_snap/models/photo_dto.dart';
import 'package:secure_snap/repositories/biometric_repository.dart';
import 'package:secure_snap/repositories/photo_repository.dart';
import 'package:secure_snap/repositories/secure_storage_repository.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

const pin = '123456';
const key = 'user_pin';

class MockSecureStorage extends Fake implements FlutterSecureStorage {
  bool shouldPinBeAvailable = true;

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions = IOSOptions.defaultOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
  }) async {
    if (key == key) {
      return Future.value();
    }
  }

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions = IOSOptions.defaultOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
  }) async {
    if (shouldPinBeAvailable) {
      return key == key ? pin : null;
    }
    return null;
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions = IOSOptions.defaultOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
  }) async {
    if (key == key) {
      return Future.value();
    }
    throw Exception('Key not found');
  }
}

class MockPhotoRepository extends Fake implements PhotoRepository {
  bool shouldEmitPhotos = true;
  bool shouldThrowSavePhotoException = false;

  @override
  Future<int> save(PhotoDto photoEntity) async {
    if (shouldThrowSavePhotoException) {
      throw Exception();
    }
    return Future.value(1);
  }

  @override
  Stream<List<PhotoDto?>> watch() {
    return Stream.value(
      shouldEmitPhotos
          ? [
            PhotoDto(
              filePath: '/dummy/path.jpg',
              createdAt: DateTime.now(),
              id: 1,
            ),
          ]
          : [],
    );
  }
}

class MockSecureStorageRepository extends Fake
    implements SecureStorageRepository {
  bool shouldPinBeAvailable = true;

  @override
  savePin({required String value}) async {
    // Mock implementation
  }

  @override
  Future<String?> getPin() async {
    return shouldPinBeAvailable ? '1234' : null;
  }

  @override
  Future<bool> isPinAvailable() async {
    return shouldPinBeAvailable;
  }

  @override
  Future<void> clearPin() async {
    return Future.value();
  }
}

class MockBiometricRepository extends Fake implements BiometricRepository {
  bool shouldThrowPlatformException = false;
  bool shouldAuthenticate = true;

  @override
  Future<bool> authenticate() async {
    if (shouldThrowPlatformException) {
      throw PlatformException(code: auth_error.notAvailable);
    }
    return shouldAuthenticate;
  }
}

class MockLocalAuthentication extends Fake implements LocalAuthentication {
  bool shouldThrowPlatformException = false;
  bool shouldAuthenticate = true;

  @override
  Future<bool> authenticate({
    required String localizedReason,
    Iterable<AuthMessages> authMessages = const <AuthMessages>[
      IOSAuthMessages(),
      AndroidAuthMessages(),
      WindowsAuthMessages(),
    ],
    AuthenticationOptions options = const AuthenticationOptions(),
  }) {
    if (shouldThrowPlatformException) {
      throw PlatformException(code: auth_error.notAvailable);
    }
    return Future.value(shouldAuthenticate);
  }
}
