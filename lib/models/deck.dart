import 'card.dart';

class DeckModel {
  final String title;
  final String content;
  final List<CardModel> cards;
  DeckModel({required this.title, required this.content, required this.cards});

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      title: json['title'],
      content: json['content'],
      cards: json['cards'],
    );
  }
}
