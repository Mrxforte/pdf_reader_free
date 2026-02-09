import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAehTay8PazMXzuUepOO0XI9zWzCxRjaqo',
    appId: '1:210384624605:web:34c3fc77c0046e228ef434',
    messagingSenderId: '210384624605',
    projectId: 'screenify-c2d63',
    authDomain: 'screenify-c2d63.firebaseapp.com',
    storageBucket: 'screenify-c2d63.firebasestorage.app',
    measurementId: 'G-VV8L495K7X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCFu0T9Gud-Bz4UT2fh7-QSZsG61J6WHlU',
    appId: '1:210384624605:android:d8505b71fcdebefa8ef434',
    messagingSenderId: '210384624605',
    projectId: 'screenify-c2d63',
    storageBucket: 'screenify-c2d63.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZwReAlZgMYgQIRaXvjk0ODLIeMOPi76Q',
    appId: '1:210384624605:ios:ee5394dd39ea765a8ef434',
    messagingSenderId: '210384624605',
    projectId: 'screenify-c2d63',
    storageBucket: 'screenify-c2d63.firebasestorage.app',
    iosBundleId: 'com.example.pdfReaderFree',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZwReAlZgMYgQIRaXvjk0ODLIeMOPi76Q',
    appId: '1:210384624605:ios:ee5394dd39ea765a8ef434',
    messagingSenderId: '210384624605',
    projectId: 'screenify-c2d63',
    storageBucket: 'screenify-c2d63.firebasestorage.app',
    iosBundleId: 'com.example.pdfReaderFree',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAO7iTSZW8Xnc0JOr4oJVFUDd8OYdAJNn4',
    appId: '1:210384624605:web:c972bf8532fd62d58ef434',
    messagingSenderId: '210384624605',
    projectId: 'screenify-c2d63',
    authDomain: 'screenify-c2d63.firebaseapp.com',
    storageBucket: 'screenify-c2d63.firebasestorage.app',
    measurementId: 'G-H5T25MHHVY',
  );

}