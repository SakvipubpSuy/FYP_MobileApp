import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/pages/decks_cards/cardspage.dart';
import '../../models/card.dart';
import '../../models/deck.dart';
import '../../utils/route.dart';

class DeckPage extends StatefulWidget {
  const DeckPage({super.key});

  @override
  State<DeckPage> createState() => _DeckPageState();
}

List<DeckModel> decks = List<DeckModel>.generate(
  21,
  (index) => DeckModel(
    title: 'Deck $index',
    content: 'Content for card $index',
    cards: List<CardModel>.generate(
        5,
        (cardIndex) => CardModel(
            title: 'Card $cardIndex of Deck $index',
            content: 'Content for Card $cardIndex of Deck $index')),
  ),
);

class _DeckPageState extends State<DeckPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Deck Page'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Search"),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.blue,
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: decks.map((deck) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(createRoute(CardPage(
                              deck: deck,
                              key: ValueKey(deck.title),
                              cards: deck.cards)));
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => CardPage(
                          //         deck: deck, key: ValueKey(deck.title)),
                          //   ),
                          // );
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(deck.title),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
