import 'package:flutter/material.dart';
import 'package:projek_kik/models/userModels.dart';
import 'package:projek_kik/services/apiService.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;
  bool _initialized = false; // ← NEW: true once prefs check is done

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;
  bool get initialized => _initialized; // ← exposed

  AuthProvider() {
    _checkLoginStatus();
  }

  /// Hanya baca SharedPreferences (instant, < 5ms).
  /// Profile detail di-fetch di background setelah navigate.
  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
        _isLoggedIn = true;
        // Baca cached user data dari prefs agar tidak perlu network
        final name = prefs.getString('user_name');
        final email = prefs.getString('user_email');
        final id = prefs.getInt('user_id');
        if (id != null) {
          _user = UserModel(id: id, name: name, email: email);
        }
      }
    } catch (_) {
      // Jika prefs gagal, tetap lanjut sebagai guest
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  /// Panggil ini setelah login sukses agar data user segar dari API.
  Future<void> refreshUser() async {
    if (_user?.id == null) return;
    try {
      final data = await ApiService.getUser(_user!.id!);
      final raw = data['data'] ?? data;
      _user = UserModel.fromJson(raw);
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.login(email, password);
      if (data['token'] != null || data['data'] != null) {
        final userData = data['data'] ?? data['user'] ?? data;
        _user = UserModel.fromJson(userData);
        final token = data['token'] ?? userData['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token ?? '');
        if (_user?.id != null) {
          await prefs.setInt('user_id', _user!.id!);
        }
        // Cache name & email agar startup berikutnya langsung dari prefs
        if (_user?.name != null) await prefs.setString('user_name', _user!.name!);
        if (_user?.email != null) await prefs.setString('user_email', _user!.email!);
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = data['message'] ?? 'Login gagal';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? username,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        username: username,
      );
      if (data['message'] != null &&
          (data['status'] == 'success' || data['token'] != null || data['data'] != null)) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = data['message'] ?? 'Registrasi gagal';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPassword(String emailOrPhone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.forgotPassword(emailOrPhone);
      _isLoading = false;
      notifyListeners();
      return data['status'] == 'success' || data['message'] != null;
    } catch (e) {
      _error = 'Terjadi kesalahan: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}