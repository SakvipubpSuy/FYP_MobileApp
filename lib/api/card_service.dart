import 'dart:convert';
import 'package:fyp_mobileapp/models/card.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CardService {
  static const String baseUrl =
      "http://10.0.2.2:8000/api"; // Replace with your API URL
  static final FlutterSecureStorage storage = FlutterSecureStorage();

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Method to get cards for a specific deck
  Future<List<CardModel>> getCardsByDeck(int deckId) async {
    String? token = await _storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('No auth token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/decks/$deckId/cards'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((card) => CardModel.fromJson(card)).toList();
    } else {
      throw Exception('Failed to fetch cards');
    }
  }
}
