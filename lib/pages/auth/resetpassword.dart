import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/api/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  final AuthService _apiService = AuthService();

  bool _isCodeSent = false;
  bool _isCodeVerified = false;
  String? _statusMessage;

  // Email validation function to ensure correct domain
  bool _validateEmail(String email) {
    const requiredDomain = '@paragoniu.edu.kh'; // Replace with your domain
    final emailPattern = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return email.endsWith(requiredDomain) && emailPattern.hasMatch(email);
  }

  Future<void> _requestResetCode() async {
    if (_validateEmail(_emailController.text)) {
      final status = await _apiService.requestResetCode(_emailController.text);
      setState(() {
        _statusMessage = status;
        print('Status Message: $_statusMessage'); // Debug line
        if (status!.toLowerCase().contains('success')) {
          _isCodeSent = true;
        } else {
          _isCodeSent = false;
          _emailController.clear();
        }
      });
    } else {
      setState(() {
        _statusMessage = 'Please enter a valid email with the correct domain.';
        _isCodeSent = false;
      });
    }
  }

  Future<void> _verifyResetCode() async {
    final status = await _apiService.verifyResetCode(
        _emailController.text, _codeController.text);
    setState(() {
      if (status!.toLowerCase().contains('success')) {
        _isCodeVerified = true;
        _statusMessage = 'Code verified. You can now reset your password.';
      } else {
        _statusMessage = 'Invalid or expired code. Please try again.';
        _isCodeVerified = false;
      }
    });
  }

  Future<void> _resetPassword() async {
    // Check if passwords match
    if (_passwordController.text != _passwordConfirmationController.text) {
      setState(() {
        _statusMessage = 'Passwords do not match. Please try again.';
      });
      return; // Prevent the reset process from continuing
    }

    // Check if password fields are not empty and at least 8 characters long
    if (_passwordController.text.isEmpty ||
        _passwordConfirmationController.text.isEmpty ||
        _passwordController.text.length < 8 ||
        _passwordConfirmationController.text.length < 8) {
      setState(() {
        _statusMessage = 'Password must be at least 8 characters long.';
      });
      return; // Prevent the reset process from continuing
    }

    final status = await _apiService.resetPassword(
      _emailController.text,
      _codeController.text,
      _passwordController.text,
      _passwordConfirmationController.text,
    );

    setState(() {
      if (status == 'Password reset successfully' ||
          status == 'Password reset successfully.') {
        _statusMessage = status;
        // Navigate to login after successful password reset
        Navigator.of(context).pop();
      } else {
        _statusMessage =
            status; // Display the exact error message from the backend
      }
    });
  }

  void _navigateToLoginPage() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2F2F85),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xFF1A1A4D), Color(0xFF2F2F85)],
        )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_statusMessage != null) ...[
                Text(
                  _statusMessage!,
                  style: TextStyle(
                    color: _statusMessage!.toLowerCase().contains('success')
                        ? Colors.green
                        : Colors.red,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
              ],
              if (!_isCodeSent) ...[
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                  keyboardType: TextInputType.emailAddress,
                  style:
                      const TextStyle(color: Colors.white), // White text color
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _requestResetCode,
                  child: const Text(
                    'Request Reset Code',
                    style: TextStyle(color: Colors.amber),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF1A1A4D), // Dark blue button color
                  ),
                ),
              ],
              if (_isCodeSent && !_isCodeVerified) ...[
                TextField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Reset Code',
                    labelStyle:
                        TextStyle(color: Colors.amber), // amber label color
                  ),
                  style:
                      const TextStyle(color: Colors.white), // White text color
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _verifyResetCode,
                  child: const Text(
                    'Verify Code',
                    style: TextStyle(color: Colors.amber),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF1A1A4D), // Dark blue button color
                  ),
                ),
              ],
              if (_isCodeVerified) ...[
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    labelStyle:
                        TextStyle(color: Colors.amber), // amber label color
                  ),
                  obscureText: true,
                  style:
                      const TextStyle(color: Colors.white), // White text color
                ),
                TextField(
                  controller: _passwordConfirmationController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    labelStyle:
                        TextStyle(color: Colors.amber), // amber label color
                  ),
                  obscureText: true,
                  style:
                      const TextStyle(color: Colors.white), // White text color
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _resetPassword,
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(color: Colors.amber),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF1A1A4D), // Dark blue button color
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
