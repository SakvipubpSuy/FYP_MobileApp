import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/pages/auth/landingpage.dart';
import 'package:fyp_mobileapp/widgets/login_register_component.dart';
import 'package:lottie/lottie.dart';

import '../api/user_service.dart';
import '../api/card_service.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
  final CardService _cardService = CardService();
  Map<String, dynamic>? _user;
  int? _totalCards;
  bool _isLoading = false;
  final String _defaultProfilePictureUrl =
      'https://as1.ftcdn.net/jpg/03/91/19/22/220_F_391192211_2w5pQpFV1aozYQhcIw3FqA35vuTxJKrB.jpg';

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
    _fetchTotalCards();
  }

  // Method to fetch current user details
  void _fetchCurrentUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await _userService.getCurrentUser();
      setState(() {
        _user = user;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user information: $e')),
      );
    } finally {
      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to fetch the total number of cards the user has scanned
  void _fetchTotalCards() async {
    try {
      final totalCards = await _cardService.countUserTotalCards();
      setState(() {
        _totalCards = totalCards;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch total cards: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Lottie.asset('assets/LoadingAnimation.json'),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 120),
            if (_user != null) ...[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  _user != null &&
                          _user!['profilePicture'] != null &&
                          _user!['profilePicture'].isNotEmpty
                      ? _user!['profilePicture']
                      : _defaultProfilePictureUrl, // URL to your default profile picture
                ),
                radius: 100,
              ),
              const SizedBox(height: 20),
              Text(
                _user!['name'],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                _user!['email'],
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      CircleBoxScreen(
                        child: Text(
                          _totalCards?.toString() ?? '0',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Total Cards',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  // Column(
                  //   children: [
                  //     CircleBoxScreen(
                  //       child: Icon(Icons.tv),
                  //     ),
                  //     SizedBox(height: 10),
                  //     Text(
                  //       'Humidity',
                  //       style: TextStyle(fontSize: 16),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              const SizedBox(height: 20),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: CustomCard(
                buttonText: "Logout",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const LandingPage();
                      },
                    ),
                  );
                },
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleBoxScreen extends StatelessWidget {
  final Widget child;
  const CircleBoxScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white, // Inner circle color
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        // Margin for the colorful border
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.transparent,
            width: 0,
          ),
          gradient: const SweepGradient(
            colors: [
              Colors.red,
              Colors.yellow,
              Colors.orange,
              Colors.green,
              Colors.blue,
              Colors.purple,
              Colors.red,
            ],
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(5), // Margin for inner white circle
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // Inner circle color
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
