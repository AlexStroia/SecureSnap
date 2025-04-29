import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:secure_snap/database/database.dart';
import 'package:secure_snap/di.dart';
import 'utils/test_dependency_context.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Setup BEFORE all tests
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  await ensureDriftBackgrounded(); // <- Add this line to start the Drift isolate!

  await createTestDependencyContext();

  // Now actually run the test files
  await testMain();

  // Teardown AFTER all tests
  await dependencyContext.dispose();
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
