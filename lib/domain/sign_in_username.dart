import 'auth_repository.dart';
import 'user_entity.dart';

class SignInUsername {
  final AuthRepository repository;

  SignInUsername(this.repository);

  Future<UserEntity?> call(String username, String password) {
    return repository.signInWithUsername(username, password);
  }
}
