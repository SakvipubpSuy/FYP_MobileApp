class DeckModel {
  final int deckId;
  final String deckName;
  final String deckDescription;
  final int totalXP;
  final int userXP;
  final String? imgUrl;
  final String createdAt;
  final String updatedAt;
  final String? title;

  DeckModel({
    required this.deckId,
    required this.deckName,
    required this.deckDescription,
    required this.totalXP,
    required this.userXP,
    this.imgUrl,
    required this.createdAt,
    required this.updatedAt,
    this.title,
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
      totalXP: json['total_XP'],
      userXP: json['user_XP'],
      imgUrl: json['img_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deck_id': deckId,
      'deck_name': deckName,
      'deck_description': deckDescription,
      'total_XP': totalXP,
      'user_XP': userXP,
      'img_url': imgUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'title': title,
    };
  }

  // Convert DeckModel to Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'deck_id': deckId,
      'deck_name': deckName,
      'deck_description': deckDescription,
      'total_XP': totalXP,
      'user_XP': userXP,
      'img_url': imgUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'title': title,
    };
  }

  // Create DeckModel from Map (SQLite storage)
  factory DeckModel.fromMap(Map<String, dynamic> map) {
    return DeckModel(
      deckId: map['deck_id'],
      deckName: map['deck_name'],
      deckDescription: map['deck_description'],
      totalXP: map['total_XP'],
      userXP: map['user_XP'],
      imgUrl: map['img_url'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      title: map['title'],
    );
  }
}
