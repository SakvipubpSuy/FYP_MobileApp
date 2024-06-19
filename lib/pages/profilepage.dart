import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/pages/auth/landingpage.dart';
import 'package:fyp_mobileapp/widgets/login_register_component.dart';
import 'package:fyp_mobileapp/api/user_service.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
  Map<String, dynamic>? _user;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Name: ${_user!['name']}'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Profile Page 1'),
            const Text('Profile Page 2'),
            const Spacer(),
            CustomCard(
                buttonText: "Logout",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LandingPage();
                  }));
                },
                color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
