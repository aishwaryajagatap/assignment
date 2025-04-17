// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors

import 'package:assignment/helper/string_extension.dart';
import 'package:assignment/project_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  // Creates the state for SignupScreen
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers to capture user input for email and password
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  /// Registers the user using Firebase Authentication.
  /// On success, navigates to ProjectScreen.
  /// On failure, displays an error message using a SnackBar.
  Future<void> signup() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text,
        password: passwordCtrl.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ProjectScreen()),
      );
    } catch (e) {
      // Show error if signup fails
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Signup Failed: $e")));
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
                image: AssetImage("signup".png),
                fit: BoxFit.fill,
              ),
            ),
          ),

          // Signup Form container at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
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
                      const SizedBox(height: 30),

                      // Signup title
                      const Text(
                        "Sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Color(0xFF07429E),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Email input
                      TextField(
                        controller: emailCtrl,
                        decoration: InputDecoration(labelText: "Email"),
                      ),

                      SizedBox(height: 20),

                      // Password input
                      TextField(
                        controller: passwordCtrl,
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Password"),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                      // Sign up button
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Color(0xFF07429E)),
                          ),
                          onPressed: signup,
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
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
