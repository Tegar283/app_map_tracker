import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import '../core/permission_helper.dart';
import 'location_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  Future<void> _initializeLocation() async {
    final permission = await PermissionHelper.requestLocationPermission(
      context,
    );

    if (!permission) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Izin lokasi diperlukan untuk menggunakan peta.'),
        ),
      );

      return;
    }

    if (!mounted) return;

    final provider = context.read<LocationProvider>();

    await provider.loadCurrentLocation();

    if (provider.currentLocation != null) {
      provider.startLocationTracking();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocationProvider>();
    final location = provider.currentLocation;

    if (location == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Map Tracker')),
        body: Center(
          child: provider.isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_off, size: 60),
                    const SizedBox(height: 16),
                    const Text('Lokasi belum tersedia'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _initializeLocation,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
        ),
      );
    }

    final position = LatLng(location.latitude, location.longitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Location'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<LocationProvider>().stopLocationTracking();
            },
            icon: const Icon(Icons.stop),
          ),
          IconButton(
            onPressed: () async {
              await context.read<LocationProvider>().stopLocationTracking();
              await context.read<AuthProvider>().logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: position, zoom: 16),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId('user_location'),
            position: position,
            infoWindow: const InfoWindow(title: 'Posisi Saya'),
          ),
        },
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapController?.animateCamera(CameraUpdate.newLatLng(position));
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
