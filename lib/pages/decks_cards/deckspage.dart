import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/pages/decks_cards/cardspage.dart';
import 'package:lottie/lottie.dart';
import '../../models/deck.dart';
import '../../utils/route.dart';
import '../../api/deck_service.dart';

class DeckPage extends StatefulWidget {
  const DeckPage({super.key});

  @override
  State<DeckPage> createState() => _DeckPageState();
}

class _DeckPageState extends State<DeckPage> {
  late Future<List<DeckModel>> futureDecks;
  bool _loadingComplete = false;

  @override
  void initState() {
    super.initState();
    futureDecks = DeckService().getDecks();
    _simulateLoadingDelay();
  }

  void _simulateLoadingDelay() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _loadingComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Deck Page'),
      ),
      body: FutureBuilder<List<DeckModel>>(
        future: futureDecks,
        builder: (context, snapshot) {
          if (!_loadingComplete) {
            return Center(child: Lottie.asset('assets/LoadingAnimation.json'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Lottie.asset('assets/LoadingAnimation.json'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No decks found'));
          } else {
            List<DeckModel> decks = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2 / 3,
              ),
              itemCount: decks.length,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (context, index) {
                DeckModel deck = decks[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(createRoute(CardPage(
                        deckId: deck.deckId,
                        deckName: deck.deckName,
                      )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            deck.deckName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            deck.deckDescription,
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
