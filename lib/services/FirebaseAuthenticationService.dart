import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Invariant
  String getUID() {
    assert(_auth.currentUser != null);
    return _auth.currentUser!.uid;
  }

  // Assertion
  Future<User?> signIn(String email, String password) async {
    assert(email.isNotEmpty, 'email cannot be empty or null');
    assert(password.isNotEmpty, 'password cannot be empty or null');
    User? user;
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      user = result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw FirebaseAuthException(
            code: 'ERROR_SIGN_IN_EMAIL_PASSWORD',
            message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw FirebaseAuthException(
            code: 'ERROR_SIGN_IN_EMAIL_PASSWORD',
            message: 'No user found for that email.');
      }
    }
    return user;
  }

// assertion
  Future<bool> signUp(String email, String password) async {
    assert(email.isNotEmpty, 'email cannot be empty or null');
    assert(password.isNotEmpty, 'password cannot be empty or null');
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw FirebaseAuthException(
            code: 'ERROR_SIGN_UP_EMAIL_PASSWORD',
            message: 'The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        throw FirebaseAuthException(
            code: 'ERROR_SIGN_UP_EMAIL_PASSWORD',
            message: 'The account already exists for that email.');
      }
      return false;
    }
  }

  // assertion
  Future<bool> resetPassword(String email) async {
    assert(email.isNotEmpty, 'email cannot be empty or null');
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
          code: 'ERROR_RESET_PASSWORD', message: e.message);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      throw FirebaseAuthException(
          code: 'ERROR_SIGN_OUT', message: error.message);
    }
  }

  // Invariant
  Future<void> deleteAccount() async {
    assert(_auth.currentUser != null);
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (error) {
      throw FirebaseAuthException(
          code: 'ERROR_DELETE_ACC', message: error.message);
    }
  }
}
