import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/models/card.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/card_helper.dart';
import '../models/quest.dart';
import '../utils/connectivity_service.dart';
import 'api_url.dart';

class CardService {
  String baseUrl = ApiURL.baseUrl;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  //Decrypt the ID
  Future<String> decrypt(String encryptedData) async {
    String? token = await _storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/decrypt/$encryptedData'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to decrypt scan data');
    }
  }

  // Method to get cards for a specific deck
  Future<List<CardModel>> getCardsByDeck(int deckId) async {
    ConnectivityService connectivityService = ConnectivityService();
    bool isConnected = await connectivityService.checkConnection();

    if (isConnected) {
      // Fetch from API
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
        final List jsonResponse = jsonDecode(response.body);
        final cards =
            jsonResponse.map((card) => CardModel.fromJson(card)).toList();

        // Save cards and card tiers locally
        for (CardModel card in cards) {
          await CardDbHelper().saveCard(card);
        }

        return cards;
      } else {
        throw Exception('Failed to fetch cards');
      }
    } else {
      // Fetch from local database
      return await CardDbHelper().getCardsByDeck(deckId);
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

      // Assuming you have a CardModel class that can handle the parsed data
      return CardModel.fromJson(responseData);
    } else {
      throw Exception('Failed to fetch card details');
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
      body: jsonEncode({'card_id': cardId}),
    );

    var responseMessage = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _showResultDialog(context, 'Success', responseMessage['message']);
    } else {
      String errorMessage = responseMessage['message'] ?? 'Failed to scan card';
      _showResultDialog(context, 'Error', 'Failed to scan card: $errorMessage');
    }
  }

  void _showResultDialog(BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<int> countUserTotalCards() async {
    ConnectivityService connectivityService = ConnectivityService();
    bool isConnected = await connectivityService.checkConnection();

    if (isConnected) {
      // Fetch the total card count from the API if there's an internet connection
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
        throw Exception('Failed to load total cards count from server');
      }
    } else {
      // If no internet connection, fetch the count from the local database
      int localCardCount = await CardDbHelper().getLocalCardCount();
      return localCardCount;
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
      return await _getDailyRandomQuests(quests);
    } else {
      throw Exception('Failed to fetch quests');
    }
  }

  Future<List<QuestionModel>> _getDailyRandomQuests(
      List<QuestionModel> allQuests) async {
    final prefs = await SharedPreferences.getInstance();

    // Get today's date in 'yyyy-MM-dd' format
    // Use this if you want to reset it every minute for testing purpose:
    // DateTime.now().toIso8601String().substring(0, 16);
    //Use this if you want to reset it everyday
    // DateTime.now().toIso8601String().split('T')[0];

    String todayDate = DateTime.now().toIso8601String().split('T')[0];

    // Fetch the last saved quest date
    String? savedDate = prefs.getString('savedQuestDate');

    // If it's a new day, reset the completed quests
    if (savedDate != null && savedDate != todayDate) {
      // Clear the completed quests for a new day
      prefs.remove('completedQuests');
    }
    // Fetch completed quests
    List<String> completedQuests = prefs.getStringList('completedQuests') ?? [];

    // Check if the quests were already set for today
    List<String>? savedQuests = prefs.getStringList('dailyRandomQuests');
    if (savedDate != null && savedQuests != null && savedDate == todayDate) {
      // Filter out completed quests from the saved ones
      return savedQuests
          .map((q) => QuestionModel.fromJson(jsonDecode(q)))
          .where((quest) =>
              !completedQuests.contains(quest.question_id.toString()))
          .toList();
    }

    // Filter out completed quests from available quests
    List<QuestionModel> availableQuests = allQuests
        .where(
            (quest) => !completedQuests.contains(quest.question_id.toString()))
        .toList();

    // Randomly select 3 quests for the day
    List<QuestionModel> randomQuests = [];
    if (availableQuests.length > 3) {
      availableQuests.shuffle(); // Randomize the quest list
      randomQuests = availableQuests.take(3).toList();
    } else {
      randomQuests = availableQuests; // Use all available quests if less than 3
    }

    // Save the selected quests and today's date
    prefs.setString('savedQuestDate', todayDate);
    prefs.setStringList(
      'dailyRandomQuests',
      randomQuests.map((q) => jsonEncode(q.toJson())).toList(),
    );

    return randomQuests;
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
