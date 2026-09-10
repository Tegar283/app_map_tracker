import 'location_entity.dart';

abstract class LocationRepository {
  Future<LocationEntity?> getCurrentLocation();

  Stream<LocationEntity> getLocationStream();

  Future<void> syncLocation(LocationEntity location);
}
