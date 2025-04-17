// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:assignment/helper/string_extension.dart';
import 'package:assignment/project_screen.dart';
import 'package:assignment/screens/forgot_password.dart';
import 'package:assignment/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for email and password input fields
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  /// Handles login using Firebase Authentication.
  /// Navigates to ProjectScreen on success, or shows error message on failure.
  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text,
        password: passwordCtrl.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ProjectScreen()),
      );
    } catch (e) {
      // Show error message if login fails
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("login_bg".png),
                fit: BoxFit.fill,
              ),
            ),
          ),

          // Login Form (Bottom Sheet Style)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 30),

                      // Title
                      Text(
                        "Login",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Color(0xFF07429E),
                        ),
                      ),

                      // Email input field
                      TextField(
                        controller: emailCtrl,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      SizedBox(height: 20),

                      // Password input field
                      TextField(
                        controller: passwordCtrl,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                      // Login button
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Color(0xFF07429E)),
                          ),
                          onPressed: login,
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Forgot Password link
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ForgotPasswordScreen()),
                        ),
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(fontSize: 16, color: Color(0xFF07429E)),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Signup link
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignupScreen()),
                        ),
                        child: const Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(fontSize: 16, color: Color(0xFF07429E)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
