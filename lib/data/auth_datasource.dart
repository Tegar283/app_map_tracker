import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;
  final FacebookAuth facebookAuth;

  AuthDataSource({
    required this.firebaseAuth,
    required this.firestore,
    required this.googleSignIn,
    required this.facebookAuth,
  });

  String _usernameEmail(String username) {
    return '${username.toLowerCase()}@maptracker.local';
  }

  Future<User?> signInWithGoogle() async {
    final googleUser = await googleSignIn.authenticate();

    final googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final result = await firebaseAuth.signInWithCredential(credential);

    final user = result.user;

    if (user != null) {
      await firestore.collection('users').doc(user.uid).set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'photoUrl': user.photoURL,
        'provider': 'google',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    return user;
  }

  Future<User?> signInWithFacebook() async {
    final result = await facebookAuth.login();

    if (result.status != LoginStatus.success) {
      return null;
    }

    final accessToken = result.accessToken;

    if (accessToken == null) {
      return null;
    }

    final credential = FacebookAuthProvider.credential(accessToken.tokenString);

    final userCredential = await firebaseAuth.signInWithCredential(credential);

    final user = userCredential.user;

    if (user != null) {
      await firestore.collection('users').doc(user.uid).set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'photoUrl': user.photoURL,
        'provider': 'facebook',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    return user;
  }

  Future<User?> signInWithUsername(String username, String password) async {
    final result = await firebaseAuth.signInWithEmailAndPassword(
      email: _usernameEmail(username),
      password: password,
    );

    return result.user;
  }

  Future<User?> registerWithUsername(String username, String password) async {
    final result = await firebaseAuth.createUserWithEmailAndPassword(
      email: _usernameEmail(username),
      password: password,
    );

    final user = result.user;

    if (user == null) return null;

    await user.updateDisplayName(username);

    await firestore.collection('users').doc(user.uid).set({
      'username': username,
      'name': username,
      'provider': 'guest',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return user;
  }

  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
    } catch (_) {}

    try {
      await facebookAuth.logOut();
    } catch (_) {}

    await firebaseAuth.signOut();
  }

  Stream<User?> authStateChanges() {
    return firebaseAuth.authStateChanges();
  }
}
