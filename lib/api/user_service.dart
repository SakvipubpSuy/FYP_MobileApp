import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  static const String baseUrl =
      "http://10.0.2.2:8000/api"; // Replace with your API URL
  static final FlutterSecureStorage storage = FlutterSecureStorage();

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Method to get current user details
  Future<Map<String, dynamic>> getCurrentUser() async {
    String? token = await _storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('No auth token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user information');
    }
  }
}
