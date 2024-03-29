import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/pages/auth/registerpage.dart';

import '../../widgets/login_register_component.dart';
import 'loginpage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Logo And Name Here"),
              SizedBox(height: 200),
              CustomCard(
                buttonText: "Login",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }));
                },
                color: Colors.blue,
              ),
              CustomCard(
                buttonText: "Register",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const RegisterPage();
                  }));
                },
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
