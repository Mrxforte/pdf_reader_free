import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? user;
  bool isLoading = false;

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    user = await AuthService().login(email, password);
    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthService().logout();
    user = null;
    notifyListeners();
  }
  // ...register, forgot password, etc...
}
