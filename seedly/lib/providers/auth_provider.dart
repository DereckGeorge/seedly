import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  // Register user
  Future<bool> register({
    required String phone,
    required String username,
    required String password,
    required UserType userType,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await AuthService.register(
        phone: phone,
        username: username,
        password: password,
        userType: userType,
      );

      if (success) {
        _currentUser = AuthService.currentUser;
        notifyListeners();
        return true;
      } else {
        _setError('Registration failed');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Login user
  Future<bool> login({required String phone, required String password}) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await AuthService.login(phone: phone, password: password);

      if (success) {
        _currentUser = AuthService.currentUser;
        notifyListeners();
        return true;
      } else {
        _setError('Invalid credentials');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout user
  void logout() {
    AuthService.logout();
    _currentUser = null;
    _clearError();
    notifyListeners();
  }

  // Update user
  Future<bool> updateUser(User updatedUser) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await AuthService.updateUser(updatedUser);

      if (success) {
        _currentUser = updatedUser;
        notifyListeners();
        return true;
      } else {
        _setError('Failed to update user');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
