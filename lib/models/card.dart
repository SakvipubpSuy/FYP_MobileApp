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

import 'package:fyp_mobileapp/models/card_tier.dart';

class CardModel {
  final int cardId;
  final int deckId;
  final int cardTierId;
  final String cardName;
  final String cardDescription;
  final String cardVersion;
  final String createdAt;
  final String updatedAt;
  final CardTierModel cardTier;

  CardModel({
    required this.cardId,
    required this.deckId,
    required this.cardTierId,
    required this.cardName,
    required this.cardDescription,
    required this.cardVersion,
    required this.createdAt,
    required this.updatedAt,
    required this.cardTier,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      cardId: json['card_id'],
      deckId: json['deck_id'],
      cardTierId: json['card_tier_id'],
      cardName: json['card_name'],
      cardDescription: json['card_description'],
      cardVersion: json['card_version'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      cardTier: CardTierModel.fromJson(json['card_tier']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card_id': cardId,
      'deck_id': deckId,
      'card_tier_id': cardTierId,
      'card_name': cardName,
      'card_description': cardDescription,
      'card_version': cardVersion,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'card_tier': cardTier.toJson(),
    };
  }
}
