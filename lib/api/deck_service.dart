import 'dart:convert';
import 'package:fyp_mobileapp/models/deck.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_url.dart';

class DeckService {
  String baseUrl = ApiURL.baseUrl;

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Method to get current user details
  Future<List<DeckModel>> getDecks() async {
    String? token = await _storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('No auth token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/decks'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<DeckModel> decks =
          body.map((dynamic item) => DeckModel.fromJson(item)).toList();
      return decks;
    } else {
      throw Exception('Failed to fetch deck information');
    }
  }
}
