import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

abstract class PhotoPickerService {
  Future<XFile?> pickImage(bool fromCamera);
}

class RealPhotoPickerServiceImpl implements PhotoPickerService {
  @override
  Future<XFile?> pickImage(bool fromCamera) {
    return ImagePicker().pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 35,
    );
  }
}

class FakePhotoPickerServiceImpl implements PhotoPickerService {
  @override
  Future<XFile?> pickImage(bool fromCamera) async {
    final byteData = await rootBundle.load('assets/images/test_image.jpeg');
    final dir = await Directory.systemTemp.createTemp('test_images');
    final file = File('${dir.path}/photo.jpg');
    await file.writeAsBytes(byteData.buffer.asUint8List());

    return XFile(file.path);
  }
}
