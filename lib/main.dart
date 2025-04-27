import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'database/database.dart';
import 'di.dart';


DependencyContext dependency = dependencyContext;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  await ensureDriftBackgrounded();

  /// Wait for all dependencies to be ready before we start the app,
  /// including ensuring that our user data is warmed up.
  await dependency.allReady();

  runApp(const SecureSnapMobile());
}
