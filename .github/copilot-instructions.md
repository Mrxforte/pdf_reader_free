# Copilot Instructions for pdf_viewer_free

## Project Overview

This is a Flutter app for viewing PDF files, with Firebase integration for authentication, storage, and file management. The app supports user login/registration, file upload/download, favorites, recent files, and sharing.

## Architecture

- **lib/** contains all Dart source code.
  - **models/**: Data models (`pdf_file.dart`, `user.dart`).
  - **screens/**: UI screens, grouped by feature (e.g., `auth/`, `home_screen.dart`, `pdf_viewer_screen.dart`).
  - **widgets/**: Reusable UI components (e.g., `drawer_menu.dart`, `pdf_thumbnail.dart`).
  - **services/**: Business logic and integration with Firebase (`auth_service.dart`, `storage_service.dart`, etc.).
  - **providers/**: State management using Provider (`auth_provider.dart`, `theme_provider.dart`, `pdf_provider.dart`).
  - **utils/**: Constants, themes, and helper functions.

## Data Flow

- **Authentication**: Managed via `auth_service.dart` and `auth_provider.dart`, using Firebase Auth and Google Sign-In.
- **PDF Files**: Uploaded/downloaded via `storage_service.dart`, metadata stored in Firestore via `database_service.dart`.
- **State Management**: Uses Provider for app-wide state (auth, theme, PDF files).
- **UI Navigation**: Screens are organized for easy navigation; drawer menu and slidable widgets are used for file actions.

## Developer Workflows

- **Build & Run**: Standard Flutter commands (`flutter run`, `flutter build`).
- **Testing**: Use `flutter test` for unit tests in `lib/`.
- **Assets**: Place images in `assets/images/`, fonts in `assets/fonts/`. Update `pubspec.yaml` if new assets are added.
- **Firebase Setup**: Configure `firebase_options.dart` for your project. Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are present.

## Patterns & Conventions

- **Provider**: All stateful logic should use Providers in `lib/providers/`.
- **Service Layer**: Business logic and Firebase interactions are separated into `lib/services/`.
- **Screen Structure**: Each major feature has its own screen file; authentication screens are grouped under `lib/screens/auth/`.
- **Widget Reuse**: Common UI elements are extracted into `lib/widgets/`.
- **Theme**: App-wide theming is managed in `lib/utils/theme.dart`.

## Integration Points

- **Firebase**: Used for Auth, Firestore, Storage. All integration is abstracted in services.
- **PDF Viewing**: Uses `syncfusion_flutter_pdfviewer` and `flutter_pdfview` for rendering PDFs.
- **Sharing**: Uses `share_plus` for sharing files.
- **Local Storage**: Uses Hive and SharedPreferences for caching and storing user preferences.

## Example Patterns

- To add a new PDF file model property, update `lib/models/pdf_file.dart` and ensure changes propagate to Firestore logic in `database_service.dart`.
- To add a new screen, create it in `lib/screens/`, add navigation logic in `main.dart` or drawer menu.

## Key Files

- `lib/main.dart`: App entry point, routing.
- `lib/firebase_options.dart`: Firebase config.
- `pubspec.yaml`: Dependencies and asset management.

---

If any section is unclear or missing, please specify so it can be improved!
