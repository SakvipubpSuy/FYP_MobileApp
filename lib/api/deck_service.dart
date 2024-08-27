import 'dart:convert';
import 'package:fyp_mobileapp/models/deck.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../db/deck_helper.dart';
import 'api_url.dart';

class DeckService {
  String baseUrl = ApiURL.baseUrl;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final DeckDbHelper _deckDbHelper = DeckDbHelper();

  Future<List<DeckModel>> getDecks() async {
    String? token = await _storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('No auth token found');
    }

    try {
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

        // Save decks to local database
        List<Map<String, dynamic>> decksToSave =
            decks.map((deck) => deck.toMap()).toList();
        await _deckDbHelper.insertDecks(decksToSave);

        return decks;
      } else {
        throw Exception('Failed to fetch deck information');
      }
    } catch (e) {
      // Offline mode: Fetch decks from local database
      List<Map<String, dynamic>> localDecks = await _deckDbHelper.getDecks();
      List<DeckModel> decks =
          localDecks.map((deck) => DeckModel.fromJson(deck)).toList();
      return decks;
    }
  }
}
