import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/models/card.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CardService {
  static const String baseUrl =
      "https://monkfish-app-pozus.ondigitalocean.app/api"; // Replace with your API URL
  static final FlutterSecureStorage storage = FlutterSecureStorage();

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Method to get cards for a specific deck
  Future<List<CardModel>> getCardsByDeck(int deckId) async {
    String? token = await _storage.read(key: 'auth_token');
    // Debug: Print the token
    // print('Token: $token');

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
      final List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((card) => CardModel.fromJson(card)).toList();
    } else {
      throw Exception('Failed to fetch cards');
    }
  }

  Future<void> sendScanResult(BuildContext context, String cardId) async {
    String? token = await _storage.read(key: 'auth_token');

    var url = Uri.parse('$baseUrl/scan-card');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'card_id': int.parse(cardId)}),
    );

    var responseMessage = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseMessage['message'])),
      );
    } else {
      String errorMessage = responseMessage['message'] ?? 'Failed to scan card';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to scan card: $errorMessage')),
      );
    }
  }

  Future<int> countUserTotalCards() async {
    String? token = await _storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/user/total-cards'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['total_cards'];
    } else {
      throw Exception('Failed to load scanned cards count');
    }
  }
}
