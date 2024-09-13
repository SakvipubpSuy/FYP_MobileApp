import 'package:sqflite/sqflite.dart';
import '../db/db_helper.dart';
import '../models/card.dart';

class CardDbHelper {
  // Singleton pattern to ensure a single instance of CardDbHelper
  static final CardDbHelper _instance = CardDbHelper._internal();
  factory CardDbHelper() => _instance;
  CardDbHelper._internal();

  // Save card and its related card tier
  Future<void> saveCard(CardModel card) async {
    // Get the database instance
    final db = await DatabaseHelper().database;
    // Print before saving
    print('Saving card: ${card.toMap()}');
    // Insert the cardTier if it doesn't already exist
    await db.insert(
      'card_tiers',
      card.cardTier.toMap(), // Use toMap() instead of toJson()
      conflictAlgorithm:
          ConflictAlgorithm.ignore, // Ignore if it already exists
    );

    // Insert the card, ensuring to include the 'card_tier_id'
    Map<String, dynamic> cardData = card.toMap();
    cardData['card_tier_id'] = card.cardTier.cardTierId; // Ensure this is set

    cardData.remove('card_tier'); // Remove the nested card_tier map

    await db.insert(
      'cards',
      cardData,
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Replace if it already exists
    );
  }

  // Get cards by deck with their card tiers
  Future<List<CardModel>> getCardsByDeck(int deckId) async {
    final db = await DatabaseHelper().database;

    // Join cards and card_tiers tables to get the full card data including the tier
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT cards.*, card_tiers.*
      FROM cards
      LEFT JOIN card_tiers ON cards.card_tier_id = card_tiers.card_tier_id
      WHERE cards.deck_id = ?
    ''', [deckId]);

    // Map the results to CardModel
    List<CardModel> cards = maps.map((map) {
      return CardModel.fromMap({
        ...map,
        'card_tier': {
          'card_tier_id': map['card_tier_id'],
          'card_tier_name': map['card_tier_name'],
          'card_XP': map['card_XP'],
          'card_energy_required': map['card_energy_required'],
          'created_at': map['created_at'],
          'updated_at': map['updated_at'],
          'color': map['color'],
        }
      });
    }).toList();
    print(cards);
    return cards;
  }

  // Count the number of cards in the local database
  Future<int> getLocalCardCount() async {
    final db = await DatabaseHelper().database;
    int count = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM cards')) ??
        0;
    return count;
  }
}
