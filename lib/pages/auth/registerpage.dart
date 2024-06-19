import 'package:flutter/material.dart';
import '../../api/auth_service.dart';
import '../../widgets/field_component.dart';
import '../../widgets/login_register_component.dart';
import '../dashboard.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    AuthService.register(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
    ).then((response) {
      if (response['status'] == 'success') {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        }));
      } else {
        final snackBar = SnackBar(
          content: Text(response['message']),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
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
            Center(
              child: CustomField(
                controller: _usernameController,
                hintText: "Username",
              ),
            ),
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
            // const Center(
            //   child: CustomField(
            //     hintText: "Confirm Password",
            //   ),
            // ),
            const SizedBox(height: 20),
            CustomCard(
              buttonText: "Register",
              onTap: _register,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
