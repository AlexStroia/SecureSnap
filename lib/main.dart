import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secure_snap/repositories/biometric_repository.dart';
import 'package:secure_snap/service/photo_selection_service.dart';

import 'app.dart';
import 'database/database.dart';
import 'di.dart';

bool get isIntegrationTest =>
    Platform.environment.containsKey('INTEGRATION_TEST');

PhotoPickerService? photoPickerService;
BiometricRepository? biometricRepository;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  dependencyContext.getIt.registerSingletonAsync<Database>(
    () => Database.create(),
    dispose: (db) => db.close(),
  );

  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  if (!isIntegrationTest) {
    await ensureDriftBackgrounded();
  }

  /// Wait for all dependencies to be ready before we start the app,
  /// including ensuring that our user data is warmed up.
  await dependencyContext.allReady();

  runApp(SecureSnapApp(photoPickerService: photoPickerService));
}

@visibleForTesting
class SecureSnapApp extends StatelessWidget {
  final PhotoPickerService? photoPickerService;

  const SecureSnapApp({this.photoPickerService, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PhotoPickerService>(
          create: (_) => photoPickerService ?? RealPhotoPickerServiceImpl(),
        ),
      ],
      child: const SecureSnapMobile(),
    );
  }
}
