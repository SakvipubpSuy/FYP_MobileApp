import 'package:fyp_mobileapp/models/card_tier.dart';

class CardModel {
  final int cardId;
  final int? parentCardId;
  final int deckId;
  final int cardTierId;
  final String cardName;
  final String cardDescription;
  final int cardVersion;
  final String? createdAt;
  final String? updatedAt;
  final CardTierModel cardTier;

  CardModel({
    required this.cardId,
    this.parentCardId,
    required this.deckId,
    required this.cardTierId,
    required this.cardName,
    required this.cardDescription,
    required this.cardVersion,
    this.createdAt,
    this.updatedAt,
    required this.cardTier,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      cardId: json['card_id'],
      parentCardId: json['parent_card_id'],
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
      'parent_card_id': parentCardId,
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
