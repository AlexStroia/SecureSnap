import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:secure_snap/main.dart' as app;

import '../test/flutter_test_config.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgetsWithDependencies(('user taps the camera button'), (
    tester,
    testDependencyContext,
  ) async {
    app.dependency = testDependencyContext;
    app.main();
    await tester.pumpAndSettle();

    final takePhotoButton = find.byKey(const Key('camera_button'));
    expect(takePhotoButton, findsOneWidget);
  });

  testWidgetsWithDependencies(('user taps the gallery button'), (
    tester,
    testDependencyContext,
  ) async {
    app.dependency = testDependencyContext;
    app.main();
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();

    final galleryButton = find.byKey(const Key('gallery_button'));
    expect(galleryButton, findsOneWidget);
  });
}
