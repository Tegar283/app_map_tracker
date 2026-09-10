import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PermissionHelper {
  static Future<bool> requestLocationPermission(BuildContext context) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (!context.mounted) return false;

      final openSettings = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('GPS Tidak Aktif'),
            content: const Text(
              'GPS harus diaktifkan agar aplikasi dapat '
              'melacak lokasi kamu.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Aktifkan GPS'),
              ),
            ],
          );
        },
      );

      if (openSettings == true) {
        await Geolocator.openLocationSettings();
      }

      return false;
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      if (!context.mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Izin lokasi diperlukan untuk menggunakan fitur tracking.',
          ),
        ),
      );

      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      if (!context.mounted) return false;

      final openSettings = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Izin Lokasi Ditolak'),
            content: const Text(
              'Izin lokasi telah ditolak secara permanen. '
              'Silakan aktifkan izin lokasi melalui pengaturan aplikasi.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Buka Pengaturan'),
              ),
            ],
          );
        },
      );

      if (openSettings == true) {
        await Geolocator.openAppSettings();
      }

      return false;
    }

    return true;
  }
}
