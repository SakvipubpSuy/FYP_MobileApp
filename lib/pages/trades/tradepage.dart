import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../api/card_service.dart';
import '../../api/trade_service.dart';
import '../../api/deck_service.dart';
import '../../api/user_service.dart';
import '../../models/card.dart';
import 'tradedetailspage.dart';

class TradePage extends StatefulWidget {
  const TradePage({super.key});

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  final TextEditingController _searchController = TextEditingController();
  final TradeService _tradeService = TradeService();
  final DeckService _deckService = DeckService();
  final CardService _cardService = CardService();
  final UserService _userService = UserService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? userID;
  int _incomingTradeCount = 0;
  bool _isLoading = true;
  Map<String, List<CardModel>> _tradableCards = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _getUserID();
    _countTrades();
    _fetchTradableCard();
  }

  Future<void> _getUserID() async {
    userID = await _storage.read(key: 'userID');
    setState(() {});
  }

  Future<void> _countTrades() async {
    try {
      int incomingCount = await _tradeService.countTrades('incoming');
      setState(() {
        _incomingTradeCount = incomingCount;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle the error appropriately, maybe show a SnackBar
    }
  }

  Future<void> _fetchTradableCard() async {
    try {
      if (userID != null) {
        final decks = await _deckService.getDecks();
        final deckMap = <String, List<CardModel>>{};

        for (var deck in decks) {
          final deckName = deck.deckName;
          final cards = await _cardService.getCardsByDeck(deck.deckId);

          if (cards.isNotEmpty) {
            deckMap[deckName] = cards;
          }
        }

        setState(() {
          _tradableCards = deckMap;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch decks: $error')),
        );
      }
    }
  }

  void _navigateToTradeDetailsPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => TradeDetailsPage(
                  userId: int.parse(userID!),
                  onTradeActionCompleted: () => _countTrades(),
                )))
        .then((_) =>
            _countTrades()); // Refresh incoming trade count after returning
  }

  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  void _onSearchChanged() {
    setState(() {
      _isSearching = true;
    });

    _userService.getAllUsers().then((users) {
      final currentUserID = userID;
      setState(() {
        _isSearching = false;
        _searchResults = _searchController.text.isEmpty
            ? []
            : users.where((user) {
                final username = user['name'].toLowerCase();
                final searchQuery = _searchController.text.toLowerCase();
                final userID = user['id'].toString();
                return username.contains(searchQuery) &&
                    userID != currentUserID;
              }).toList();
      });
    }).catchError((error) {
      setState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch users: $error')),
      );
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildDeckSelectionDialog() {
    String? selectedDeck;
    int? selectedCardId;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Select Card to Trade'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                hint: const Text('Select Deck'),
                value: selectedDeck,
                onChanged: (value) {
                  setState(() {
                    selectedDeck = value;
                    selectedCardId = null;
                  });
                },
                items: _tradableCards.keys.map((deckName) {
                  return DropdownMenuItem<String>(
                    value: deckName,
                    child: Text(deckName),
                  );
                }).toList(),
              ),
              if (selectedDeck != null) ...[
                const SizedBox(height: 16),
                Text('Select Card from $selectedDeck'),
                ..._tradableCards[selectedDeck]!.map<Widget>((card) {
                  return RadioListTile<int>(
                    title: Row(
                      children: [
                        if (card.imgUrl != null)
                          Image.network(
                            card.imgUrl!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        else
                          const Icon(Icons.image_not_supported,
                              size: 40, color: Colors.grey),
                        const SizedBox(width: 10),
                        Text(card.cardName),
                      ],
                    ),
                    value: card.cardId,
                    groupValue: selectedCardId,
                    onChanged: (value) {
                      setState(() {
                        selectedCardId = value;
                      });
                    },
                  );
                }),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(selectedCardId),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendTradeRequest(int initiatorId, int receiverId) async {
    if (_tradableCards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No tradable cards available')),
      );
      return;
    }

    int? selectedCardId = await showDialog<int>(
      context: context,
      builder: (context) => _buildDeckSelectionDialog(),
    );

    if (selectedCardId != null) {
      // Send the trade request with the selected card ID
      if (mounted) {
        await _tradeService.sendTradeRequest(
            context, initiatorId, receiverId, selectedCardId);
      }
      // Refresh the user cards after sending the trade request
      await _fetchTradableCard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF2F2F85),
        title: Text(
          'Trade Page',
          style: TextStyle(
            color: Colors.yellow[700],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            children: [
              Transform.scale(
                scale: 1.5, // Adjust this value to make the button bigger
                child: IconButton(
                  icon: Icon(
                    Icons.notifications_none,
                    size: 24,
                    color: Colors.yellow[700],
                  ),
                  onPressed: _navigateToTradeDetailsPage,
                ),
              ),
              if (_incomingTradeCount > 0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Center(
                      child: Text(
                        '$_incomingTradeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A1A4D), Color(0xFF2F2F85)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: const Center(
                  child: CircularProgressIndicator(color: Colors.amber)),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A1A4D), Color(0xFF2F2F85)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Search Players',
                        labelStyle: TextStyle(color: Colors.amber),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.amber),
                        hintText: 'Search Players',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: Colors.amber)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isSearching)
                      const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      )
                    else if (_searchResults.isEmpty)
                      Center(
                        child: _searchController.text.isEmpty
                            ? const Text(
                                'Enter player name to start searching',
                                style: TextStyle(color: Colors.white),
                              )
                            : const Text(
                                'No players found',
                                style: TextStyle(color: Colors.amber),
                              ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final user = _searchResults[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.amber,
                                child: Text(
                                  '${user['name'][0]}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1A4D),
                                  ),
                                ),
                              ),
                              title: Text(user['name'],
                                  style: const TextStyle(color: Colors.white)),
                              onTap: () async {
                                await _fetchTradableCard();
                                await _sendTradeRequest(
                                  int.parse(userID!),
                                  user['id'],
                                );
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}



//FETCH CARD WITH VERSION CHECK
  // Future<void> _fetchTradableCard() async {
  //   try {
  //     if (userID != null) {
  //       final decks = await _deckService.getDecks();
  //       final deckMap = <String, List<CardModel>>{};

  //       // Fetch cards for each deck
  //       for (var deck in decks) {
  //         final deckName = deck.deckName;
  //         final cards = await _cardService.getCardsByDeck(deck.deckId);
  //         final latestVersions = <String, int>{};

  //         //   // Find the latest version for each card in the deck
  //         for (var card in cards) {
  //           final cardName = card.cardName;
  //           final cardVersion = card.cardVersion;
  //           if (latestVersions.containsKey(cardName)) {
  //             if (latestVersions[cardName]! < cardVersion) {
  //               latestVersions[cardName] = cardVersion;
  //             }
  //           } else {
  //             latestVersions[cardName] = cardVersion;
  //           }
  //         }

  //         //   // // Filter out the latest versions
  //         final filteredCards = cards.where((card) {
  //           final cardName = card.cardName;
  //           final cardVersion = card.cardVersion;
  //           return cardVersion < latestVersions[cardName]!;
  //         }).toList();

  //         // Only add decks that have tradable cards
  //         if (filteredCards.isNotEmpty) {
  //           deckMap[deckName] = filteredCards;
  //         }
  //       }
  //       setState(() {
  //         _tradableCards = deckMap;
  //       });
  //     }
  //   } catch (error) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to fetch decks: $error')),
  //       );
  //     }
  //   }
  // }