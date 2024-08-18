import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_url.dart';

class AuthService {
  String baseUrl = ApiURL.baseUrl;
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

//REGISTER
  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    final url =
        Uri.parse('$baseUrl/register'); // Adjust the endpoint as per your API

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final id = data['user']['id'];

        // Store the token and user ID
        await _storage.write(key: 'auth_token', value: token);
        await _storage.write(key: 'userID', value: id.toString());

        return {
          'status': 'success',
          'message': 'User registered successfully',
          'token': token
        };
      } else {
        final error = jsonDecode(response.body)['message'];
        return {'status': 'error', 'message': error};
      }
    } catch (error) {
      return {'status': 'error', 'message': 'Failed to register user: $error'};
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
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final id = data['user']['id'];
      await _storage.write(key: 'auth_token', value: data['token']);
      await _storage.write(key: 'userID', value: id.toString());
      // String? token = await _storage.read(key: 'auth_token');
      // String? userID = await _storage.read(key: 'userID');
      // print('Token: $token');
      // print('User ID: $userID');
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }

  // Method to retrieve the stored token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  //Method to check is user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Method to request codes for password reset
  Future<String?> requestResetCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forget-password/request-reset-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        // Try to parse the JSON response
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return data['success'] ?? 'Reset code sent successfully';
        } else {
          return 'Reset code sent successfully'; // Handle empty response body
        }
      } else {
        final data = jsonDecode(response.body);
        // Handle error response
        return data['error'] ??
            'Failed to send reset code. Please try again later.';
      }
    } catch (e) {
      // Handle any other exceptions
      return 'An error occurred: $e';
    }
  }

  // Similar error handling can be applied to other methods
  Future<String?> verifyResetCode(String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forget-password/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code}),
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return data['success'] ?? 'Code verified successfully';
        } else {
          return 'Code verified successfully';
        }
      } else {
        return 'Failed to verify code. Please try again later.';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }

  Future<String?> resetPassword(String email, String code, String password,
      String passwordConfirmation) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forget-password/reset'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'code': code,
          'password': password,
          'password_confirmation': passwordConfirmation
        }),
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return data['success'] ?? 'Password reset successfully';
        } else {
          return 'Password reset successfully';
        }
      } else {
        final data = jsonDecode(response.body);
        return data['error'] ?? 'Failed to reset password. Please try again.';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }
}
