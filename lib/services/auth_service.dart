import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _initialized = false;
  AuthService() {
    _init();
  }
  Future<void> _init() async {
    await _googleSignIn.initialize();
    _initialized = true;
  }
  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current logged-in user
  User? getCurrentUser() => _auth.currentUser;

  // Sign up
  Future<String?> signUp(
      String fName,
      String lName,
      String email,
      String password,
      ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((onValue){
        _firestore.collection('users').doc(onValue.user!.uid).set({
          'fName': fName,
          'lName': lName,
          'email': email,
        });
      });
      await _auth.currentUser?.updateDisplayName('$fName $lName');
      return null; // success
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseErrorToMessage(e);
    } catch (_) {
      return 'Something went wrong.';
    }
  }

  // Sign in
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // success
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseErrorToMessage(e);
    } catch (_) {
      return 'Something went wrong.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Convert Firebase errors to readable messages
  String _mapFirebaseErrorToMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'Email already in use.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      default:
        return e.message ?? 'Authentication error.';
    }
  }

  Future<String?> signInWithGoogle() async {
    if (!_initialized) await _init();

    try {
      final account = await _googleSignIn.authenticate();
      final auth = account.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: auth.idToken,
        idToken: auth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(cred);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Google sign-in failed: $e';
    }
  }
  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }
}
