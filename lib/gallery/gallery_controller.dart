import 'dart:async';

import 'package:flutter/services.dart';
import 'package:secure_snap/models/photo_dto.dart';
import 'package:secure_snap/repositories/biometric_repository.dart';
import 'package:secure_snap/utils/controller.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import '../repositories/photo_repository.dart';

sealed class GalleryControllerEvent implements OneTimeEvent {
  const GalleryControllerEvent();
}

class PhotoReadExceptionEvent extends GalleryControllerEvent {
  const PhotoReadExceptionEvent();
}

class BiometricAuthenticationException extends GalleryControllerEvent {
  const BiometricAuthenticationException();
}

class BiometricNotAvailableException extends GalleryControllerEvent {
  const BiometricNotAvailableException();
}

class GalleryController extends Controller {
  GalleryController({
    required PhotoRepository photoRepository,
    required BiometricRepository biometricRepository,
  }) : _biometricRepository = biometricRepository,
       _photoRepository = photoRepository {
    _photosSubscription = _photoRepository.watch().listen(_onPhotosUpdate);
  }

  final PhotoRepository _photoRepository;
  final BiometricRepository _biometricRepository;

  StreamSubscription<List<PhotoDto?>?>? _photosSubscription;

  List<PhotoDto> _photos = [];

  List<PhotoDto> get photos => _photos;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> attemptAuthenticateWithBiometrics() async {
    _isLoading = true;
    tryNotifyListeners();
    try {
      final authenticated = await _biometricRepository.authenticate();
      if (authenticated == false) {
        event = BiometricAuthenticationException();
        tryNotifyListeners();
      }
      tryNotifyListeners();
    } on PlatformException catch (error) {
      if (error.code == auth_error.notAvailable ||
          error.code == auth_error.notEnrolled) {
        event = BiometricNotAvailableException();
        tryNotifyListeners();
      }
    }
    _isLoading = false;
    tryNotifyListeners();
  }

  Future<void> _onPhotosUpdate(List<PhotoDto?> event) async {
    try {
      _photos = event.nonNulls.toList();
    } catch (error) {
      this.event = const PhotoReadExceptionEvent();
      tryNotifyListeners();
    }
  }

  @override
  dispose() {
    _photosSubscription?.cancel();
    super.dispose();
  }
}
