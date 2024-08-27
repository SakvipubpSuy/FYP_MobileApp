import 'dart:convert';
import 'package:fyp_mobileapp/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../db/user_helper.dart';
import 'api_url.dart';

class UserService {
  String baseUrl = ApiURL.baseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final UserDbHelper _dbHelper = UserDbHelper();

// Method to get current user details, with offline support
  Future<UserModel> getCurrentUser() async {
    String? token = await _storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('No auth token found');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        UserModel user = UserModel.fromJson(jsonData);

        // Save the user data to the local database
        await _dbHelper.insertUser(user);

        return user;
      } else {
        throw Exception('Failed to fetch user information');
      }
    } catch (e) {
      // Replace this with your actual logic for getting the user ID
      String? userId = await _storage.read(key: 'userID');

      if (userId != null) {
        UserModel? user = await _dbHelper.getUser(int.parse(userId));

        if (user != null) {
          return user;
        } else {
          throw Exception('User not found in local database');
        }
      } else {
        throw Exception('User ID not found');
      }
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
