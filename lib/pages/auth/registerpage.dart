import 'package:flutter/material.dart';

import '../../widgets/field_component.dart';
import '../../widgets/login_register_component.dart';
import '../dashboard.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "Welcome, Register to get started",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 100),
            const Center(
              child: CustomField(
                hintText: "Username",
              ),
            ),
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
            const Center(
              child: CustomField(
                hintText: "Confirm Password",
              ),
            ),
            const SizedBox(height: 20),
            CustomCard(
              buttonText: "Register",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
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
