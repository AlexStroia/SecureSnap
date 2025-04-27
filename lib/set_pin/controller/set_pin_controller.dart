import 'package:secure_snap/utils/controller.dart';

import '../../repositories/biometric_repository.dart';
import '../../repositories/secure_storage_repository.dart';

sealed class SetPinEvent implements OneTimeEvent {
  const SetPinEvent();
}

class PinSaveException extends SetPinEvent {
  const PinSaveException();
}

class PinSaveSuccess extends SetPinEvent {
  const PinSaveSuccess();
}

class SetPinController extends Controller {
  SetPinController({
    required this.secureStorageRepository,
    required this.biometricService,
  });

  final SecureStorageRepository secureStorageRepository;
  final BiometricRepository biometricService;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> savePin(String pin) async {
    _isLoading = true;
    tryNotifyListeners();
    try {
      await secureStorageRepository.savePin(value: pin);
      event = PinSaveSuccess();
    } catch (e) {
      event = PinSaveException();
    }
    _isLoading = false;
    tryNotifyListeners();
  }
}
