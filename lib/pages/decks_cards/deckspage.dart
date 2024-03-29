import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/pages/decks_cards/cardspage.dart';
import '../../models/deck.dart';

class DeckPage extends StatefulWidget {
  const DeckPage({super.key});

  @override
  State<DeckPage> createState() => _DeckPageState();
}

List<DeckModel> decks = List<DeckModel>.generate(
  21,
  (index) => DeckModel(
      title: 'Item $index', content: 'Content for card $index', cards: []),
);

class _DeckPageState extends State<DeckPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CardPage(
                                  deck: deck, key: ValueKey(deck.title)),
                            ),
                          );
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
