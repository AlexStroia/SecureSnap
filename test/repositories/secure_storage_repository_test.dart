import 'package:flutter_test/flutter_test.dart';
import 'package:secure_snap/repositories/secure_storage_repository.dart';
import '../flutter_test_config.dart';
import '../mocks/mocks.dart';
import '../utils/test_dependency_context.dart';

void main() {
  group(SecureStorageRepository, () {
    SecureStorageRepository setupRepository(
      TestDependencyContext testDependencyContext,
    ) {
      return SecureStorageRepositoryImpl(
        storage: testDependencyContext.secureStorage,
      );
    }

    group('getPin', () {
      testWithDependencies('should return pin when getPin is called', (
        testDependencyContext,
      ) async {
        final sut = setupRepository(testDependencyContext);

        final result = await sut.getPin();

        expect(result, pin);
      });
    });

    group('savePin', () {
      testWithDependencies('should save pin when savePin is called', (
        testDependencyContext,
      ) async {
        final sut = setupRepository(testDependencyContext);

        await sut.savePin(value: pin);

        final result = await sut.getPin();

        expect(result, pin);
      });
    });

    group('isPinAvailable', () {
      testWithDependencies('should return true when isPinAvailable is called', (
        testDependencyContext,
      ) async {
        final sut = setupRepository(testDependencyContext);

        final result = await sut.isPinAvailable();

        expect(result, isTrue);
      });

      testWithDependencies('should return true when isPinAvailable is called', (
        testDependencyContext,
      ) async {
        testDependencyContext.secureStorage.shouldPinBeAvailable = false;
        final sut = setupRepository(testDependencyContext);

        final result = await sut.isPinAvailable();

        expect(result, isFalse);
      });
    });
  });
}
