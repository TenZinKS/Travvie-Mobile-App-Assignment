class AuthController {
  Future<String?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.isNotEmpty) return null;
    return 'Please fill in both fields';
  }

  Future<String?> signup(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.isNotEmpty) return null;
    return 'Signup failed: fields cannot be empty';
  }
}
