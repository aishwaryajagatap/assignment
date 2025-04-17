import 'package:assignment/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  /// Signs out the user and navigates to LoginScreen.
  static Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) =>  LoginScreen()),
      (route) => false, // Remove all previous routes
    );
  }

  /// Checks if a user is currently logged in.
  static Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }
}
