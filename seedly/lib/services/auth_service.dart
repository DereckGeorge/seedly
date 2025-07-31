import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  static const String baseUrl =
      'http://192.168.100.67:8001'; 

  // For demo purposes, we'll use local storage
  static final Map<String, User> _users = {};
  static User? _currentUser;

  static User? get currentUser => _currentUser;

  // Register new user
  static Future<bool> register({
    required String phone,
    required String username,
    required String password,
    required UserType userType,
  }) async {
    try {
      // Check if user already exists
      if (_users.values.any(
        (user) => user.phone == phone || user.username == username,
      )) {
        throw Exception('User already exists with this phone or username');
      }

      // Create new user
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        phone: phone,
        username: username,
        password: password, // In real app, hash the password
        userType: userType,
        createdAt: DateTime.now(),
      );

      _users[user.id] = user;
      _currentUser = user;

      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // Login user
  static Future<bool> login({
    required String phone,
    required String password,
  }) async {
    try {
      final user = _users.values.firstWhere(
        (user) => user.phone == phone && user.password == password,
        orElse: () => throw Exception('Invalid credentials'),
      );

      _currentUser = user;
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Logout user
  static void logout() {
    _currentUser = null;
  }

  // Check if user is logged in
  static bool get isLoggedIn => _currentUser != null;

  // Get user by ID
  static User? getUserById(String id) {
    return _users[id];
  }

  // Update user
  static Future<bool> updateUser(User updatedUser) async {
    try {
      _users[updatedUser.id] = updatedUser;
      if (_currentUser?.id == updatedUser.id) {
        _currentUser = updatedUser;
      }
      return true;
    } catch (e) {
      print('Update user error: $e');
      return false;
    }
  }
}
