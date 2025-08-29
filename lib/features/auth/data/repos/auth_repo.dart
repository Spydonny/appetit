import 'dart:convert';
import 'package:appetite_app/core/core.dart';
import 'package:http/http.dart' as http;
import '../../../shared/shared.dart';

class AuthRepo {
  final String baseUrl;

  AuthRepo({required this.baseUrl});

  /// Регистрация через email или телефон
  Future<User> register({
    required String fullName,
    String? email,
    String? phone,
    String? dob,
    String? address,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "full_name": fullName,
        "email": email,
        "phone": phone,
        "dob": dob,
        "password": password,
        "address": address
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ??
          'Failed to register user');
    }
  }

  /// Логин через email/phone + password
  Future<Map<String, dynamic>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email_or_phone": emailOrPhone,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        "accessToken": data['access_token'],
        "user": User.fromJson(data['user']),
      };
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to login');
    }
  }

  /// 🔹 Запросить отправку кода на телефон (OTP)
  Future<String> startPhoneVerification(String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/phone/start'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phone}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'];
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ??
          'Failed to start phone verification');
    }
  }

  /// 🔹 Подтвердить телефон с кодом
  Future<String> verifyPhoneCode({
    required String phone,
    required String code,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/phone/verify-code'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phone, "code": code}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'];
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ??
          'Failed to verify phone code');
    }
  }

  /// 🔹 Логин по телефону + OTP
  Future<Map<String, dynamic>> loginWithPhoneOtp({
    required String phone,
    required String code,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/phone/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phone, "code": code}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        "accessToken": data['access_token'],
        "user": User.fromJson(data['user']),
      };
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ??
          'Failed to login with phone OTP');
    }
  }

  /// Обновление профиля
  Future<User> updateProfile({
    required String token,
    String? fullName,
    String? email,
    String? phone,
    String? dob,
    required String address,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${getIt<TokenNotifier>().token}",
      },
      body: jsonEncode({
        "full_name": fullName,
        "email": email,
        "phone": phone,
        "dob": dob,
        "address": address
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ??
          'Failed to update profile');
    }
  }

  /// Получение информации о себе
  Future<User> getMe(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: {"Authorization": "Bearer ${getIt<TokenNotifier>().token}"},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ??
          'Failed to fetch user');
    }
  }
}
