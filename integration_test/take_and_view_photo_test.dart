import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:secure_snap/main.dart' as app;
import 'package:secure_snap/service/photo_selection_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    app.photoPickerService = FakePhotoPickerServiceImpl();
    app.isIntegrationTest = true;
  });

  testWidgets('should take a photo and view it in the gallery', (
    WidgetTester tester,
  ) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    final takePhotoButton = find.byKey(const Key('camera_button'));
    expect(takePhotoButton, findsOneWidget);
    await tester.tap(takePhotoButton);
    await tester.pumpAndSettle();

    final cameraTakePhotoButton = find.byKey(const Key('camera_take_photo'));
    expect(cameraTakePhotoButton, findsOneWidget);
    await tester.tap(cameraTakePhotoButton);
    await tester.pumpAndSettle();

    final cameraSavePhotoButton = find.byKey(const Key('save_photo'));
    expect(cameraSavePhotoButton, findsOneWidget);
    await tester.tap(cameraSavePhotoButton);
    await tester.pumpAndSettle();

    final cameraSavePhotoYesButton = find.byKey(const Key('save_photo_yes'));
    expect(cameraSavePhotoYesButton, findsOneWidget);
    await tester.tap(cameraSavePhotoYesButton);
    await tester.pumpAndSettle();

    final galleryButton = find.byKey(const Key('gallery_button'));
    expect(galleryButton, findsOneWidget);
    await tester.tap(galleryButton);
    await tester.pumpAndSettle();

    final galleryGridView = find.byKey(const Key('gallery_grid_view'));
    expect(galleryGridView, findsOneWidget);

    final photoTile = find.descendant(
      of: galleryGridView,
      matching: find.byKey(const Key('photo_tile')),
    );
    expect(photoTile, findsWidgets);
  });
}
