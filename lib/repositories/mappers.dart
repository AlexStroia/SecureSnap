import 'package:secure_snap/database/database.dart';

import '../models/photo_dto.dart';

extension PhotoDataMapper on PhotoData {
  PhotoDto get mapped {
    return PhotoDto(filePath: filePath, createdAt: createdAt, id: id);
  }
}
