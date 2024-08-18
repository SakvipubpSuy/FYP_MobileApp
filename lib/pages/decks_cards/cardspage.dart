import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/models/card.dart';
import 'package:fyp_mobileapp/pages/decks_cards/individualcardpage.dart';
import 'package:lottie/lottie.dart';
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

class _CardPageState extends State<CardPage> {
  late Future<List<CardModel>> futureCards;
  bool _loadingComplete = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Cards',
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF2F2F85),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              color: Color(0xFF2F2F85),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search cards...',
                          hintStyle: TextStyle(color: Colors.yellow[700]),
                          border: InputBorder.none,
                          prefixIcon:
                              Icon(Icons.search, color: Colors.yellow[700]),
                        ),
                        style: TextStyle(color: Colors.yellow[700]),
                        onChanged: _updateSearchQuery,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A1A4D), Color(0xFF2F2F85)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: FutureBuilder<List<CardModel>>(
                  future: futureCards,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Lottie.asset('assets/Cardpage.json'));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.yellow[700],
                              size: 80,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'No cards found',
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      List<CardModel> cards = snapshot.data!
                          .where((card) => card.cardName
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                          .toList();

                      if (cards.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.yellow[700],
                                size: 80,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'No cards found',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2 / 3,
                        ),
                        itemCount: cards.length,
                        padding: const EdgeInsets.all(10.0),
                        itemBuilder: (context, index) {
                          CardModel card = cards[index];
                          return CardWidget(
                            card: card,
                            deckName: widget.deckName,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final CardModel card;
  final String deckName;
  const CardWidget({super.key, required this.card, required this.deckName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          // color: Color(int.parse(
          //     card.cardTier.color.replaceFirst('#', '0xff'))), // Border color

          color: Color(0xFF1A1A4D),
          width: 5.0, // Border width
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(createRoute(IndividualCardPage(
            individualcard: card,
            deckName: deckName,
          )));
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.8),
                Color(int.parse(card.cardTier.color.replaceFirst('#', '0xff'))),
                const Color(0xFF2F2F85),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              card.imgUrl != null && card.imgUrl!.isNotEmpty
                  ? Image.network(
                      card.imgUrl!, // URL of the image
                      height: 80, // Set the height of the image
                      width: double.infinity, // Set the width of the image
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Icon(
                          Icons.image_not_supported,
                          size: 80,
                          color: Colors.grey,
                        );
                      }, // How the image should be fitted inside the container
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      size: 80, // Adjust the size as needed
                      color: Colors.grey,
                    ),
              const SizedBox(height: 10),
              Text(
                card.cardName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1A1A4D),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 10),
              Text(
                card.cardDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1A1A4D),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
