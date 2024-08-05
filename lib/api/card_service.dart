import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/models/card.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/quest.dart';
import 'api_url.dart';

class CardService {
  String baseUrl = ApiURL.baseUrl;

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

  Future<CardModel> getCardByID(String cardId) async {
    String? token = await _storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/cards/$cardId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['count'];
    } else {
      throw Exception('Failed to fetch trade counts');
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

  Future<List<QuestionModel>> getQuests() async {
    String? token = await _storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/user/quests'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<QuestionModel> quests =
          body.map((dynamic item) => QuestionModel.fromJson(item)).toList();
      return quests;
    } else {
      throw Exception('Failed to fetch quests');
    }
  }

  Future<Map<String, dynamic>> submitQuest(int questionId, int answerId) async {
    String? token = await _storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/user/submit-quest'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'question_id': questionId,
        'answer_id': answerId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to submit answer');
    }
  }
}
