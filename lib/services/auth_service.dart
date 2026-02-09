import '../models/user.dart';

class AuthService {
  Future<UserModel?> login(String email, String password) async {
    // ...Firebase Auth login logic...
    return null;
  }

  Future<void> logout() async {
    // ...Firebase Auth logout logic...
  }
  // ...register, forgot password, etc...
}
