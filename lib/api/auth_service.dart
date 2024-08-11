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
        final token =
            data['token']; // Assuming the token is returned in the response
        final id = data['user']['id']; // Assuming the user ID is returned

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
      print('Exception caught in AuthService: $error');
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
}
