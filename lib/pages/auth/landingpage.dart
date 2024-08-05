import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fyp_mobileapp/pages/dashboard.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:fyp_mobileapp/pages/auth/registerpage.dart';
import '../../utils/route.dart';
import 'loginpage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late Future<bool> _initialized;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _initialized = _initializeApp();
  }

  Future<bool> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    String? token = await _storage.read(key: 'auth_token');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initialized,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == true) {
          return const Dashboard();
        } else {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A1A4D), Color(0xFF2F2F85)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Welcome to UniSaga",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      LottieBuilder.asset('assets/Landingpage.json'),
                      const SizedBox(height: 20),
                      _buildButton(
                        context,
                        "Login",
                        Color(0xFFFFD700),
                        Color(0xFFFFA500),
                        const LoginPage(),
                      ),
                      const SizedBox(height: 15),
                      _buildButton(
                        context,
                        "Register",
                        Color.fromARGB(255, 134, 124, 17),
                        Color(0xFFFFD700),
                        const RegisterPage(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    Color color1,
    Color color2,
    Widget page,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(createRoute(page));
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color1, color2],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF1A1A4D),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/SplashScreen.json', // Replace with your Lottie animation file
            ),
          ],
        ),
      ),
    );
  }
}
