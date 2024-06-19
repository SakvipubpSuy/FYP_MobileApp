import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/models/card.dart';
import 'package:fyp_mobileapp/pages/decks_cards/individualcardpage.dart';
import '../../api/card_service.dart';
import '../../models/deck.dart';
import '../../utils/route.dart';

class CardPage extends StatefulWidget {
  final int deckId;
  final String deckName;
  const CardPage({
    super.key,
    required this.deckId,
    required this.deckName,
  });

  @override
  State<CardPage> createState() => _CardPageState();
}
// List<CardModel> cards = List<CardModel>.generate(
//   25,
//   (index) =>
//       CardModel(title: 'Item $index', content: 'Content for card $index'),
// );

class _CardPageState extends State<CardPage> {
  late Future<List<CardModel>> futureCards;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCards = CardService().getCardsByDeck(widget.deckId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deckName),
      ),
      body: FutureBuilder<List<CardModel>>(
        future: futureCards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cards found'));
          } else {
            List<CardModel> cards = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2 / 3,
              ),
              itemCount: cards.length,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (context, index) {
                CardModel card = cards[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(createRoute(IndividualCardPage(
                        individualcard: card,
                      )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            card.cardName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            card.cardDescription,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
