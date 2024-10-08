import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/pages/auth/loginpage.dart';
import '../../api/auth_service.dart';
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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isUsernameFocused = false;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isConfirmPasswordFocused = false;
  bool _isPasswordVisible = false;

  String? _usernameError;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();

    _usernameFocusNode.addListener(() {
      setState(() {
        _isUsernameFocused = _usernameFocusNode.hasFocus;
      });
    });

    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });

    _confirmPasswordFocusNode.addListener(() {
      setState(() {
        _isConfirmPasswordFocused = _confirmPasswordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  bool _validateEmail(String email) {
    const domain = 'paragoniu.edu.kh'; // Replace with your specific domain
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@' + domain + r'$');
    return emailRegExp.hasMatch(email);
  }

  bool _validateUsername(String username) {
    return username.isNotEmpty; // Add any other username validation logic here
  }

  void _register() {
    setState(() {
      _usernameError = !_validateUsername(_usernameController.text)
          ? 'Username cannot be empty'
          : null;
      _emailError = !_validateEmail(_emailController.text)
          ? 'Invalid email format or domain'
          : null;
      _passwordError =
          _passwordController.text != _confirmPasswordController.text
              ? 'Passwords do not match'
              : null;
    });

    if (_usernameError == null &&
        _emailError == null &&
        _passwordError == null) {
      AuthService authService = AuthService();
      authService
          .register(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      )
          .then((response) {
        if (response['status'] == 'success') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
            (Route<dynamic> route) => false,
          );
        } else {
          setState(() {
            _usernameError = response['message'];
          });
        }
      }).catchError((error) {
        setState(() {
          _usernameError = 'An error occurred: $error';
        });
      });
    }
  }

  void _navigateToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left_outlined,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.yellow[700],
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Color(0xFF2F2F85)),
        ),
        title: Text(
          'Register to the Saga Today',
          style: TextStyle(
            color: Colors.yellow[700],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A4D), Color(0xFF2F2F85)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.yellow[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    focusNode: _usernameFocusNode,
                    decoration: InputDecoration(
                      hintText: "Username",
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.6)),
                      filled: true,
                      fillColor: _isUsernameFocused
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                            color: _usernameError != null
                                ? Colors.red
                                : (_isUsernameFocused
                                    ? Colors.amber
                                    : Colors.transparent)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                            color: _usernameError != null
                                ? Colors.red
                                : (_isUsernameFocused
                                    ? Colors.amber
                                    : Colors.transparent)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                            color: _usernameError != null
                                ? Colors.red
                                : (_isUsernameFocused
                                    ? Colors.amber
                                    : Colors.transparent)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  if (_usernameError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _usernameError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.6)),
                      filled: true,
                      fillColor: _isEmailFocused
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                            color: _emailError != null
                                ? Colors.red
                                : (_isEmailFocused
                                    ? Colors.amber
                                    : Colors.transparent)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                            color: _emailError != null
                                ? Colors.red
                                : (_isEmailFocused
                                    ? Colors.amber
                                    : Colors.transparent)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                            color: _emailError != null
                                ? Colors.red
                                : (_isEmailFocused
                                    ? Colors.amber
                                    : Colors.transparent)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  if (_emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _emailError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.6)),
                      filled: true,
                      fillColor: _isPasswordFocused
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                            color: _passwordError != null
                                ? Colors.red
                                : (_isPasswordFocused
                                    ? Colors.amber
                                    : Colors.transparent)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                            color: _passwordError != null
                                ? Colors.red
                                : (_isPasswordFocused
                                    ? Colors.amber
                                    : Colors.transparent)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                            color: _passwordError != null
                                ? Colors.red
                                : (_isPasswordFocused
                                    ? Colors.amber
                                    : Colors.transparent)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.amber.withOpacity(0.8),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.6)),
                      filled: true,
                      fillColor: _isConfirmPasswordFocused
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                            color: _passwordError != null
                                ? Colors.red
                                : (_isConfirmPasswordFocused
                                    ? Colors.amber
                                    : Colors.transparent)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                            color: _passwordError != null
                                ? Colors.red
                                : (_isConfirmPasswordFocused
                                    ? Colors.amber
                                    : Colors.transparent)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                            color: _passwordError != null
                                ? Colors.red
                                : (_isConfirmPasswordFocused
                                    ? Colors.amber
                                    : Colors.transparent)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.amber.withOpacity(0.8),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  if (_passwordError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _passwordError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 40),
                      ),
                      onPressed: _register,
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Color(0xFF2F2F85),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: _navigateToRegisterPage,
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16),
                          children: const [
                            TextSpan(
                              text: "Login",
                              style: TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
