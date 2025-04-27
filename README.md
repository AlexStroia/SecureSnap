
---

# 📸 SecureSnap- Flutter Mobile App

---

## 📋 Objective
Create a Flutter application that allows users to:
- Capture photos using the device camera.
- Securely store captured photos using biometric authentication (Face ID, Touch ID, or fingerprint).
- View stored photos through a secure, authenticated gallery.

---

## ✨ Features
- 📷 **Capture Photos**: Seamlessly take photos with the device camera.
- 🔒 **Biometric Security**: Protect access to your images with biometric authentication.
- 🖼️ **Secure Gallery**: View all securely stored photos in a dedicated gallery screen.
- 📱 **Cross-Platform**: Fully functional on both **Android** and **iOS** devices.
- 🗂️ **Multiple Storage**: Supports capturing and saving multiple images.

---

## 🧩 Components
- **Button** to launch the camera and capture a photo.
- **Button** to open the gallery (secured with biometric authentication).
- **Gallery View** displaying all the securely stored images.

---

## 🚀 Getting Started

Follow these instructions to set up and run the project locally.

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable version)
- Android Studio / Xcode
- A device/emulator with camera support
- Enable biometrics on your test device/emulator

### Installation
```bash
git clone https://github.com/AlexStroia/SecureSnap
cd SecureSnap
flutter pub get
```

### Run the App
```bash
flutter run
```

---

## 🔍 Approach

- **Camera Functionality**: Utilized the `camera` plugin to implement photo capture.
- **Secure Storage**: Used `local_auth` for biometric authentication combined with secure local storage (`path_provider` + `sqflite` / `shared_preferences`) to safely save images.
- **Gallery View**: Built a simple, elegant gallery using `GridView` to display all authenticated images.
- **Biometric Security Layer**: Access to the gallery is protected by biometric authentication prompts on both Android and iOS.

---

## 📦 Packages Used
- [`image_picker`](https://pub.dev/packages/image_picker)
- [`local_auth`](https://pub.dev/packages/local_auth)
- [`path_provider`](https://pub.dev/packages/path_provider)
- [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage)
- [`sqlite3`](https://pub.dev/packages/sqlite3) - for simple storage
- [`drift`](https://pub.dev/packages/drift) - for simple storage

---

## 📱 Platform Support
| Platform | Status |
| :--- | :--- |
| Android | ✅ Fully Supported |
| iOS | ✅ Fully Supported |

---


## 🙌 Acknowledgements
Built with ❤️ using Flutter.
