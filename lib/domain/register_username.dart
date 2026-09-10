import 'auth_repository.dart';
import 'user_entity.dart';

class RegisterUsername {
  final AuthRepository repository;

  RegisterUsername(this.repository);

  Future<UserEntity?> call(String username, String password) {
    return repository.registerWithUsername(username, password);
  }
}
