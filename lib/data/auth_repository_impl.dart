import 'package:firebase_auth/firebase_auth.dart';

import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';
import 'auth_datasource.dart';
import 'user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  UserModel? _mapUser(User? user) {
    if (user == null) return null;

    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL,
    );
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    final user = await dataSource.signInWithGoogle();
    return _mapUser(user);
  }

  @override
  Future<UserEntity?> signInWithFacebook() async {
    final user = await dataSource.signInWithFacebook();
    return _mapUser(user);
  }

  @override
  Future<UserEntity?> signInWithUsername(
    String username,
    String password,
  ) async {
    final user = await dataSource.signInWithUsername(username, password);

    return _mapUser(user);
  }

  @override
  Future<UserEntity?> registerWithUsername(
    String username,
    String password,
  ) async {
    final user = await dataSource.registerWithUsername(username, password);

    return _mapUser(user);
  }

  @override
  Future<void> signOut() {
    return dataSource.signOut();
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return dataSource.authStateChanges().map(_mapUser);
  }
}
