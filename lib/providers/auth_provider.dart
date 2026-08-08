import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    // Demo user auto-login for presentation
    _currentUser = UserModel(
      id: 'demo-user-123',
      email: 'mromero_250000000103@uic.edu.ph',
      fullName: 'Marlo Romero',
      themePreference: 'dark',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLogin: DateTime.now(),
    );
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _supabaseService.signIn(email, password);
      if (res.user != null) {
        _currentUser = await _supabaseService.getUserProfile(res.user!.id);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    try {
      await _supabaseService.signOut();
    } catch (_) {}
    _currentUser = null;
    notifyListeners();
  }
}