import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../models/user.dart';
import '../../../services/auth_service.dart';

class AuthManager with ChangeNotifier {
  final AuthService _authService;
  User? _loggedInUser;
  bool _isInitialized = false;

  AuthManager() : _authService = AuthService() {
    _initializeAuthListener();
  }

  void _initializeAuthListener() {
    _authService.onAuthChange = (User? user) {
      _loggedInUser = user;
      _isInitialized = true;
      notifyListeners();
    };
  }

  User? get loggedInUser => _loggedInUser;

  bool get isAuth {
    return _loggedInUser != null;
  }

  bool get isInitialized {
    return _isInitialized;
  }

  User? get user {
    return _loggedInUser;
  }
  

  Future<void> signup(String username, String email, String phone, String password) async {
    try {
      print('🔴 AuthManager: Starting signup process');
      await _authService.signup(username, email, phone, password);
      print('🔴 AuthManager: Signup completed successfully');
    } catch (error) {
      print('🔴 Signup error in manager: $error');
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _authService.login(email, password);
    } catch (error) {
      print('Login error in manager: $error');
      rethrow;
    }
  }

  Future<void> tryAutoLogin() async {
    try {
      final user = await _authService.getUserFromStore();
      if (_loggedInUser != null) {
        _loggedInUser = user;
        notifyListeners();
      }
    } catch (error) {
      print('🔴 Auto login error: $error');
    }
  }

  Future<void> logout() async {
    return _authService.logout();
  }
}
