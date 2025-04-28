import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:secure_snap/database/database.dart';
import 'package:secure_snap/main.dart' as app;

import '../test/flutter_test_config.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgetsWithDependencies(('user taps the camera button'), (
    tester,
    testDependencyContext,
  ) async {
    final database = testDependencyContext.database;
    testDependencyContext.localAuth.shouldAuthenticate = true;
    await database
        .into(database.photo)
        .insert(
          PhotoCompanion.insert(
            id: drift.Value(1),
            filePath: 'test/path.jpg',
            createdAt: drift.Value(DateTime(2024, 1, 1)),
          ),
        );

    app.dependency = testDependencyContext;
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    final takePhotoButton = find.byKey(const Key('camera_button'));
    expect(takePhotoButton, findsOneWidget);

    await tester.tap(takePhotoButton);

    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    final galleryButton = find.byKey(const Key('gallery_button'));
    expect(galleryButton, findsOneWidget);
    await tester.tap(galleryButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    final galleryGridView = find.byKey(const Key('gallery_grid_view'));
    expect(galleryGridView, findsOneWidget);
  });
}
