// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get secure_snap => 'Secure Snap';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get take_photo => 'Take Photo';

  @override
  String get save_photo => 'Save Photo';

  @override
  String get reject => 'Reject';

  @override
  String get photo_saved => 'Photo saved successfully';

  @override
  String get are_you_sure_save_photo =>
      'Are you sure you want to save this photo?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get photo_saving_exception =>
      'An error occurred while saving the photo. Please try again.';

  @override
  String get photo_reading_exception =>
      'An error occurred while reading photos.';

  @override
  String get no_data => 'No data available';

  @override
  String get biometric_exception =>
      'An error occurred while accessing biometric data. Please try again.';

  @override
  String get create_pin => 'Create your secure PIN';

  @override
  String get enter_pin => 'Enter PIN';

  @override
  String get general_error => 'An error occurred. Please try again.';

  @override
  String get save_photo_biometric_error =>
      'Unable to save photo. Biometric authentication is not available on this device. Please enable it from settings.';

  @override
  String get view_photo_biometric_error =>
      'Viewing photos is not available. Biometric authentication is not available on this device. Please enable it from settings.';
}
