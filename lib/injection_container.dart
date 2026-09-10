import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'data/auth_datasource.dart';
import 'data/auth_repository_impl.dart';
import 'data/firebase_datasource.dart';
import 'data/location_datasource.dart';
import 'data/location_repository_impl.dart';

import 'domain/auth_repository.dart';
import 'domain/get_current_location.dart';
import 'domain/location_repository.dart';
import 'domain/register_username.dart';
import 'domain/sign_in_facebook.dart';
import 'domain/sign_in_google.dart';
import 'domain/sign_in_username.dart';
import 'domain/sign_out.dart';
import 'domain/start_tracking.dart';
import 'domain/sync_location.dart';

import 'presentation/auth_provider.dart';
import 'presentation/location_provider.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final googleSignIn = GoogleSignIn.instance;

  await googleSignIn.initialize();

  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);

  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  sl.registerSingleton<GoogleSignIn>(googleSignIn);

  sl.registerSingleton<FacebookAuth>(FacebookAuth.instance);

  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSource(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
      googleSignIn: sl<GoogleSignIn>(),
      facebookAuth: sl<FacebookAuth>(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthDataSource>()),
  );

  sl.registerLazySingleton<SignInGoogle>(
    () => SignInGoogle(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<SignInFacebook>(
    () => SignInFacebook(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<SignInUsername>(
    () => SignInUsername(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<RegisterUsername>(
    () => RegisterUsername(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<SignOut>(() => SignOut(sl<AuthRepository>()));

  sl.registerFactory<AuthProvider>(
    () => AuthProvider(
      signInGoogle: sl<SignInGoogle>(),
      signInFacebook: sl<SignInFacebook>(),
      signInUsername: sl<SignInUsername>(),
      registerUsername: sl<RegisterUsername>(),
      signOut: sl<SignOut>(),
    ),
  );

  sl.registerLazySingleton<LocationDataSource>(() => LocationDataSource());

  sl.registerLazySingleton<FirebaseDataSource>(
    () => FirebaseDataSource(sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      locationDataSource: sl<LocationDataSource>(),
      firebaseDataSource: sl<FirebaseDataSource>(),
      firebaseAuth: sl<FirebaseAuth>(),
    ),
  );

  sl.registerLazySingleton<GetCurrentLocation>(
    () => GetCurrentLocation(sl<LocationRepository>()),
  );

  sl.registerLazySingleton<StartTracking>(
    () => StartTracking(sl<LocationRepository>()),
  );

  sl.registerLazySingleton<SyncLocation>(
    () => SyncLocation(sl<LocationRepository>()),
  );

  sl.registerFactory<LocationProvider>(
    () => LocationProvider(
      getCurrentLocation: sl<GetCurrentLocation>(),
      startTracking: sl<StartTracking>(),
      syncLocation: sl<SyncLocation>(),
    ),
  );
}
