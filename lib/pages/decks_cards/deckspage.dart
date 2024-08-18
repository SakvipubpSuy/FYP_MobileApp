import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/pages/decks_cards/cardspage.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    futureDecks = DeckService().getDecks();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A4D), Color(0xFF2F2F85)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                color: const Color(0xFF2F2F85),
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
                            hintText: 'Search decks...',
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
                  child: FutureBuilder<List<DeckModel>>(
                    future: futureDecks,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Lottie.asset('assets/Deckpage.json'));
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
                                'No decks found',
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
                        List<DeckModel> decks = snapshot.data!
                            .where((deck) => deck.deckName
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase()))
                            .toList();

                        if (decks.isEmpty) {
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
                                  'No decks found',
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

                        return Column(
                          children: [
                            Expanded(
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: (decks.length / 4)
                                    .ceil(), // Number of pages
                                itemBuilder: (context, pageIndex) {
                                  int startIndex = pageIndex * 4;
                                  int endIndex =
                                      (startIndex + 4).clamp(0, decks.length);
                                  List<DeckModel> pageDecks =
                                      decks.sublist(startIndex, endIndex);

                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 2 / 3,
                                      ),
                                      itemCount: pageDecks.length,
                                      itemBuilder: (context, index) {
                                        DeckModel deck = pageDecks[index];
                                        double progress =
                                            deck.totalCardCount > 0
                                                ? deck.scannedCardCount /
                                                    deck.totalCardCount
                                                : 0.0;

                                        return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: const BorderSide(
                                              color: Color(
                                                  0xFF2F2F85), // Border color
                                              width: 5.0, // Border width
                                            ),
                                          ),
                                          elevation: 5,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(createRoute(CardPage(
                                                deckId: deck.deckId,
                                                deckName: deck.deckName,
                                              )));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFF1A1A4D),
                                                    Color(0xFF2F2F85)
                                                  ],
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // Check if the imgUrl is null or empty
                                                    deck.imgUrl != null &&
                                                            deck.imgUrl!
                                                                .isNotEmpty
                                                        ? Image.network(
                                                            deck.imgUrl!,
                                                            fit: BoxFit.cover,
                                                            height:
                                                                80, // Adjust the height as needed
                                                            width:
                                                                double.infinity,
                                                            errorBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Object
                                                                        exception,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                              return const Icon(
                                                                Icons
                                                                    .image_not_supported,
                                                                size: 80,
                                                                color:
                                                                    Colors.grey,
                                                              );
                                                            },
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .image_not_supported,
                                                            size:
                                                                80, // Adjust the size as needed
                                                            color: Colors.grey,
                                                          ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      deck.deckName,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines:
                                                          1, // Limit to 1 line
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      deck.deckDescription,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromRGBO(
                                                            255,
                                                            255,
                                                            255,
                                                            0.702),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines:
                                                          1, // Limit to 2 lines
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10.0),
                                                      child:
                                                          LinearProgressIndicator(
                                                        value: progress,
                                                        backgroundColor:
                                                            Colors.white24,
                                                        valueColor:
                                                            const AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors
                                                                    .greenAccent),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${deck.scannedCardCount} / ${deck.totalCardCount} cards',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.amber,
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
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SmoothPageIndicator(
                                controller: _pageController,
                                count: (decks.length / 4).ceil(),
                                effect: WormEffect(
                                  dotColor: Colors.white24,
                                  activeDotColor: Colors.yellow[700]!,
                                  dotHeight: 10.0,
                                  dotWidth: 10.0,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
