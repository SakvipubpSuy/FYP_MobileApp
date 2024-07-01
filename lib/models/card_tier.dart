class CardTierModel {
  final int cardTierId;
  final String cardTierName;
  final int cardXP;
  final int cardEnergyRequired;
  final String createdAt;
  final String updatedAt;

  CardTierModel({
    required this.cardTierId,
    required this.cardTierName,
    required this.cardXP,
    required this.cardEnergyRequired,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CardTierModel.fromJson(Map<String, dynamic> json) {
    return CardTierModel(
      cardTierId: json['card_tier_id'],
      cardTierName: json['card_tier_name'],
      cardXP: json['card_XP'],
      cardEnergyRequired: json['card_energy_required'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card_tier_id': cardTierId,
      'card_tier_name': cardTierName,
      'card_XP': cardXP,
      'card_energy_required': cardEnergyRequired,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
