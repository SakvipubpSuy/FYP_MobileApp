class DeckModel {
  final int deckId;
  final String deckName;
  final String deckDescription;
  final int totalCardCount;
  final int scannedCardCount;
  final String? imgUrl;
  final String createdAt;
  final String updatedAt;

  DeckModel({
    required this.deckId,
    required this.deckName,
    required this.deckDescription,
    required this.totalCardCount,
    required this.scannedCardCount,
    this.imgUrl,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  String toString() {
    return 'DeckModel(deckId: $deckId, deckName: $deckName)';
  }

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      deckId: json['deck_id'],
      deckName: json['deck_name'],
      deckDescription: json['deck_description'],
      totalCardCount: json['total_cards_count'],
      scannedCardCount: json['scanned_cards_count'],
      imgUrl: json['img_url'],
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
      'img_url': imgUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Convert DeckModel to Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'deck_id': deckId,
      'deck_name': deckName,
      'deck_description': deckDescription,
      'total_cards_count': totalCardCount,
      'scanned_cards_count': scannedCardCount,
      'img_url': imgUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Create DeckModel from Map (SQLite storage)
  factory DeckModel.fromMap(Map<String, dynamic> map) {
    return DeckModel(
      deckId: map['deck_id'],
      deckName: map['deck_name'],
      deckDescription: map['deck_description'],
      totalCardCount: map['total_cards_count'],
      scannedCardCount: map['scanned_cards_count'],
      imgUrl: map['img_url'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}
