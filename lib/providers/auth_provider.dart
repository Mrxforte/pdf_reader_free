import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/database_service.dart';

class AuthProvider with ChangeNotifier {
  User? _firebaseUser;
  AppUser? _user;
  bool _isLoading = false;
  String? _error;
  bool _rememberMe = false;
  bool _hasSkippedAuth = false;

  User? get firebaseUser => _firebaseUser;
  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get rememberMe => _rememberMe;
  bool get hasSkippedAuth => _hasSkippedAuth;
  bool get isAuthenticated => _firebaseUser != null;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    // Load saved preferences
    final prefs = await SharedPreferences.getInstance();
    _rememberMe = prefs.getBool('remember_me') ?? false;
    _hasSkippedAuth = prefs.getBool('skipped_auth') ?? false;

    _auth.authStateChanges().listen((User? user) {
      _firebaseUser = user;
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      _user = await _databaseService.getUser(uid);
      if (_user == null && _firebaseUser != null) {
        _user = AppUser(
          uid: _firebaseUser!.uid,
          email: _firebaseUser!.email!,
          displayName: _firebaseUser!.displayName,
          photoURL: _firebaseUser!.photoURL,
          createdAt: DateTime.now(),
        );
        await _databaseService.saveUser(_user!);
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<bool> loginWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save remember me preference if enabled
      if (_rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('remember_me', true);
      }

      // Clear skip flag on successful login
      await _clearSkipFlag();

      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registerWithEmail(
      String email, String password, String name) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(name);

      _user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        displayName: name,
        createdAt: DateTime.now(),
      );

      try {
        await _databaseService.saveUser(_user!);
      } catch (e) {
        debugPrint('Firestore saveUser failed: $e');
        // Allow auth to succeed even if Firestore is disabled.
      }

      // Clear skip flag on successful registration
      await _clearSkipFlag();

      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _user = null;

      // Clear remember me on logout
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', false);
      _rememberMe = false;
    } catch (e) {
      debugPrint('Error logging out: $e');
    }
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Set remember me preference
  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  // Skip authentication and go directly to home
  Future<void> skipAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('skipped_auth', true);
    _hasSkippedAuth = true;
    notifyListeners();
  }

  // Clear skip flag
  Future<void> _clearSkipFlag() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('skipped_auth', false);
    _hasSkippedAuth = false;
  }

  // Check if user should see auth screen
  Future<bool> shouldShowAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSkipped = prefs.getBool('skipped_auth') ?? false;
    return _firebaseUser == null && !hasSkipped;
  }
}

// Auth provider is locale-agnostic.
