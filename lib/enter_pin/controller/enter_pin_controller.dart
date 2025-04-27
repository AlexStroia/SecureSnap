import 'package:secure_snap/utils/controller.dart';

import '../../database/database.dart';
import '../../repositories/secure_storage_repository.dart';

sealed class EnterPinEvent implements OneTimeEvent {
  const EnterPinEvent();
}

class PinCorrect extends EnterPinEvent {
  const PinCorrect();
}

class PinIncorrect extends EnterPinEvent {
  const PinIncorrect();
}

class PinNotAvailable extends EnterPinEvent {
  const PinNotAvailable();
}

class PinBlocked extends EnterPinEvent {
  const PinBlocked();
}

class EnterPinController extends Controller {
  EnterPinController({
    required SecureStorageRepository secureStorageRepository,
    required Database database,
  }) : _secureStorageRepository = secureStorageRepository,
       _database = database;

  final SecureStorageRepository _secureStorageRepository;
  final Database _database;
  var _pinAttemptsLeft = 3;

  int get pinAttempts => _pinAttemptsLeft;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> checkPinAvailability() async {
    _isLoading = true;
    tryNotifyListeners();

    final isPinAvailable = await _isPinAvailable();
    if (!isPinAvailable) {
      event = PinNotAvailable();
    }

    _isLoading = false;
    tryNotifyListeners();
  }

  Future<bool> _isPinAvailable() async {
    final isPinAvailable = await _secureStorageRepository.isPinAvailable();
    return isPinAvailable;
  }

  Future<void> checkPin(String pin) async {
    _isLoading = true;
    tryNotifyListeners();

    final savedPin = await _secureStorageRepository.getPin();
    final isPinAvailable = await _isPinAvailable();

    if (!isPinAvailable || savedPin == null) {
      event = PinNotAvailable();
      tryNotifyListeners();
      return;
    }

    if (pin == savedPin) {
      event = PinCorrect();
    } else {
      event = PinIncorrect();
      _pinAttemptsLeft--;
      if (_pinAttemptsLeft == 0) {
        event = PinBlocked();
        await _clearData();
      }
    }

    _isLoading = false;
    tryNotifyListeners();
  }

  Future<void> _clearData() async =>
      [_database.clearData(), _secureStorageRepository.clearPin()].wait;
}
