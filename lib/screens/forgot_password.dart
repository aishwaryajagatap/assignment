// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

import 'package:assignment/helper/string_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  // Creates the state for ForgotPasswordScreen
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Controller for capturing email input
  final emailCtrl = TextEditingController();

  /// Sends a password reset email to the provided email address.
  /// On success, displays a success message and navigates back to the previous screen.
  /// On failure, displays an error message using a SnackBar.
  Future<void> sendResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailCtrl.text);
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset email sent")));
      Navigator.pop(context); // Close the ForgotPasswordScreen
    } catch (e) {
      // Show error message if there is an issue with sending the email
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
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
              image: AssetImage("Forget_bg".png),
              fit: BoxFit.fill,
            ),
          ),
        ),

        // Reset password form container at the bottom
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Forgot Password title
                      const Text(
                        "Forgot Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Color(0xFF07429E)),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                      // Email input for the reset link
                      TextField(
                          controller: emailCtrl,
                          decoration: const InputDecoration(labelText: "Email")),
                      
                      const SizedBox(height: 70),

                      // Button to trigger password reset
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  const Color(0xFF07429E)),
                            ),
                            onPressed: sendResetEmail, // Trigger password reset
                            child: const Text("Send Reset Link",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15))),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ],
    ));
  }
}
