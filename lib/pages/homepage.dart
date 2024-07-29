import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/models/quest.dart';
import 'package:fyp_mobileapp/models/user.dart';
import 'package:lottie/lottie.dart';
import '../api/card_service.dart';
import '../api/user_service.dart';
import '../utils/route.dart';
import '../widgets/statistic_card_component.dart';
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
  late Future<UserModel> _futureUser;
  late Future<List<QuestionModel>> _futureQuest;

  int? _totalCards;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchTotalCards();
    _futureQuest = _questService.getQuests();
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
      backgroundColor: const Color(0xFF2F2F85),
      body: SafeArea(
        child: FutureBuilder<UserModel>(
          future: _futureUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset('assets/Homepage.json'),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              _user = snapshot.data;
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
                              color: Colors.amber,
                              title: 'Total Energy',
                              value: _user?.energy.toString() ?? '0',
                            ),
                            const SizedBox(width: 10),
                            StatisticCard(
                              color: Colors.pink,
                              title: 'Your Card',
                              value: _totalCards?.toString() ?? '0',
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            StatisticCard(
                              color: Colors.green,
                              title: 'Title 1',
                              value: 'Value 1',
                            ),
                            const SizedBox(width: 5),
                            StatisticCard(
                              color: Colors.brown,
                              title: 'Title 2',
                              value: 'Value 2',
                            ),
                            const SizedBox(width: 5),
                            StatisticCard(
                              color: Colors.deepOrange,
                              title: 'Title 3',
                              value: 'Value 3',
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
                        decoration: const BoxDecoration(
                          color:
                              Colors.white, // Change this to your desired color
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                'Quest',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: FutureBuilder<List<QuestionModel>>(
                                  future: _futureQuest,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      List<QuestionModel> quests =
                                          snapshot.data!;
                                      return ListView.builder(
                                        itemCount: quests.length,
                                        itemBuilder: (context, index) {
                                          QuestionModel quest = quests[index];
                                          return Card(
                                            child: ListTile(
                                              title: Text(quest.question),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        QuestionDetailPage(
                                                            quest: quest,
                                                            onEnergyUpdated:
                                                                _updateUserData),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return Center(
                                        child: Text('No quests available'),
                                      );
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
    );
  }
}
