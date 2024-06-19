// class CardModel {
//   final String title;
//   final String content;

//   CardModel({required this.title, required this.content});

//   factory CardModel.fromJson(Map<String, dynamic> json) {
//     return CardModel(
//       title: json['title'],
//       content: json['content'],
//     );
//   }
// }
class CardModel {
  int cardId;
  int deckId;
  String cardTier;
  String cardName;
  String cardDescription;
  String cardVersion;
  String createdAt;
  String updatedAt;

  CardModel({
    required this.cardId,
    required this.deckId,
    required this.cardTier,
    required this.cardName,
    required this.cardDescription,
    required this.cardVersion,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      cardId: json['card_id'],
      deckId: json['deck_id'],
      cardTier: json['card_tier'],
      cardName: json['card_name'],
      cardDescription: json['card_description'],
      cardVersion: json['card_version'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card_id': cardId,
      'deck_id': deckId,
      'card_tier': cardTier,
      'card_name': cardName,
      'card_description': cardDescription,
      'card_version': cardVersion,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
