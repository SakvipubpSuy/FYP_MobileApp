import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/pages/dashboard.dart';
import 'package:fyp_mobileapp/widgets/field_component.dart';
import '../../api/auth_service.dart';

import '../../widgets/login_register_component.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.text = 'eidousermobile4@gmail.com';
    _passwordController.text = 'eidousermobile4@gmail.com';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // void _login() async {
  //   try {
  //     final response = await ApiService.login(
  //       _emailController.text,
  //       _passwordController.text,
  //     );

  //     if (response.containsKey('token')) {
  //       // Store or use the token as needed

  //       // Check if the widget is still mounted before navigating
  //       if (!mounted) return;
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => Dashboard()),
  //       );
  //     } else {
  //       if (!mounted) return;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to login')),
  //       );
  //     }
  //   } catch (e) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.toString())),
  //     );
  //   }
  // }
  void _login() async {
    bool success = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (success) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login')),
      );
    }
  }

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
            Center(
              child: CustomField(
                controller: _emailController,
                hintText: "Email",
              ),
            ),
            Center(
              child: CustomField(
                controller: _passwordController,
                hintText: "Password",
              ),
            ),
            const SizedBox(height: 20),
            CustomCard(
              buttonText: "Login",
              onTap: _login,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
