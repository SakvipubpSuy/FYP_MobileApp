import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/api/auth_service.dart';
import 'package:fyp_mobileapp/models/user.dart';
import 'auth/landingpage.dart';
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
  late Future<UserModel> _futureUser;
  final CardService _cardService = CardService();
  final AuthService _authService = AuthService();

  UserModel? _user;
  int? _totalCards;
  final String _defaultProfilePictureUrl =
      'https://as1.ftcdn.net/jpg/03/91/19/22/220_F_391192211_2w5pQpFV1aozYQhcIw3FqA35vuTxJKrB.jpg';

  @override
  void initState() {
    super.initState();
    _futureUser = UserService().getCurrentUser();
    _fetchTotalCards();
  }

  // Method to fetch the total number of cards the user has scanned
  void _fetchTotalCards() async {
    try {
      final totalCards = await _cardService.countUserTotalCards();
      setState(() {
        _totalCards = totalCards;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch total cards: $e')),
        );
      }
    }
  }

  void _logout() async {
    await _authService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserModel>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset('assets/Profilepage.json'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            _user = snapshot.data;

            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 120),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      _user != null && _user!.profilePhotoPath != null
                          ? _user!.profilePhotoPath!
                          : _defaultProfilePictureUrl,
                    ),
                    radius: 80,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _user!.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _user!.email,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w400),
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
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: CustomCard(
                      buttonText: "Logout",
                      onTap: _logout,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('No user data'),
            );
          }
        },
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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
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
            margin: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
