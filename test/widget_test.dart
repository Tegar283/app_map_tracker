import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:map_tracker/domain/auth_repository.dart';
import 'package:map_tracker/domain/get_current_location.dart';
import 'package:map_tracker/domain/location_entity.dart';
import 'package:map_tracker/domain/location_repository.dart';
import 'package:map_tracker/domain/sign_in_google.dart';
import 'package:map_tracker/domain/sync_location.dart';
import 'package:map_tracker/domain/user_entity.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([AuthRepository, LocationRepository])
void main() {
  group('SignInGoogle', () {
    test('berhasil login dengan Google', () async {
      final mockRepository = MockAuthRepository();

      const user = UserEntity(
        id: 'user123',
        name: 'Test User',
        email: 'test@gmail.com',
      );

      when(mockRepository.signInWithGoogle()).thenAnswer((_) async => user);

      final useCase = SignInGoogle(mockRepository);

      final result = await useCase();

      expect(result, user);
      expect(result?.id, 'user123');

      verify(mockRepository.signInWithGoogle()).called(1);
    });
  });

  group('GetCurrentLocation', () {
    test('berhasil mendapatkan lokasi pengguna', () async {
      final mockRepository = MockLocationRepository();

      final location = LocationEntity(
        userId: 'user123',
        latitude: -0.9471,
        longitude: 100.4172,
        timestamp: DateTime(2026, 9, 9),
      );

      when(
        mockRepository.getCurrentLocation(),
      ).thenAnswer((_) async => location);

      final useCase = GetCurrentLocation(mockRepository);

      final result = await useCase();

      expect(result, location);
      expect(result?.latitude, -0.9471);
      expect(result?.longitude, 100.4172);

      verify(mockRepository.getCurrentLocation()).called(1);
    });
  });

  group('SyncLocation', () {
    test('berhasil menyimpan lokasi ke repository', () async {
      final mockRepository = MockLocationRepository();

      final location = LocationEntity(
        userId: 'user123',
        latitude: -0.9471,
        longitude: 100.4172,
        timestamp: DateTime(2026, 9, 9),
      );

      when(mockRepository.syncLocation(location)).thenAnswer((_) async {});

      final useCase = SyncLocation(mockRepository);

      await useCase(location);

      verify(mockRepository.syncLocation(location)).called(1);
    });
  });
}
