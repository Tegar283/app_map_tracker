import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import '../domain/location_entity.dart';
import '../domain/location_repository.dart';
import 'firebase_datasource.dart';
import 'location_datasource.dart';
import 'location_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource locationDataSource;
  final FirebaseDataSource firebaseDataSource;
  final FirebaseAuth firebaseAuth;

  LocationRepositoryImpl({
    required this.locationDataSource,
    required this.firebaseDataSource,
    required this.firebaseAuth,
  });

  String get userId => firebaseAuth.currentUser?.uid ?? '';

  @override
  Future<LocationEntity?> getCurrentLocation() async {
    final position = await locationDataSource.getCurrentLocation();

    return LocationModel(
      userId: userId,
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp,
    );
  }

  @override
  Stream<LocationEntity> getLocationStream() {
    return locationDataSource.getLocationStream().map((Position position) {
      return LocationModel(
        userId: userId,
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: position.timestamp,
      );
    });
  }

  @override
  Future<void> syncLocation(LocationEntity location) async {
    final model = LocationModel(
      userId: userId,
      latitude: location.latitude,
      longitude: location.longitude,
      timestamp: location.timestamp,
    );

    await firebaseDataSource.syncLocation(model);
  }
}
