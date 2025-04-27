import 'package:flutter/services.dart';
import 'package:secure_snap/models/photo_dto.dart';
import 'package:secure_snap/repositories/photo_repository.dart';
import 'package:secure_snap/repositories/secure_storage_repository.dart';

import '../repositories/biometric_repository.dart';
import '../utils/controller.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

sealed class HomeControllerEvent implements OneTimeEvent {
  const HomeControllerEvent();
}

class PhotoSavedEvent extends HomeControllerEvent {
  const PhotoSavedEvent();
}

class BiometricAuthenticationException extends HomeControllerEvent {
  const BiometricAuthenticationException();
}

class BiometricNotAvailableException extends HomeControllerEvent {
  const BiometricNotAvailableException();
}

class PinAvailable extends HomeControllerEvent {
  const PinAvailable();
}

//TODO CHECK WITH EXCEPTIONS
class PhotoSavingException extends HomeControllerEvent {
  const PhotoSavingException();
}

class HomeController extends Controller {
  HomeController({
    required PhotoRepository photoRepository,
    required BiometricRepository biometricRepository,
    required SecureStorageRepository secureStorageRepository,
  }) : _photoRepository = photoRepository,
       _biometricRepository = biometricRepository,
       _secureStorageRepository = secureStorageRepository;

  final PhotoRepository _photoRepository;
  final BiometricRepository _biometricRepository;
  final SecureStorageRepository _secureStorageRepository;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> savePhoto(String imagePath) async {
    final biometricResult = await _attemptAuthenticateWithBiometrics();
    if (!biometricResult) {
      return;
    }

    _isLoading = true;
    tryNotifyListeners();

    try {
      await _photoRepository.save(
        PhotoDto(filePath: imagePath, createdAt: DateTime.now()),
      );
      event = const PhotoSavedEvent();
      tryNotifyListeners();
    } catch (e) {
      event = PhotoSavingException();
      tryNotifyListeners();
    }

    _isLoading = false;
    tryNotifyListeners();
  }

  Future<bool> _attemptAuthenticateWithBiometrics() async {
    try {
      final authenticate = await _biometricRepository.authenticate();
      if (authenticate == false) {
        event = BiometricAuthenticationException();
        tryNotifyListeners();
        return false;
      }
      return true;
    } on PlatformException catch (error) {
      final isPinAvailable = await _secureStorageRepository.isPinAvailable();
      if (isPinAvailable) {
        event = const PinAvailable();
        tryNotifyListeners();
        return false;
      }

      if (error.code == auth_error.notAvailable ||
          error.code == auth_error.notEnrolled) {
        event = BiometricNotAvailableException();
        tryNotifyListeners();
        return false;
      }
    }
    return false;
  }
}
