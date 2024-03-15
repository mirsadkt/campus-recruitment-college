import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signIn() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print("Error during sign-in: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
