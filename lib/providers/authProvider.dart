import 'package:flutter/material.dart';
import 'package:projek_kik/models/userModels.dart';
import 'package:projek_kik/services/apiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;
  bool _initialized = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;
  bool get initialized => _initialized;
  bool get isAuthenticated => _isLoggedIn;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null && token.isNotEmpty) {
        _isLoggedIn = true;

        final id = prefs.getInt('user_id');
        final name = prefs.getString('user_name');
        final email = prefs.getString('user_email');

        if (id != null) {
          _user = UserModel(id: id, name: name, email: email);
        }
      } else {
        _isLoggedIn = false;
      }
    } catch (e) {
      debugPrint('CHECK LOGIN ERROR: $e');
      _isLoggedIn = false;
    }

    _initialized = true;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    try {
      if (_user?.id == null) return;
      final data = await ApiService.getUser(_user!.id!);
      final raw = data['data'] ?? data;
      if (raw != null) {
        _user = UserModel.fromJson(raw);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('REFRESH USER ERROR: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.login(email, password);
      print("LOGIN RESPONSE: $data");

      // ✅ FIXED: cek 'status' bukan 'success'
      if (data['status'] != true) {
        _error = data['message'] ?? 'Login gagal';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final userData = data['data']?['data'] ?? data['data'];

      if (userData == null) {
        _error = 'Data user tidak ditemukan';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _user = UserModel.fromJson(userData);
      _isLoggedIn = true;

      final prefs = await SharedPreferences.getInstance();
      final token = data['token'];

      if (token != null) await prefs.setString('token', token);
      if (_user?.id != null) await prefs.setInt('user_id', _user!.id!);
      if (_user?.username != null) await prefs.setString('user_name', _user!.username!);
      if (_user?.email != null) await prefs.setString('user_email', _user!.email!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Network error: $e';
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

      print("REGISTER RESPONSE: $data");

      _isLoading = false;
      notifyListeners();

      // ✅ FIXED: sekarang 'status' dari apiService sudah konsisten
      if (data['status'] == true) {
        return true;
      } else {
        _error = data['message'] ?? 'Registrasi gagal';
        return false;
      }
    } catch (e) {
      debugPrint("REGISTER ERROR: $e");
      _error = 'Network error';
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
      return data['status'] == true || data['message'] != null;
    } catch (e) {
      debugPrint("FORGOT PASSWORD ERROR: $e");
      _error = 'Network error';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _user = null;
      _isLoggedIn = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      debugPrint('LOGOUT ERROR: $e');
    }
  }
}