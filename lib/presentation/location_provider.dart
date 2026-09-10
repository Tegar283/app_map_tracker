import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/get_current_location.dart';
import '../domain/location_entity.dart';
import '../domain/start_tracking.dart';
import '../domain/sync_location.dart';

class LocationProvider extends ChangeNotifier {
  final GetCurrentLocation getCurrentLocation;
  final StartTracking startTracking;
  final SyncLocation syncLocation;

  LocationProvider({
    required this.getCurrentLocation,
    required this.startTracking,
    required this.syncLocation,
  });

  LocationEntity? currentLocation;

  StreamSubscription<LocationEntity>? _locationSubscription;

  bool isLoading = false;
  bool isTracking = false;
  String? error;

  Future<void> loadCurrentLocation() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      currentLocation = await getCurrentLocation();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void startLocationTracking() {
    if (isTracking) return;

    isTracking = true;
    error = null;
    notifyListeners();

    _locationSubscription = startTracking().listen(
      (location) async {
        currentLocation = location;
        notifyListeners();

        try {
          await syncLocation(location);
        } catch (e) {
          error = e.toString();
          notifyListeners();
        }
      },
      onError: (e) {
        error = e.toString();
        isTracking = false;
        notifyListeners();
      },
    );
  }

  Future<void> stopLocationTracking() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;

    isTracking = false;
    notifyListeners();
  }

  Future<void> syncCurrentLocation(String userId) async {
    if (currentLocation == null) return;

    final location = LocationEntity(
      userId: userId,
      latitude: currentLocation!.latitude,
      longitude: currentLocation!.longitude,
      timestamp: currentLocation!.timestamp,
    );

    try {
      await syncLocation(location);
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}
