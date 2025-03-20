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
    // Explicitly initialize and check auth status
    _isInitialized = false;
    tryAutoLogin().then((_) {
      _isInitialized = true;
      notifyListeners();
    });
  }

  void _initializeAuthListener() {
    _authService.onAuthChange = (User? user) {
      _loggedInUser = user;
      _isInitialized = true;
      notifyListeners();
    };
  }

  User? get loggedInUser => _loggedInUser;

  bool get isAuth => _loggedInUser != null;

  bool get isStaff => _loggedInUser?.urole == 'staff';

  bool get isCustomer => _loggedInUser?.urole == 'customer';

  bool get isInitialized => _isInitialized;

  Future<void> signup(
      String username, String email, String phone, String password) async {
    try {
      print('🔴 AuthManager: Starting signup process');
      await _authService.signup(username, email, phone, password);
      print('✅ AuthManager: Signup completed successfully');
    } catch (error) {
      print('❌ Signup error in manager: $error');
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
    print('🔴 Starting tryAutoLogin()');
    try {
      final user = await _authService.getUserFromStore();
      print('✅ getUserFromStore completed: user = ${user != null ? 'exists' : 'null'}');

      if (user != null) {
        _loggedInUser = user;
        notifyListeners();
      } else {
        _loggedInUser = null;
        notifyListeners();
      }
      print('✅ tryAutoLogin completed successfully');
    } catch (error) {
      print('❌ Auto login error: $error');
      _loggedInUser = null;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _loggedInUser = null;
    notifyListeners();
  }
}
