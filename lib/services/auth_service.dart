// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static Future<void> logout() async {
    await _auth.signOut(); // No navigation needed
  }
}
