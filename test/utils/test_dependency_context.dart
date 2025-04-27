import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_snap/database/database.dart';
import 'package:secure_snap/di.dart';
import 'package:secure_snap/utils/disposable.dart';

import '../mocks/mocks.dart';

Future<TestDependencyContext> createTestDependencyContext() async {
  final testDependencyContext = TestDependencyContext();

  final getIt = testDependencyContext.getIt;

  getIt
    ..allowReassignment = true
    ..registerLazySingleton<Database>(
      () => Database(LazyDatabase(NativeDatabase.memory)),
    )
    ..registerLazySingleton<MockLocalAuthentication>(
      () => MockLocalAuthentication(),
    )
    ..registerLazySingleton<MockSecureStorageRepository>(
      () => MockSecureStorageRepository(),
    )
    ..registerLazySingleton<MockPhotoRepository>(() => MockPhotoRepository())
    ..registerLazySingleton<MockBiometricRepository>(
      () => MockBiometricRepository(),
    )
    ..registerLazySingleton<MockSecureStorage>(() => MockSecureStorage());

  await getIt.allReady();

  return testDependencyContext;
}

class TestDependencyContext extends DependencyContext {
  Database get database => this();

  MockSecureStorage get secureStorage => this();

  MockPhotoRepository get photoRepository => this();

  MockBiometricRepository get biometricRepository => this();

  MockLocalAuthentication get localAuth => this();

  MockSecureStorageRepository get secureStorageRepository => this();
}

extension DisposableTestExt<T extends Disposable> on T {
  T ensureDisposed() {
    addTearDown(dispose);

    return this;
  }
}
