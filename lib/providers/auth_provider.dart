import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../services/database_service.dart';

class AuthProvider with ChangeNotifier {
  User? _firebaseUser;
  AppUser? _user;
  bool _isLoading = false;
  String? _error;

  User? get firebaseUser => _firebaseUser;
  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
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
}

// Auth provider is locale-agnostic.
