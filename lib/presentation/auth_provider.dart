import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../domain/register_username.dart';
import '../domain/sign_in_facebook.dart';
import '../domain/sign_in_google.dart';
import '../domain/sign_in_username.dart';
import '../domain/sign_out.dart';
import '../domain/user_entity.dart';

class AuthProvider extends ChangeNotifier {
  final SignInGoogle signInGoogle;
  final SignInFacebook signInFacebook;
  final SignInUsername signInUsername;
  final RegisterUsername registerUsername;
  final SignOut signOut;

  AuthProvider({
    required this.signInGoogle,
    required this.signInFacebook,
    required this.signInUsername,
    required this.registerUsername,
    required this.signOut,
  });

  UserEntity? user;
  bool isLoading = false;
  String? error;

  Future<void> loginWithGoogle() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      user = await signInGoogle();
    } on FirebaseAuthException catch (e) {
      error = _firebaseError(e);
    } catch (_) {
      error = 'Login Google gagal.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loginWithFacebook() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      user = await signInFacebook();
    } on FirebaseAuthException catch (e) {
      error = _firebaseError(e);
    } catch (_) {
      error = 'Login Facebook gagal.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loginWithUsername(String username, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      user = await signInUsername(username.trim(), password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' ||
          e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        error = 'Username atau password salah.';
      } else {
        error = 'Login gagal. Silakan coba lagi.';
      }
    } catch (_) {
      error = 'Login gagal. Silakan coba lagi.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> registerWithUsername(String username, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      user = await registerUsername(username.trim(), password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'username-already-in-use') {
        error = 'Username sudah digunakan.';
      } else if (e.code == 'weak-password') {
        error = 'Password terlalu lemah.';
      } else {
        error = 'Pendaftaran gagal. Silakan coba lagi.';
      }
    } catch (_) {
      error = 'Pendaftaran gagal. Silakan coba lagi.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await signOut();
    user = null;
    notifyListeners();
  }

  String _firebaseError(FirebaseAuthException e) {
    if (e.code == 'account-exists-with-different-credential') {
      return 'Akun sudah menggunakan metode login lain.';
    }

    if (e.code == 'invalid-credential') {
      return 'Login gagal. Silakan coba lagi.';
    }

    return 'Login gagal. Silakan coba lagi.';
  }
}
