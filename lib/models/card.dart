class CardModel {
  final String title;
  final String content;

  CardModel({required this.title, required this.content});

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      title: json['title'],
      content: json['content'],
    );
  }
}
