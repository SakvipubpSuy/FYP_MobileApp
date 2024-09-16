import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/models/quest.dart';
import 'package:fyp_mobileapp/models/user.dart';
import 'package:lottie/lottie.dart';
import '../api/card_service.dart';
import '../api/trade_service.dart'; // Add this import for trade counts
import '../api/user_service.dart';
import '../utils/connectivity_service.dart';
import '../utils/route.dart';
import '../widgets/statistic_card_component.dart';
import 'no_connection_page.dart';
import 'qrscanpage.dart';
import 'quests/questdetailpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CardService _cardService = CardService();
  final CardService _questService = CardService();
  final TradeService _tradeService =
      TradeService(); // Add this for trade counts

  late Future<UserModel> _futureUser;
  late Future<List<QuestionModel>> _futureQuest;
  Future<int>? _incomingTradeCount; // Initialize with nullable
  Future<int>? _outgoingTradeCount; // Initialize with nullable
  Future<int>? _pendingApprovalTradeCount; // Initialize with nullable

  int? _totalCards;
  UserModel? _user;
  bool _hasConnection = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchTotalCards();
    _checkConnectivity();
    _futureQuest = _questService.getQuests();
    _incomingTradeCount = _tradeService.countTrades('incoming');
    _outgoingTradeCount = _tradeService.countTrades('outgoing');
    _pendingApprovalTradeCount = _tradeService.countTrades('pending_approval');
  }

  void _checkConnectivity() async {
    final connectivityService = ConnectivityService();
    _hasConnection = await connectivityService.checkConnection();

    if (!_hasConnection) {
      if (mounted) {
        setState(() {}); // Trigger UI update to show no connection page
      }
    }

    // Listen to connectivity changes
    connectivityService.onConnectivityChanged.listen((isConnected) {
      if (!isConnected && mounted) {
        setState(() {
          _hasConnection = false;
        });
      } else if (isConnected && mounted) {
        setState(() {
          _hasConnection = true;
        });
        // Refresh the quests when the connection is restored
        _fetchQuests();
      }
    });
  }

  void _fetchQuests() {
    setState(() {
      _futureQuest = _questService.getQuests();
    });
  }

  void _fetchUserData() {
    _futureUser = UserService().getCurrentUser();
    _futureUser.then((user) {
      if (mounted) {
        setState(() {
          _user = user;
        });
      }
    });
  }

  void _fetchTotalCards() async {
    try {
      final totalCards = await _cardService.countUserTotalCards();
      if (!mounted) return;
      setState(() {
        _totalCards = totalCards;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch total cards: $e')),
      );
    }
  }

  void _updateUserData() {
    setState(() {
      _futureUser = UserService().getCurrentUser();
      _futureUser.then((user) {
        if (mounted) {
          setState(() {
            _user = user;
          });
        }
      });
    });
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
          child: FutureBuilder<UserModel>(
            future: _futureUser,
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.asset('assets/Homepage.json'),
                );
              } else if (userSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${userSnapshot.error}'),
                );
              } else if (userSnapshot.hasData) {
                _user = userSnapshot.data;
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/icons/icon_test.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                'Welcome, ${_user?.name ?? 'User'}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(createRoute(const QRScan()));
                                  },
                                  child: const Icon(
                                    Icons.qr_code_scanner_outlined,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 40),
                          Row(
                            children: [
                              StatisticCard(
                                gradient: const LinearGradient(
                                  colors: [Colors.amber, Colors.orange],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                title: 'Total Energy',
                                value: _user?.energy.toString() ?? '0',
                                fontSizeOption: FontSizeOption.medium,
                              ),
                              const SizedBox(width: 10),
                              StatisticCard(
                                gradient: const LinearGradient(
                                  colors: [Colors.pink, Colors.red],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                title: 'Your Card',
                                value: _totalCards?.toString() ?? '0',
                                fontSizeOption: FontSizeOption.medium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              FutureBuilder<int>(
                                future: _incomingTradeCount,
                                builder: (context, tradeSnapshot) {
                                  return StatisticCard(
                                    gradient: const LinearGradient(
                                      colors: [Colors.green, Colors.lightGreen],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                    title: 'Incoming Trades',
                                    value: tradeSnapshot.hasData
                                        ? tradeSnapshot.data.toString()
                                        : '0',
                                    fontSizeOption: FontSizeOption.small,
                                  );
                                },
                              ),
                              const SizedBox(width: 6),
                              FutureBuilder<int>(
                                future: _outgoingTradeCount,
                                builder: (context, tradeSnapshot) {
                                  return StatisticCard(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.brown,
                                        Colors.brown[300]!
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                    title: 'Outgoing Trades',
                                    value: tradeSnapshot.hasData
                                        ? tradeSnapshot.data.toString()
                                        : '0',
                                    fontSizeOption: FontSizeOption.small,
                                  );
                                },
                              ),
                              const SizedBox(width: 5),
                              FutureBuilder<int>(
                                future: _pendingApprovalTradeCount,
                                builder: (context, tradeSnapshot) {
                                  return StatisticCard(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.deepOrange,
                                        Colors.orange
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                    title: 'Pending Approval',
                                    value: tradeSnapshot.hasData
                                        ? tradeSnapshot.data.toString()
                                        : '0',
                                    fontSizeOption: FontSizeOption.small,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.4,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            border: Border(
                              top: BorderSide(
                                color: Colors.yellow[700]!,
                                width: 5,
                              ),
                              left: BorderSide(
                                color: Colors.yellow[700]!,
                                width: 5,
                              ),
                              right: BorderSide(
                                color: Colors.yellow[700]!,
                                width: 5,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Quests',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: FutureBuilder<List<QuestionModel>>(
                                    future: _futureQuest,
                                    builder: (context, questSnapshot) {
                                      if (!_hasConnection) {
                                        // Show NoConnectionPage if no connection
                                        return NoConnectionPage();
                                      }
                                      if (questSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (questSnapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${questSnapshot.error}'));
                                      } else if (questSnapshot.hasData) {
                                        List<QuestionModel> quests =
                                            questSnapshot.data!;
                                        return ListView.builder(
                                          itemCount: quests.length,
                                          itemBuilder: (context, index) {
                                            QuestionModel quest = quests[index];
                                            return Card(
                                                child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    const Color.fromARGB(
                                                        255, 12, 58, 118)!,
                                                    const Color.fromARGB(
                                                        255, 11, 104, 210)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: ListTile(
                                                title: Text(
                                                  quest.question,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  // Change text color to white
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          QuestionDetailPage(
                                                        quest: quest,
                                                        onEnergyUpdated:
                                                            _updateUserData,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ));
                                          },
                                        );
                                      } else {
                                        return const Center(
                                            child: Text('No quests available'));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text('No user data available'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
