import 'location_entity.dart';
import 'location_repository.dart';

class GetCurrentLocation {
  final LocationRepository repository;

  GetCurrentLocation(this.repository);

  Future<LocationEntity?> call() {
    return repository.getCurrentLocation();
  }
}
