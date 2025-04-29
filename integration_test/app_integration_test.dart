import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:drift/drift.dart' as drift;
import 'package:secure_snap/database/database.dart';
import 'package:secure_snap/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel localAuthChannel = MethodChannel(
    'plugins.flutter.io/local_auth',
  );

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(localAuthChannel, (
          MethodCall methodCall,
        ) async {
          switch (methodCall.method) {
            case 'authenticate':
              return true;
            case 'getAvailableBiometrics':
              return ['fingerprint'];
            case 'isDeviceSupported':
            case 'canCheckBiometrics':
              return true;
            default:
              return null;
          }
        });
  });

  testWidgets('should take a photo and view it in the gallery', (
    WidgetTester tester,
  ) async {
    final db = app.dependency.getIt<Database>();
    await db
        .into(db.photo)
        .insert(
          PhotoCompanion.insert(
            id: drift.Value(1),
            filePath: 'test/path.jpg',
            createdAt: drift.Value(DateTime(2024, 1, 1)),
          ),
        );

    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

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

    final photoTile = find.descendant(
      of: galleryGridView,
      matching: find.byKey(const Key('photo_tile')),
    );
    expect(photoTile, findsOneWidget);
  });

  testWidgets('should view no data view when no image is taken', (
    WidgetTester tester,
  ) async {
    final db = app.dependency.getIt<Database>();
    await db
        .into(db.photo)
        .insert(
          PhotoCompanion.insert(
            id: drift.Value(1),
            filePath: 'test/path.jpg',
            createdAt: drift.Value(DateTime(2024, 1, 1)),
          ),
        );

    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

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

    final noDataView = find.byKey(const Key('no_data_view'));
    expect(noDataView, findsOneWidget);
  });
}
