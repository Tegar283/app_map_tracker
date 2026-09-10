import 'user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signInWithGoogle();

  Future<UserEntity?> signInWithFacebook();

  Future<UserEntity?> signInWithUsername(String username, String password);

  Future<UserEntity?> registerWithUsername(String username, String password);

  Future<void> signOut();

  Stream<UserEntity?> authStateChanges();
}
