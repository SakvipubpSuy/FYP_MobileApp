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
  final String _defaultProfilePicture = 'assets/icons/default_profile_icon.png';

  @override
  void initState() {
    super.initState();
    _futureUser = UserService().getCurrentUser();
    _fetchTotalCards();
  }

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
      // appBar: AppBar(
      //   title: const Text('Profile'),
      //   backgroundColor: Color(0xFF2F2F85),
      // ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A4D), Color(0xFF2F2F85)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: FutureBuilder<UserModel>(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    CircleAvatar(
                      radius: 80,
                      backgroundColor:
                          Colors.white, // Optional: Add a background color
                      child: _user != null &&
                              _user!.profilePhotoPath != null &&
                              _user!.profilePhotoPath!.isNotEmpty
                          ? null // If the user has a profile photo, the image will be set as the backgroundImage
                          : Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.grey[
                                  800], // Optional: Customize the icon color
                            ),
                      backgroundImage: _user != null &&
                              _user!.profilePhotoPath != null &&
                              _user!.profilePhotoPath!.isNotEmpty
                          ? NetworkImage(_user!.profilePhotoPath!)
                          : null, // If no profile photo, display the icon instead
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _user!.name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Container(
                        child: ElevatedButton(
                          onPressed: _logout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF1A1A4D)),
                          ),
                        ),
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
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFD700),
            Color(0xFFFFC107),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
