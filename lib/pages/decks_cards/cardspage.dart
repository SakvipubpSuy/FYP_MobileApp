import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/models/card.dart';
import 'package:fyp_mobileapp/pages/decks_cards/individualcardpage.dart';
import '../../models/deck.dart';

class CardPage extends StatefulWidget {
  final DeckModel deck;
  CardPage({
    required Key key,
    required this.deck,
    required List<CardModel> cards,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.title),
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
                    children: widget.deck.cards.map((individualcard) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IndividualCardPage(
                                  individualcard: individualcard,
                                  key: ValueKey(individualcard.title)),
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(individualcard.title),
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
