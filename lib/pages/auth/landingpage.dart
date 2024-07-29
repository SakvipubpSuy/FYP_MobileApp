import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fyp_mobileapp/pages/dashboard.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:fyp_mobileapp/pages/auth/registerpage.dart';
import '../../utils/route.dart';
// import '../../widgets/login_register_component.dart';
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
          return Dashboard();
        } else {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome to UniSaga",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.network(
                    "https://img.freepik.com/free-vector/player-characters-online-game-concept_23-2148541601.jpg",
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Card(
                      color: Colors.blue[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            createRoute(const LoginPage()),
                          );
                        },
                        child: const SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Card(
                      color: Colors.blue[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            createRoute(const RegisterPage()),
                          );
                        },
                        child: const SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Center(
                              child: Text(
                                "Register",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
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
