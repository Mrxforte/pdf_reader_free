# 📄 PDF Viewer Free

<div align="center">
  
![Flutter](https://img.shields.io/badge/Flutter-3.0.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**A powerful and feature-rich PDF viewer app built with Flutter**

[Features](#-features) • [Installation](#-installation) • [Screenshots](#-screenshots) • [Tech Stack](#-tech-stack) • [Contributing](#-contributing)

</div>

---

## ✨ Features

- 📱 **Cross-Platform**: Works seamlessly on Android and iOS
- 🔐 **Authentication**: Secure login with email/password
- ☁️ **Cloud Storage**: Upload and sync PDFs across devices using Firebase Storage
- ⭐ **Favorites**: Mark important PDFs for quick access
- 🕒 **Recent Files**: Automatically track recently viewed documents
- 🔍 **Advanced Viewing**: Zoom, pan, and navigate PDFs with ease
- 🌓 **Dark Mode**: Eye-friendly dark theme support
- 📤 **Sharing**: Share PDFs with other apps
- 💾 **Offline Access**: Download and view PDFs offline
- 🎨 **Modern UI**: Clean and intuitive Material Design interface

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: `>=3.0.0 <4.0.0`
- **Dart SDK**: `>=3.0.0 <4.0.0`
- **Android Studio** or **Xcode** (for iOS development)
- **Firebase Project** (for backend services)
- **Git** for version control

### Check Your Environment

```bash
flutter --version
dart --version
```

Expected output should show Flutter 3.0.0+ and Dart 3.0.0+

---

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/pdf_viewer_free.git
cd pdf_viewer_free
```

### 2. Download Assets

#### Roboto Fonts
1. Download Roboto fonts from [Google Fonts](https://fonts.google.com/specimen/Roboto)
2. Extract and place the following files in `assets/fonts/`:
   - `Roboto-Regular.ttf`
   - `Roboto-Medium.ttf`
   - `Roboto-Bold.ttf`
   - `Roboto-Light.ttf`

#### Logo
1. Create or download a logo image (recommended size: 512x512px)
2. Place it as `assets/images/logo.png`
3. Optionally add a splash screen image as `assets/images/splash.png`

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Firebase Setup

#### a. Create a Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use an existing one
3. Enable **Authentication**, **Cloud Firestore**, and **Storage**

#### b. Add Firebase to Your App

**For Android:**
1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/`

**For iOS:**
1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it in `ios/Runner/`

#### c. Configure Firebase in Your App

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

### 5. Enable Firebase Services

In Firebase Console, enable:
- ✅ Email/Password Authentication
- ✅ Cloud Firestore
- ✅ Firebase Storage

### 6. Run the App

```bash
# Run on connected device
flutter run

# Run on specific device
flutter run -d <device_id>

# Build for release
flutter build apk  # Android
flutter build ios  # iOS
```

---

## 📱 Screenshots

<div align="center">
  
| Home Screen | PDF Viewer | Dark Mode |
|------------|------------|-----------|
| ![Home](assets/images/screenshot_home.png) | ![Viewer](assets/images/screenshot_viewer.png) | ![Dark](assets/images/screenshot_dark.png) |

</div>

---

## 🛠️ Tech Stack

### Core
- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language
- **Provider**: State management solution

### Firebase
- **Firebase Auth**: User authentication
- **Cloud Firestore**: NoSQL database
- **Firebase Storage**: Cloud file storage

### PDF & File Handling
- **syncfusion_flutter_pdfviewer**: PDF rendering engine
- **flutter_pdfview**: Alternative PDF viewer
- **file_picker**: File selection from device
- **path_provider**: Access to device directories

### UI & UX
- **flutter_slidable**: Swipeable list items
- **cached_network_image**: Efficient image caching
- **pull_to_refresh**: Pull-to-refresh functionality

### Storage & Caching
- **Hive**: Fast local database
- **shared_preferences**: Key-value storage
- **flutter_secure_storage**: Encrypted storage

### Other
- **share_plus**: File sharing functionality
- **connectivity_plus**: Network status monitoring
- **permission_handler**: Runtime permissions

---

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── pdf_file.dart
│   └── user.dart
├── screens/                  # UI screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── forgot_password_screen.dart
│   ├── home_screen.dart
│   ├── pdf_viewer_screen.dart
│   └── settings_screen.dart
├── widgets/                  # Reusable widgets
│   ├── drawer_menu.dart
│   ├── pdf_thumbnail.dart
│   └── zoom_controls.dart
├── services/                 # Business logic
│   ├── auth_service.dart
│   ├── storage_service.dart
│   └── database_service.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── theme_provider.dart
│   └── pdf_provider.dart
└── utils/                    # Utilities
    ├── constants.dart
    └── theme.dart
```

---

## 🧪 Testing

Run unit and widget tests:

```bash
flutter test
```

Run integration tests:

```bash
flutter test integration_test/
```

---

## 🔧 Configuration

### Customize App Settings

Edit `lib/utils/constants.dart` to modify app-wide settings.

### Theme Customization

Modify `lib/utils/theme.dart` to customize light and dark themes.

---

## 📝 Environment

| Tool | Version |
|------|---------|
| Flutter | 3.0.0+ |
| Dart | 3.0.0+ |
| Minimum Android SDK | 21 |
| Minimum iOS Version | 12.0 |

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Authors

- **Your Name** - *Initial work* - [YourGitHub](https://github.com/yourusername)

---

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev/) for the amazing framework
- [Firebase](https://firebase.google.com/) for backend services
- [Syncfusion](https://www.syncfusion.com/) for the PDF viewer component
- All open-source contributors

---

## 📞 Support

For support, email support@example.com or open an issue in the repository.

<div align="center">

**Made with ❤️ using Flutter**

⭐ Star this repo if you find it helpful!

</div>
