import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthServices(){
    if (!kIsWeb) { //only for Android /ios 
      FirebaseAuth.instance.setSettings(
        appVerificationDisabledForTesting: true,
        forceRecaptchaFlow: false,
      );
    }
  }

  //get current user
  User? get currentUser => _auth.currentUser;

  //auth stage changes stream  (biar kesimpem, jadi nanti pas di mau buka appnya gperlu login lagi, jadi hanya sekali login)
Stream<User?> get authStageChanges => _auth.authStateChanges();

// sign in with email and password
Future<UserCredential> signInWithEmailAndPassword(String email, String password) async{
  try {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password
    );
  } catch (e) {
    rethrow;
  }
}

// register with email and password 
Future<UserCredential> registerWithEmailAndPassword(String email, String password) async{
  try {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );
  } catch (e) {
    if (e is FirebaseAuthException) {
      if (e.code == 'operation-not-allowed') {
        throw 'Email or Password sign up is not enable. please enable on firebase console.';
      }
    }
    rethrow;
  }
}


//sign out 
Future<void> signOut() async {
  try {
    await _auth.signOut();
  } catch (e) {
    rethrow;
  }
}
}