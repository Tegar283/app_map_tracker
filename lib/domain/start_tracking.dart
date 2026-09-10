import 'location_entity.dart';
import 'location_repository.dart';

class StartTracking {
  final LocationRepository repository;

  StartTracking(this.repository);

  Stream<LocationEntity> call() {
    return repository.getLocationStream();
  }
}
