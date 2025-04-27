import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:secure_snap/database/database.dart';
import 'package:secure_snap/di.dart';
import 'package:leak_tracker_flutter_testing/leak_tracker_flutter_testing.dart';
import 'package:test_api/scaffolding.dart' as test_package;

import 'utils/test_dependency_context.dart';

//Potential fix for goldens to move controller in the go router ...

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Setup BEFORE all tests
  TestWidgetsFlutterBinding.ensureInitialized();
  await ensureDriftBackgrounded(); // <- Add this line to start the Drift isolate!

  await createTestDependencyContext();

  // Now actually run the test files
  await testMain();

  // Teardown AFTER all tests
  await dependencyContext.dispose();
}

@isTest
void testWidgetsWithDependencies(
  String description,
  Future<void> Function(
    WidgetTester tester,
    TestDependencyContext testDependencyContext,
  )
  testOp, {
  bool? skip,
  test_package.Timeout? timeout,
  bool semanticsEnabled = true,
  TestVariant<Object?> variant = const DefaultTestVariant(),
  dynamic tags,
  int? retry,
  LeakTesting? experimentalLeakTesting,
}) {
  return testWidgets(
    description,
    (WidgetTester tester) async {
      final testDependencyContext = await createTestDependencyContext();

      await testOp(tester, testDependencyContext);
    },
    skip: skip,
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
    retry: retry,
    experimentalLeakTesting: experimentalLeakTesting,
  );
}

@isTest
void testWithDependencies(
  String description,
  FutureOr<void> Function(TestDependencyContext testDependencyContext) testOp, {
  bool prefetchData = true,
  bool connectDevice = false,
  bool authorizeUser = true,
  String? testOn,
  Timeout? timeout,
  dynamic skip,
  dynamic tags,
  Map<String, dynamic>? onPlatform,
  int? retry,
}) {
  return test(
    description,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
    () async {
      final testDependencyContext = await createTestDependencyContext();

      await testOp(testDependencyContext);
    },
  );
}
