import 'package:flutter_test/flutter_test.dart';
import 'package:secure_snap/home/home_controller.dart';
import '../flutter_test_config.dart';
import '../utils/test_dependency_context.dart';

void main() {
  group(HomeController, () {
    HomeController setupController(
      TestDependencyContext testDependencyContext,
    ) {
      return HomeController(
        photoRepository: testDependencyContext.photoRepository,
        biometricRepository: testDependencyContext.biometricRepository,
      ).ensureDisposed();
    }

    group('savePhoto', () {
      testWithDependencies('should save photo successfully', (
        testDependencyContext,
      ) async {
        final sut = setupController(testDependencyContext);
        final imagePath = 'test_image_path';

        await sut.savePhoto(imagePath);

        expect(sut.isLoading, isFalse);
        expect(sut.removeEvent(), isInstanceOf<PhotoSavedEvent>());
      });
    });

    testWithDependencies('should throw error when saving a photo', (
      testDependencyContext,
    ) async {
      testDependencyContext.photoRepository.shouldThrowSavePhotoException =
          true;
      final sut = setupController(testDependencyContext);
      final imagePath = 'test_image_path';

      await sut.savePhoto(imagePath);

      expect(sut.isLoading, isFalse);
      expect(sut.removeEvent(), isInstanceOf<PhotoSavingException>());
    });

    testWithDependencies(
      'should throw BiometricAuthenticationException when user is not authenticated with biometrics',
      (testDependencyContext) async {
        testDependencyContext.biometricRepository.shouldAuthenticate = false;
        final sut = setupController(testDependencyContext);
        final imagePath = 'test_image_path';

        await sut.savePhoto(imagePath);

        expect(sut.isLoading, isFalse);
        expect(
          sut.removeEvent(),
          isInstanceOf<BiometricAuthenticationException>(),
        );
      },
    );

    testWithDependencies(
      'should return BiometricNotAvailableException when PlatformException is thrown',
      (testDependencyContext) async {
        testDependencyContext.biometricRepository.shouldThrowPlatformException =
            true;
        final sut = setupController(testDependencyContext);
        final imagePath = 'test_image_path';

        await sut.savePhoto(imagePath);

        expect(sut.isLoading, isFalse);
        expect(
          sut.removeEvent(),
          isInstanceOf<BiometricNotAvailableException>(),
        );
      },
    );
  });
}
