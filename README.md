# 🔐 Flutter Biometric Auth Demo

This project demonstrates how to implement biometric authentication (Fingerprint & Face ID) in a Flutter application using `local_auth` and `flutter_secure_storage`. It also integrates Firebase Authentication for secure login.

## 📱 Features

- Login with Email and Password (via Firebase)
- Securely store credentials locally
- Authenticate using biometrics (fingerprint / face ID)
- Supports Android & iOS

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Firebase project setup for Android & iOS

### Packages Used
```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
  local_auth: ^2.1.6
  firebase_core: ^2.25.4
  firebase_auth: ^4.17.8
```

### 🔧 Android Setup
- Set `minSdkVersion` to **16** in `android/app/build.gradle`
- Use `FlutterFragmentActivity` in `MainActivity.kt` or `MainActivity.java`
- Add biometric permissions to `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<uses-permission android:name="android.permission.USE_FINGERPRINT"/>
```

### 🍏 iOS Setup
- Enable "Keychain Sharing" and "Face ID" in Xcode
- Add usage description to `ios/Runner/Info.plist`:

```xml
<key>NSFaceIDUsageDescription</key>
<string>We use Face ID to secure your login</string>
```

## 📂 Project Structure
```
lib/
└── main.dart          # Contains all logic and UI for login & biometric auth
```

## 🧪 How It Works
- User logs in with email & password → credentials stored in secure storage
- On next login → user can authenticate with biometrics → fetches stored credentials → logs in via Firebase

## 📸 Screenshots
> _[Insert screenshots here if available]_

## 📝 Article Link
Read the full tutorial on Medium: [Add Biometric Authentication in Flutter (Face ID & Fingerprint)](https://medium.com/@your-profile)

## 🙌 Contribution
PRs are welcome! Feel free to fork and submit improvements.

## 🔐 License
MIT License © 2025

---
Made with ❤️ using Flutter
