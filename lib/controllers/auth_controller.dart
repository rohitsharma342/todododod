import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../data/static_data.dart';

class AuthController extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    await Future.delayed(const Duration(seconds: 1));

    if (email == 'demo@todododod.com' && password == 'password123') {
      _currentUser = StaticData.demoUser;
      _setLoading(false);
      return true;
    }

    _setError('Invalid email or password. Try demo@todododod.com / password123');
    _setLoading(false);
    return false;
  }

  Future<bool> signup(String name, String email, String password) async {
    _setLoading(true);
    _setError(null);

    await Future.delayed(const Duration(seconds: 1));

    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
    );

    _setLoading(false);
    return true;
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> updateProfile({
    String? name,
    String? email,
    bool? notificationsEnabled,
  }) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = _currentUser!.copyWith(
      name: name,
      email: email,
      notificationsEnabled: notificationsEnabled,
    );

    _setLoading(false);
    return true;
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    _setLoading(true);
    _setError(null);

    await Future.delayed(const Duration(seconds: 1));

    if (currentPassword != 'password123') {
      _setError('Current password is incorrect');
      _setLoading(false);
      return false;
    }

    _setLoading(false);
    return true;
  }
}