import 'package:drift/drift.dart';

class Photo extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get filePath => text()(); // Path to saved image
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
