import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fyp_mobileapp/models/trade.dart';
import '../../api/trade_service.dart';
import '../../api/deck_service.dart';
import '../../api/card_service.dart';
import '../../models/card.dart';

class TradeDetailsPage extends StatefulWidget {
  final int userId;
  final VoidCallback onTradeActionCompleted;

  const TradeDetailsPage({
    super.key,
    required this.userId,
    required this.onTradeActionCompleted,
  });

  @override
  _TradeDetailsPageState createState() => _TradeDetailsPageState();
}

class _TradeDetailsPageState extends State<TradeDetailsPage>
    with SingleTickerProviderStateMixin {
  final TradeService _tradeService = TradeService();
  final DeckService _deckService = DeckService();
  final CardService _cardService = CardService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  List<TradeModel> incomingTrades = [];
  List<TradeModel> outgoingTrades = [];
  List<TradeModel> pendingApprovalTrades = [];
  List<TradeModel> completedTrades = [];
  bool isLoading = true;
  Map<String, List<CardModel>> _tradableCards = {};

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchTrades();
    _fetchTradableCard();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchTrades() async {
    try {
      final trades = await _tradeService.fetchTradeRequest(widget.userId);
      setState(() {
        incomingTrades = trades['incoming_trades'] ?? [];
        outgoingTrades = trades['outgoing_trades'] ?? [];
        pendingApprovalTrades = trades['pending_approval_trades'] ?? [];
        completedTrades = trades['completed_trades'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch trades: $e')),
        );
      }
    }
  }

  // Future<void> _fetchTradableCard() async {
  //   try {
  //     final decks = await _deckService.getDecks();
  //     final deckMap = <String, List<CardModel>>{};

  //     for (var deck in decks) {
  //       final deckName = deck.deckName;
  //       final cards = await _cardService.getCardsByDeck(deck.deckId);
  //       final latestVersions = <String, int>{};

  //       for (var card in cards) {
  //         final cardName = card.cardName;
  //         final cardVersion = card.cardVersion;
  //         if (latestVersions.containsKey(cardName)) {
  //           if (latestVersions[cardName]! < cardVersion) {
  //             latestVersions[cardName] = cardVersion;
  //           }
  //         } else {
  //           latestVersions[cardName] = cardVersion;
  //         }
  //       }

  //       final filteredCards = cards.where((card) {
  //         final cardName = card.cardName;
  //         final cardVersion = card.cardVersion;
  //         return cardVersion < latestVersions[cardName]!;
  //       }).toList();

  //       if (filteredCards.isNotEmpty) {
  //         deckMap[deckName] = filteredCards;
  //       }
  //     }
  //     setState(() {
  //       _tradableCards = deckMap;
  //     });
  //   } catch (error) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to fetch decks: $error')),
  //       );
  //     }
  //   }
  // }

  Future<void> _fetchTradableCard() async {
    try {
      final decks = await _deckService.getDecks();
      final deckMap = <String, List<CardModel>>{};

      // Fetch cards for each deck
      for (var deck in decks) {
        final deckName = deck.deckName;
        final cards = await _cardService.getCardsByDeck(deck.deckId);

        // Add all cards to the deck, regardless of version
        if (cards.isNotEmpty) {
          deckMap[deckName] = cards;
        }
      }

      setState(() {
        _tradableCards = deckMap;
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch decks: $error')),
        );
      }
    }
  }

  Future<void> _acceptTrade(int tradeId) async {
    await _fetchTradableCard();
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => _buildTradableCardsDialog(tradeId),
      );
    }
  }

  Future<void> _confirmTrade(int tradeId, CardModel selectedCard) async {
    try {
      await _tradeService.acceptTradeRequest(tradeId, selectedCard.cardId);
      widget.onTradeActionCompleted();
      _fetchTrades();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trade accepted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to accept trade: $e')),
        );
      }
    }
  }

  Future<void> _denyTrade(int tradeId) async {
    try {
      await _tradeService.denyTradeRequest(tradeId);
      widget.onTradeActionCompleted();
      _fetchTrades();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trade denied')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete trade: $e')),
        );
      }
    }
  }

  Future<void> _cancelTrade(int tradeId) async {
    try {
      await _tradeService.cancelTradeRequest(tradeId);
      _fetchTrades();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trade canceled')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to deny trade: $e')),
        );
      }
    }
  }

  Future<void> _completeTrade(int tradeId) async {
    try {
      await _tradeService.completeTradeRequest(tradeId);
      widget.onTradeActionCompleted();
      _fetchTrades();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trade completed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to complete trade: $e')),
        );
      }
    }
  }

  Future<void> _revertTradeRequest(int tradeId) async {
    try {
      await _tradeService.revertTradeRequest(tradeId);
      widget.onTradeActionCompleted();
      _fetchTrades();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trade reverted to pending')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to revert trade: $e')),
        );
      }
    }
  }

  Widget _buildTradableCardsDialog(int tradeId) {
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
                    title: Text(card.cardName),
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
              onPressed: () {
                if (selectedCardId != null) {
                  final selectedCard = _tradableCards[selectedDeck!]
                      ?.firstWhere((card) => card.cardId == selectedCardId);
                  if (selectedCard != null) {
                    _confirmTrade(tradeId, selectedCard);
                    Navigator.of(context).pop(null);
                  }
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTradeCard(TradeModel trade, bool isIncoming,
      bool isPendingApproval, bool isCompleted) {
    return Card(
      child: ListTile(
        title: Text(isIncoming
            ? 'From: ${trade.initiatorName}'
            : 'To: ${trade.receiverName}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${trade.status}'),
            if (isPendingApproval) ...[
              Text('Your card: ${trade.initiatorId}'),
              Text('Received card: ${trade.receiverId}'),
            ],
            if (isCompleted) ...[
              Text('Your card: ${trade.initiatorId}'),
              Text('Received card: ${trade.receiverId}'),
            ],
          ],
        ),
        trailing: isPendingApproval
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _completeTrade(trade.tradeId);
                    },
                    child: const Text('Complete Trade'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      _revertTradeRequest(trade.tradeId);
                    },
                  ),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isIncoming && !isCompleted) ...[
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        _acceptTrade(trade.tradeId);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        _denyTrade(trade.tradeId);
                      },
                    ),
                  ] else if (!isIncoming && !isCompleted) ...[
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        _cancelTrade(trade.tradeId);
                      },
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildTradeList(List<TradeModel> trades, bool isIncoming,
      bool isPendingApproval, bool isCompleted) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: trades.length,
      itemBuilder: (context, index) {
        final trade = trades[index];
        return _buildTradeCard(
            trade, isIncoming, isPendingApproval, isCompleted);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trades'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            alignment: Alignment.centerLeft,
            child: TabBar(
              tabAlignment: TabAlignment.center,
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Incoming'),
                Tab(text: 'Outgoing'),
                Tab(text: 'Pending Approval'),
                Tab(text: 'Completed'),
              ],
              indicatorPadding: const EdgeInsets.symmetric(
                  horizontal: 10.0), // Remove padding around the indicator
              labelPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
              color: Colors.red.withOpacity(0.1),
              child: _buildTradeList(incomingTrades, true, false, false)),
          Container(
              color: Colors.blue.withOpacity(0.1),
              child: _buildTradeList(outgoingTrades, false, false, false)),
          Container(
              color: Colors.yellow.withOpacity(0.1),
              child:
                  _buildTradeList(pendingApprovalTrades, false, true, false)),
          Container(
              color: Colors.green.withOpacity(0.1),
              child: _buildTradeList(completedTrades, false, false, true)),
        ],
      ),
    );
  }
}
