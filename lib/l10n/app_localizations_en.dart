// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PDF Viewer Pro';

  @override
  String get home => 'Home';

  @override
  String get allFiles => 'All Files';

  @override
  String get favorites => 'Favorites';

  @override
  String get recent => 'Recent';

  @override
  String get settings => 'Settings';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get about => 'About';

  @override
  String welcomeUser(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String fileCount(Object count) {
    return 'You have $count PDF files';
  }

  @override
  String get recentFiles => 'Recent Files';

  @override
  String get favoriteFiles => 'Favorite Files';

  @override
  String get viewAll => 'View All';

  @override
  String get noRecentFiles => 'No recent files';

  @override
  String get noFavoriteFiles => 'No favorite files';

  @override
  String get searchPdfFiles => 'Search PDF files...';

  @override
  String get noPdfFilesYet => 'No PDF files yet';

  @override
  String get tapPlusToAddFirst => 'Tap the + button to add your first PDF';

  @override
  String get openedLabel => 'Opened';

  @override
  String pageLabel(Object page) {
    return 'Page $page';
  }

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToAccess => 'Sign in to access your PDF files';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get fullName => 'Full Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetInstructions =>
      'Enter your email to receive reset instructions';

  @override
  String get sendResetEmail => 'Send Reset Email';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get profile => 'Profile';

  @override
  String get appSettings => 'App Settings';

  @override
  String get pdfSettings => 'PDF Settings';

  @override
  String get account => 'Account';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get toggleTheme => 'Toggle dark/light theme';

  @override
  String get language => 'Language';

  @override
  String get autoOpenLastFile => 'Auto-open last file';

  @override
  String get showThumbnails => 'Show thumbnails';

  @override
  String get defaultSaveLocation => 'Default save location';

  @override
  String get privacySecurity => 'Privacy & Security';

  @override
  String get backupSync => 'Backup & Sync';

  @override
  String get clearAllData => 'Clear All Data';

  @override
  String get signOut => 'Sign Out';

  @override
  String versionLabel(Object version) {
    return 'Version $version';
  }
}
