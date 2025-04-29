import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:secure_snap/repositories/biometric_repository.dart';
import '../flutter_test_config.dart';
import '../utils/test_dependency_context.dart';

void main() {
  group(BiometricRepository, () {
    BiometricRepository setupRepository(
      TestDependencyContext testDependencyContext,
    ) {
      return RealBiometricRepositoryImpl(
        localAuth: testDependencyContext.localAuth,
      );
    }

    group('authenticate', () {
      testWithDependencies(('should return true when authenticate is called'), (
        testDependencyContext,
      ) async {
        final sut = setupRepository(testDependencyContext);

        final result = await sut.authenticate();
        expect(result, isTrue);
      });

      testWithDependencies(
        ('should return false when authenticate is called'),
        (testDependencyContext) async {
          testDependencyContext.localAuth.shouldAuthenticate = false;
          final sut = setupRepository(testDependencyContext);
          final result = await sut.authenticate();

          expect(result, isFalse);
        },
      );

      testWithDependencies(
        ('should throw PlatformException when authenticate is called'),
        (testDependencyContext) async {
          testDependencyContext.localAuth.shouldThrowPlatformException = true;
          final sut = setupRepository(testDependencyContext);

          expect(() => sut.authenticate(), throwsA(isA<PlatformException>()));
        },
      );
    });
  });
}
