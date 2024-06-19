import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl =
      "http://10.0.2.2:8000/api"; // Replace with your API URL
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

//REGISTER
  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }

//LOGIN
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'auth_token', value: data['token']);
      String? token = await _storage.read(key: 'auth_token');
      print('Token: $token');
      return true;
    } else {
      return false;
    }
  }

  // Method to retrieve the stored token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Method to log out user
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }
}
