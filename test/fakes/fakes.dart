import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/types/auth_messages_ios.dart';
import 'package:local_auth_windows/types/auth_messages_windows.dart';
import 'package:secure_snap/models/photo_dto.dart';
import 'package:secure_snap/repositories/biometric_repository.dart';
import 'package:secure_snap/repositories/photo_repository.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class FakePhotoRepository extends Fake implements PhotoRepository {
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

class FakeBiometricRepository extends Fake implements BiometricRepository {
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

class FakeLocalAuthentication extends Fake implements LocalAuthentication {
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
