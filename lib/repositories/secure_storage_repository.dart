import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class SecureStorageRepository {
  Future<void> savePin({required String value});

  Future<String?> getPin();

  Future<bool> isPinAvailable();

  Future<void> clearPin();
}

class SecureStorageRepositoryImpl implements SecureStorageRepository {
  SecureStorageRepositoryImpl({required FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();
  final FlutterSecureStorage _storage;

  static const _pinKey = 'user_pin';

  @override
  Future<String?> getPin() {
    return _storage.read(key: _pinKey);
  }

  @override
  Future<bool> isPinAvailable() async {
    final pin = await _storage.read(key: _pinKey);
    return pin != null && pin.isNotEmpty;
  }

  @override
  Future<void> savePin({required String value}) {
    return _storage.write(key: _pinKey, value: value);
  }

  @override
  Future<void> clearPin() {
    return _storage.deleteAll();
  }
}
