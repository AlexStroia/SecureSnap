import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_snap/database/database.dart';
import 'package:secure_snap/di.dart';
import 'package:secure_snap/utils/disposable.dart';

import '../fakes/fakes.dart';

Future<TestDependencyContext> createTestDependencyContext() async {
  final testDependencyContext = TestDependencyContext();

  final getIt = testDependencyContext.getIt;

  getIt
    ..allowReassignment = true
    ..registerLazySingleton<Database>(
      () => Database(LazyDatabase(NativeDatabase.memory)),
    )
    ..registerLazySingleton<FakeLocalAuthentication>(
      () => FakeLocalAuthentication(),
    )
    ..registerLazySingleton<FakePhotoRepository>(() => FakePhotoRepository())
    ..registerLazySingleton<FakeBiometricRepository>(
      () => FakeBiometricRepository(),
    );

  await getIt.allReady();

  return testDependencyContext;
}

class TestDependencyContext extends DependencyContext {
  Database get database => this();

  FakePhotoRepository get photoRepository => this();

  FakeBiometricRepository get biometricRepository => this();

  FakeLocalAuthentication get localAuth => this();
}

extension DisposableTestExt<T extends Disposable> on T {
  T ensureDisposed() {
    addTearDown(dispose);

    return this;
  }
}
