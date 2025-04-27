import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @secure_snap.
  ///
  /// In en, this message translates to:
  /// **'Secure Snap'**
  String get secure_snap;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @take_photo.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get take_photo;

  /// No description provided for @save_photo.
  ///
  /// In en, this message translates to:
  /// **'Save Photo'**
  String get save_photo;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @photo_saved.
  ///
  /// In en, this message translates to:
  /// **'Photo saved successfully'**
  String get photo_saved;

  /// No description provided for @are_you_sure_save_photo.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to save this photo?'**
  String get are_you_sure_save_photo;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @photo_saving_exception.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while saving the photo. Please try again.'**
  String get photo_saving_exception;

  /// No description provided for @photo_reading_exception.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while reading photos.'**
  String get photo_reading_exception;

  /// No description provided for @no_data.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get no_data;

  /// No description provided for @biometric_exception.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while accessing biometric data. Please try again.'**
  String get biometric_exception;

  /// No description provided for @failed_to_save_pin.
  ///
  /// In en, this message translates to:
  /// **'Failed to save PIN'**
  String get failed_to_save_pin;

  /// No description provided for @pin_set_success.
  ///
  /// In en, this message translates to:
  /// **'PIN set successfully'**
  String get pin_set_success;

  /// No description provided for @set_pin_6_digits.
  ///
  /// In en, this message translates to:
  /// **'Set a 6-digit PIN'**
  String get set_pin_6_digits;

  /// No description provided for @pin_6_digits.
  ///
  /// In en, this message translates to:
  /// **'Pin should be at least 6 digits'**
  String get pin_6_digits;

  /// No description provided for @confirm_pin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirm_pin;

  /// No description provided for @pin_not_match.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pin_not_match;

  /// No description provided for @save_pin.
  ///
  /// In en, this message translates to:
  /// **'Save PIN'**
  String get save_pin;

  /// No description provided for @set_pin.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get set_pin;

  /// No description provided for @create_pin.
  ///
  /// In en, this message translates to:
  /// **'Create your secure PIN'**
  String get create_pin;

  /// No description provided for @enter_pin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enter_pin;

  /// No description provided for @general_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get general_error;

  /// No description provided for @biometric_not_available.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available on this device. Please use a PIN.'**
  String get biometric_not_available;

  /// No description provided for @pin_saved.
  ///
  /// In en, this message translates to:
  /// **'PIN saved successfully'**
  String get pin_saved;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @pin_incorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN. Please try again. {attempts} attempts left.'**
  String pin_incorrect(int attempts);

  /// No description provided for @pin_not_available.
  ///
  /// In en, this message translates to:
  /// **'PIN not available. Please set a new PIN.'**
  String get pin_not_available;

  /// No description provided for @pin_blocked.
  ///
  /// In en, this message translates to:
  /// **'PIN blocked. Logging you out'**
  String get pin_blocked;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return L10nEn();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
