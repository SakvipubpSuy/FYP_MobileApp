import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/models/card.dart';
import 'package:fyp_mobileapp/pages/decks_cards/individualcardpage.dart';
import '../../api/card_service.dart';
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
  bool _loadingComplete = false;

  @override
  void initState() {
    super.initState();
    futureCards = CardService().getCardsByDeck(widget.deckId);
    _simulateLoadingDelay();
  }

  void _simulateLoadingDelay() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      _loadingComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.keyboard_arrow_left),
        ),
        title: Text(widget.deckName),
      ),
      body: FutureBuilder<List<CardModel>>(
        future: futureCards,
        builder: (context, snapshot) {
          if (!_loadingComplete) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
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
                return CardWidget(card: card);
              },
            );
          }
        },
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final CardModel card;

  const CardWidget({super.key, required this.card});

  Color getCardColor(String tierName) {
    switch (tierName.toLowerCase()) {
      case 'legend card':
        return Colors.orangeAccent; // Color for Legend tier
      case 'epic card':
        return Colors.purpleAccent[700]!; // Color for Epic tier
      default:
        return Colors.blueAccent; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(createRoute(IndividualCardPage(
            individualcard: card,
          )));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: getCardColor(card.cardTier.cardTierName),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                card.cardName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                card.cardDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
