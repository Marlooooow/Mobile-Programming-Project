import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthProvider _authProvider;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  AuthViewModel(this._authProvider);

  bool get isLoading => _authProvider.isLoading;
  String? get errorMessage => _authProvider.errorMessage;

  Future<bool> handleLogin() async {
    return await _authProvider.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }
}