import 'location_entity.dart';
import 'location_repository.dart';

class SyncLocation {
  final LocationRepository repository;

  SyncLocation(this.repository);

  Future<void> call(LocationEntity location) {
    return repository.syncLocation(location);
  }
}
