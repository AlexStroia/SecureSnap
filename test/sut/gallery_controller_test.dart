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
        secureStorageRepository: testDependencyContext.secureStorageRepository,
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
        expect(sut.authenticated, isTrue);
      });

      testWithDependencies(
        'should not authenticate and throw BiometricNotAvailableException',
        (testDependencyContext) async {
          testDependencyContext
              .biometricRepository
              .shouldThrowPlatformException = true;
          testDependencyContext.secureStorageRepository.shouldPinBeAvailable =
              false;
          final sut = setupController(testDependencyContext);

          await sut.attemptAuthenticateWithBiometrics();

          expect(sut.authenticated, isFalse);
          expect(
            sut.removeEvent(),
            isInstanceOf<BiometricNotAvailableException>(),
          );
        },
      );

      testWithDependencies(
        'should not authenticate and return PinAvailable event',
        (testDependencyContext) async {
          testDependencyContext
              .biometricRepository
              .shouldThrowPlatformException = true;
          testDependencyContext.secureStorageRepository.shouldPinBeAvailable =
              true;
          final sut = setupController(testDependencyContext);

          await sut.attemptAuthenticateWithBiometrics();

          expect(sut.authenticated, isFalse);
          expect(sut.removeEvent(), isInstanceOf<PinAvailable>());
        },
      );
    });
  });
}
