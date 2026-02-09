class AppConstants {
  static const String appName = 'PDF Viewer Pro';
  static const String appVersion = '1.0.0';
  static const String firebaseCollectionUsers = 'users';
  static const String firebaseCollectionFiles = 'files';
  static const int maxFileSize = 50 * 1024 * 1024; // 50MB
  static const List<String> supportedFormats = ['pdf'];

  // Routes
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String forgotPasswordRoute = '/forgot-password';
}
