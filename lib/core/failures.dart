abstract class Failure {
  final String message;

  const Failure(this.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class LocationFailure extends Failure {
  const LocationFailure(super.message);
}

class FirebaseFailure extends Failure {
  const FirebaseFailure(super.message);
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}
