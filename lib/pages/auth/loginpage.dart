import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/pages/dashboard.dart';
import 'package:fyp_mobileapp/widgets/field_component.dart';

import '../../widgets/login_register_component.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "Welcome to Login Page",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 100),
            const Center(
              child: CustomField(
                hintText: "Email",
              ),
            ),
            const Center(
              child: CustomField(
                hintText: "Password",
              ),
            ),
            const SizedBox(height: 20),
            CustomCard(
              buttonText: "Login",
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const Dashboard();
                }));
              },
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
