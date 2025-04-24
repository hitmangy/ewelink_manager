import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ewelink/models/user_model.dart';
import 'package:ewelink/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  final SharedPreferences _prefs;
  final ApiService _apiService = ApiService();

  AuthProvider(this._prefs) {
    _loadSavedCredentials();
  }

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> _loadSavedCredentials() async {
    final email = _prefs.getString('email');
    final password = _prefs.getString('password');

    if (email != null && password != null) {
      await login(email, password, rememberMe: true);
    }
  }

  Future<bool> login(String email, String password,
      {bool rememberMe = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);

      if (response['success']) {
        _user = UserModel.fromJson(
            response['data'], response['region'], response['imei']);

        if (rememberMe) {
          await _prefs.setString('email', email);
          await _prefs.setString('password', password);
        } else {
          await _prefs.remove('email');
          await _prefs.remove('password');
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _user = null;
    _prefs.remove('email');
    _prefs.remove('password');
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
