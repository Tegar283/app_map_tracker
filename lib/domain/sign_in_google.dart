import 'auth_repository.dart';
import 'user_entity.dart';

class SignInGoogle {
  final AuthRepository repository;

  SignInGoogle(this.repository);

  Future<UserEntity?> call() {
    return repository.signInWithGoogle();
  }
}
