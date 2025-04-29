import 'package:flutter_test/flutter_test.dart';
import 'package:secure_snap/gallery/gallery_controller.dart';
import '../flutter_test_config.dart';
import '../utils/test_dependency_context.dart';

void main() {
  group(GalleryController, () {
    GalleryController setupController(
      TestDependencyContext testDependencyContext,
    ) {
      return GalleryController(
        photoRepository: testDependencyContext.photoRepository,
        biometricRepository: testDependencyContext.biometricRepository,
      ).ensureDisposed();
    }

    group('watch', () {
      testWithDependencies(('should emit photos'), (
        testDependencyContext,
      ) async {
        final sut = setupController(testDependencyContext);
        await pumpEventQueue(times: 2);

        expect(sut.photos, isNotEmpty);
      });

      testWithDependencies(
        'should emit empty list when no photos are available',
        (testDependencyContext) async {
          testDependencyContext.photoRepository.shouldEmitPhotos = false;
          final sut = setupController(testDependencyContext);
          await pumpEventQueue(times: 2);

          expect(sut.photos, isEmpty);
        },
      );
    });

    group('attemptAuthenticateWithBiometrics', () {
      testWithDependencies('should authenticate successfully', (
        testDependencyContext,
      ) async {
        final sut = setupController(testDependencyContext);

        await sut.attemptAuthenticateWithBiometrics();

        expect(sut.isLoading, isFalse);
      });

      testWithDependencies(
        'should not authenticate and throw BiometricNotAvailableException',
        (testDependencyContext) async {
          testDependencyContext
              .biometricRepository
              .shouldThrowPlatformException = true;
          final sut = setupController(testDependencyContext);

          await sut.attemptAuthenticateWithBiometrics();

          expect(
            sut.removeEvent(),
            isInstanceOf<BiometricNotAvailableException>(),
          );
        },
      );
    });
  });
}
