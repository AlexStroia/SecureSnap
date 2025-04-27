import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_snap/database/database.dart';
import 'package:secure_snap/models/photo_dto.dart';
import 'package:secure_snap/repositories/photo_repository.dart';
import '../flutter_test_config.dart';
import '../utils/test_dependency_context.dart';

const MethodChannel pathProviderChannel = MethodChannel(
  'plugins.flutter.io/path_provider',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'getApplicationDocumentsDirectory') {
              final directory = await Directory.systemTemp.createTemp(
                'app_doc_dir',
              );
              return directory.path;
            }
            return null;
          },
        );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
  });
  group(PhotoRepository, () {
    PhotoRepository setupRepository(
      TestDependencyContext testDependencyContext,
    ) {
      return PhotoRepositoryImpl(database: testDependencyContext());
    }

    group('save', () {
      testWithDependencies(
        'Should save photo with success when save is called',
        (testDependencyContext) async {
          final sut = setupRepository(testDependencyContext);
          final tempDir = Directory.systemTemp.createTempSync();
          final tempFile = File('${tempDir.path}/temp_photo.jpg');
          await tempFile.writeAsBytes([0, 1, 2, 3]);

          await sut.save(
            PhotoDto(filePath: tempFile.path, createdAt: DateTime.now()),
          );

          final database = testDependencyContext.database;
          final photos = await database.select(database.photo).get();

          expect(photos.length, 1);
          expect(photos.first.filePath, isNotEmpty);
          expect(photos.first.createdAt, isNotNull);

          await tempDir.delete(recursive: true);
        },
      );
    });

    group('getPhoto', () {
      testWithDependencies(
        'should return correct photo when getPhoto is called ',
        (testDependencyContext) async {
          final database = testDependencyContext.database;
          final id = 1;
          final insertedId = await database
              .into(database.photo)
              .insert(
                PhotoCompanion.insert(
                  id: drift.Value(id),
                  filePath: 'test/path.jpg',
                  createdAt: drift.Value(DateTime(2024, 1, 1)),
                ),
              );

          final sut = setupRepository(testDependencyContext);
          final photoDto = await sut.getPhoto(insertedId);

          expect(photoDto.id, insertedId);
          expect(photoDto.filePath, 'test/path.jpg');
          expect(photoDto.createdAt, DateTime(2024, 1, 1));
        },
      );
    });

    group('watch', () {
      testWithDependencies(
        'should return a  non empty list of photos after inserting in the database when watch is called',
        (testDependencyContext) async {
          final sut = setupRepository(testDependencyContext);
          final tempDir = Directory.systemTemp.createTempSync();
          final tempFile = File('${tempDir.path}/temp_photo.jpg');
          await tempFile.writeAsBytes([0, 1, 2, 3]);

          await sut.save(
            PhotoDto(filePath: tempFile.path, createdAt: DateTime.now()),
          );
          await tempDir.delete(recursive: true);

          final photoList = await sut.watch().first;
          expect(photoList, isNotEmpty);
        },
      );
    });
  });
}
