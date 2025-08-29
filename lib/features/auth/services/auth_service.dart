import 'dart:convert';
import 'package:appetite_app/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repos/auth_repo.dart';
import '../../shared/shared.dart';

class AuthService {
  final AuthRepo _repo;
  String? _accessToken;
  User? _currentUser;

  AuthService(this._repo);

  String? get accessToken => _accessToken;
  User? get currentUser => _currentUser;

  /// Load token + user from local storage
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('accessToken');
    final userJson = prefs.getString('user');

    if (_accessToken != null) {
      getIt<TokenNotifier>().setToken(_accessToken!);
    }

    if (userJson != null) {
      _currentUser = User.fromJson(jsonDecode(userJson));
    }
  }

  /// Save session to local storage
  Future<void> _saveSession(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
    await prefs.setString('user', jsonEncode(user.toJson()));

    getIt<TokenNotifier>().setToken(token); // ✅ через getIt
    _accessToken = token;
    _currentUser = user;
  }

  /// Register new user (email/phone + password)
  Future<User> register({
    required String fullName,
    String? email,
    String? phone,
    String? address,
    required String dob,
    required String password,
  })
  async {
    final user = await _repo.register(
      fullName: fullName,
      email: email,
      phone: phone,
      dob: dob,
      address: address,
      password: password,
    );
    return user;
  }

  /// Login (email/phone + password)
  Future<User> login({
    required String emailOrPhone,
    required String password,
  })
  async {
    final result = await _repo.login(
      emailOrPhone: emailOrPhone,
      password: password,
    );

    final token = result['accessToken'];
    final user = result['user'] as User;

    await _saveSession(token, user);
    return user;
  }

  /// 🔹 Start phone verification (OTP)
  Future<String> startPhoneVerification(String phone) async {
    return await _repo.startPhoneVerification(phone);
  }

  /// 🔹 Verify phone code
  Future<String> verifyPhoneCode({
    required String phone,
    required String code,
  }) async {
    return await _repo.verifyPhoneCode(phone: phone, code: code);
  }

  /// 🔹 Login with phone OTP
  Future<User> loginWithPhoneOtp({
    required String phone,
    required String code,
  }) async {
    final result = await _repo.loginWithPhoneOtp(phone: phone, code: code);
    final token = result['accessToken'];
    final user = result['user'] as User;

    await _saveSession(token, user);
    return user;
  }

  /// Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('user');
    _accessToken = null;
    _currentUser = null;
  }

  /// Refresh current user from server
  Future<User?> refreshUser() async {

    debugPrint("ОЛФДВЫАООООЫВАДОЛ-${getIt<TokenNotifier>().token}");
    final user = await _repo.getMe(getIt<TokenNotifier>().token);
    _currentUser = user;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
    return user;
  }

  /// Update profile
  Future<User> updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? dob,
    required String address
  }) async {
    // if (_accessToken == null) {
    //   throw Exception("Not authenticated");
    // }
    debugPrint("ОЛФДВЫАООООЫВАДОЛ-${TokenNotifier().token}");

    final user = await _repo.updateProfile(
      token: TokenNotifier().token,
      fullName: fullName,
      email: email,
      phone: phone,
      dob: dob,
      address: address
    );
    _currentUser = user;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));

    return user;
  }
}

