import 'auth_repository.dart';
import 'user_entity.dart';

class SignInFacebook {
  final AuthRepository repository;

  SignInFacebook(this.repository);

  Future<UserEntity?> call() {
    return repository.signInWithFacebook();
  }
}
