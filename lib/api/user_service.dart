import 'dart:convert';
import 'package:fyp_mobileapp/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_url.dart';

class UserService {
  String baseUrl = ApiURL.baseUrl;

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Method to get current user details
  Future<UserModel> getCurrentUser() async {
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
      final jsonData = jsonDecode(response.body);
      return UserModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch user information');
    }
  }

  Future<List<dynamic>> getAllUsers() async {
    String? token = await _storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('No auth token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to fetch user information');
    }
  }
}
