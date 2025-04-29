import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'package:secure_snap/database/tables.dart';
import 'package:sqlite3/sqlite3.dart';

import '../main.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Photo])
class Database extends _$Database {
  Database([QueryExecutor? database])
    : super(database ?? openDriftIsolateConnection());

  static Future<Database> create() async {
    if (isIntegrationTest) {
      return Database(openTestConnection());
    }

    final password = await _getOrCreateEncryptionKey();
    final executor = await _openEncryptedDb(password);
    return Database(executor);
  }

  Future<void> clearData() async {
    await customStatement('PRAGMA foreign_keys = OFF');
    try {
      await batch((batch) => allTables.forEach(batch.deleteAll));
    } finally {
      await customStatement('PRAGMA foreign_keys = ON');
    }
  }

  @override
  int get schemaVersion => 1;
}

QueryExecutor openDriftNativeConnection() {
  return LazyDatabase(() async {
    /// Android does not by default set a temporary directory to overflow
    /// complex queries into, so set it.
    if (Platform.isAndroid) {
      final tempDir = await getTemporaryDirectory();
      sqlite3.tempDirectory = tempDir.path;
    }

    final password = await _getOrCreateEncryptionKey();
    final executor = await _openEncryptedDb(password);
    return executor;
  });
}

/// Securely store or retrieve the encryption key
Future<String> _getOrCreateEncryptionKey() async {
  final storage = FlutterSecureStorage();
  String? key = await storage.read(key: 'db_key');
  if (key == null) {
    final random = Random.secure();
    final newKey = List<int>.generate(32, (_) => random.nextInt(256));
    key = base64UrlEncode(newKey);
    await storage.write(key: 'db_key', value: key);
  }
  return key;
}

/// Opens the encrypted database using Drift + sqlite3
Future<QueryExecutor> _openEncryptedDb(String password) async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, 'encrypted.sqlite'));

  // Optional: Set temp directory on Android
  if (Platform.isAndroid) {
    final tempDir = await getTemporaryDirectory();
    sqlite.sqlite3.tempDirectory = tempDir.path;
  }

  final sqlite.Database rawDb = sqlite.sqlite3.open(file.path);
  rawDb.execute("PRAGMA key = '$password';");

  return NativeDatabase.opened(rawDb);
}

const driftIsolateServerName = 'drift_isolate';

QueryExecutor openDriftIsolateConnection() {
  return DatabaseConnection.delayed(
    Future.sync(() async {
      final port = IsolateNameServer.lookupPortByName(driftIsolateServerName);
      if (port == null) {
        throw Exception('Tried connecting to Drift isolate, but none exist.');
      }

      return DriftIsolate.fromConnectPort(port).connect();
    }),
  );
}

QueryExecutor openTestConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'integration_test.db'));
    return NativeDatabase(file, logStatements: true);
  });
}

Future<void> ensureDriftBackgrounded() async {
  final existingIsolate = IsolateNameServer.lookupPortByName(
    driftIsolateServerName,
  );
  if (existingIsolate != null) {
    /// If we already have an isolate running Drift, reuse that, assuming
    /// our current isolate was destroyed and is being reconstructed.
    if (!kDebugMode) {
      return;
    }

    /// ... Unless we're debug mode, in which we have to make a compromise.
    ///
    /// We don't tear down the Drift isolate in production, because it's likely
    /// that isolate is still doing work connected to some other Isolate
    /// processing data. It needs to stay!
    ///
    /// But that operational mode does not work when a developer hot-restarts
    /// the application. That Isolate gets zombified. It no longer functions,
    /// so our compomise here is to always remove that existing isolate and
    /// rebuild it, but only in debug mode.
    IsolateNameServer.removePortNameMapping(driftIsolateServerName);

    /// removePortNameMapping can race with other isolates, so for safety's
    /// sake, introduce a delay here.
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  final token = RootIsolateToken.instance!;
  final isolate = await DriftIsolate.spawn(() {
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);
    return openDriftNativeConnection();
  }, serialize: true);

  IsolateNameServer.registerPortWithName(
    isolate.connectPort,
    driftIsolateServerName,
  );
}
