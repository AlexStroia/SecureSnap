import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart' hide Disposable;
import 'package:local_auth/local_auth.dart';
import 'package:secure_snap/repositories/biometric_repository.dart';
import 'package:secure_snap/repositories/photo_repository.dart';
import 'package:secure_snap/utils/disposable.dart';

import 'database/database.dart';

@protected
@visibleForTesting
DependencyContext Function() dependencyContextProvider =
    () => DependencyContext._shared;

DependencyContext get dependencyContext => dependencyContextProvider();

class DependencyContext implements Disposable {
  DependencyContext();

  static final _shared = DependencyContext();

  final getIt = GetIt.instance;

  // ignore: unreachable_from_main
  T call<T extends Object>({
    String? instanceName,
    Object? param1,
    Object? param2,
    Type? type,
  }) {
    return getIt<T>(
      instanceName: instanceName,
      param1: param1,
      param2: param2,
      type: type,
    );
  }

  Future<void> allReady() {
    _register();
    return getIt.allReady();
  }

  GetIt _register() {
    getIt
      ..registerLazySingleton<LocalAuthentication>(() => LocalAuthentication())
      ..registerLazySingleton<PhotoRepository>(
        () => PhotoRepositoryImpl(database: getIt<Database>()),
      )
      ..registerLazySingleton<BiometricRepository>(
        () => RealBiometricRepositoryImpl(localAuth: getIt()),
      );

    return getIt;
  }

  @override
  @visibleForTesting
  Future<void> dispose() async {
    await getIt.reset();
  }
}
