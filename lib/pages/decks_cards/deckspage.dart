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

  @override
  void initState() {
    super.initState();
    futureDecks = DeckService().getDecks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Deck Page',
          style: TextStyle(
            color: Colors.grey[800]!,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<DeckModel>>(
        future: futureDecks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Lottie.asset('assets/Deckpage.json'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No decks found'));
          } else {
            List<DeckModel> decks = snapshot.data!;
            return PageView.builder(
              itemCount: (decks.length / 9).ceil(), // Number of pages
              itemBuilder: (context, pageIndex) {
                int startIndex = pageIndex * 9;
                int endIndex = (startIndex + 9).clamp(0, decks.length);
                List<DeckModel> pageDecks = decks.sublist(startIndex, endIndex);

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2 / 3,
                    ),
                    itemCount: pageDecks.length,
                    itemBuilder: (context, index) {
                      DeckModel deck = pageDecks[index];
                      double progress = deck.totalCardCount > 0
                          ? deck.scannedCardCount / deck.totalCardCount
                          : 0.0;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: Color(0xFF2F2F85), // Border color
                            width: 5.0, // Border width
                          ),
                        ),
                        elevation: 5,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(createRoute(CardPage(
                              deckId: deck.deckId,
                              deckName: deck.deckName,
                            )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              gradient: LinearGradient(
                                colors: [Colors.blue[900]!, Colors.blue[600]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
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
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1, // Limit to 2 lines
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    deck.deckDescription,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 0.702),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2, // Limit to 3 lines
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.white24,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.greenAccent),
                                    ),
                                  ),
                                  Text(
                                    '${deck.scannedCardCount} / ${deck.totalCardCount} cards',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
