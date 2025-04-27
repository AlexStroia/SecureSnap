import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secure_snap/models/photo_dto.dart';
import 'package:secure_snap/repositories/mappers.dart';

import '../database/database.dart';

class PhotoFileNotFoundException implements Exception {
  PhotoFileNotFoundException();
}

abstract interface class PhotoRepository {
  Future<PhotoDto> getPhoto(int id);

  Future<int> save(PhotoDto photoEntity);

  Stream<List<PhotoDto?>> watch();
}

class PhotoRepositoryImpl implements PhotoRepository {
  final Database _database;

  const PhotoRepositoryImpl({required Database database})
    : _database = database;

  @override
  Future<int> save(PhotoDto photoDto) async {
    final safePhotoDto = await _moveImageToPermanentLocation(photoDto);
    return _database.photo.insertOne(
      PhotoCompanion.insert(
        filePath: safePhotoDto.filePath,
        createdAt: Value(safePhotoDto.createdAt),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Moves the image from a temporary location (e.g., image_picker's /tmp folder)
  /// to a permanent and private directory within the app's sandbox.
  /// This is essential for security and reliability:
  /// - Prevents loss of image due to OS cleanup of temp files
  /// - Ensures image is stored in a location not accessible by other apps or users
  /// - Keeps sensitive content hidden from system galleries or file browsers
  /// - Supports app-level protection (e.g., Face ID) by storing images privately
  /// Read more on https://pub.dev/documentation/path_provider/latest/path_provider/getApplicationDocumentsDirectory.html
  Future<PhotoDto> _moveImageToPermanentLocation(PhotoDto dto) async {
    final tempFile = File(dto.filePath);

    if (!await tempFile.exists()) {
      throw PhotoFileNotFoundException();
    }

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final newFilePath = '${appDir.path}/$fileName';

    final savedFile = await tempFile.copy(newFilePath);

    return dto.copyWith(filePath: savedFile.path);
  }

  @override
  Stream<List<PhotoDto?>> watch() {
    return _database.select(_database.photo).watch().map<List<PhotoDto?>>((
      entity,
    ) {
      try {
        return entity.map((photoData) {
          return photoData.mapped;
        }).toList();
      } catch (e) {
        rethrow;
      }
    });
  }

  @override
  Future<PhotoDto> getPhoto(int id) async {
    final query = _database.select(_database.photo)
      ..where((table) => table.id.equals(id));
    final photo = await query.getSingle();
    return photo.mapped;
  }
}
