// import 'card.dart';

// class DeckModel {
//   final String title;
//   final String content;
//   final List<CardModel> cards;
//   DeckModel({required this.title, required this.content, required this.cards});

//   factory DeckModel.fromJson(Map<String, dynamic> json) {
//     return DeckModel(
//       title: json['title'],
//       content: json['content'],
//       cards: json['cards'],
//     );
//   }
// }

class DeckModel {
  final int deckId;
  final String deckName;
  final String deckDescription;
  final int totalCardCount;
  final int scannedCardCount;
  final String createdAt;
  final String updatedAt;

  DeckModel({
    required this.deckId,
    required this.deckName,
    required this.deckDescription,
    required this.totalCardCount,
    required this.scannedCardCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      deckId: json['deck_id'],
      deckName: json['deck_name'],
      deckDescription: json['deck_description'],
      totalCardCount: json['total_cards_count'],
      scannedCardCount: json['scanned_cards_count'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deck_id': deckId,
      'deck_name': deckName,
      'deck_description': deckDescription,
      'total_cards_count': totalCardCount,
      'scanned_cards_count': scannedCardCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
