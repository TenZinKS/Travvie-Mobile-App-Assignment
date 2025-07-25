import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// Core
import 'package:travvie/core/network/api_service.dart';
import 'package:travvie/core/network/hive_service.dart';
import 'package:travvie/core/network/network_info.dart';

// Connectivity
import 'package:connectivity_plus/connectivity_plus.dart';

// AUTH - Local Data
import 'package:travvie/features/auth/data/data_source/local_datasource/auth_local_datasource.dart';
import 'package:travvie/features/auth/data/repository/local_repository/auth_local_repository_impl.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';

// AUTH - Remote Data
import 'package:travvie/features/auth/data/data_source/remote_datasource/auth_remote_datasource.dart';
import 'package:travvie/features/auth/data/repository/remote_repository/auth_remote_repository_impl.dart';
import 'package:travvie/features/auth/domain/repository/auth_remote_repository.dart';

// AUTH - Use Cases
import 'package:travvie/features/auth/domain/use_case/change_password.dart';
import 'package:travvie/features/auth/domain/use_case/forgot_password.dart';
import 'package:travvie/features/auth/domain/use_case/remote_login_user.dart';
import 'package:travvie/features/auth/domain/use_case/remote_register_user.dart';
import 'package:travvie/app/use_case/login_user.dart';
import 'package:travvie/app/use_case/register_user.dart';

// AUTH - Blocs
import 'package:travvie/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:travvie/features/profile/domain/use_case/delete_user.dart';

// PROFILE
import 'package:travvie/features/profile/domain/use_case/get_user_email.dart';
import 'package:travvie/features/profile/presentation/view_model/profile_cubit.dart';

// SPLASH
import 'package:travvie/features/splash/presentation/view_model/splash_cubit.dart';

// TRIPS
import 'package:travvie/features/trip/data/data_source/local_datasource/local_trip_datasource.dart';
import 'package:travvie/features/trip/data/data_source/remote_datasource/trip_remote_data_source.dart';
import 'package:travvie/features/trip/data/repository/local_repository/trip_repository_impl.dart';
import 'package:travvie/features/trip/data/repository/remote_repository/trip_remote_repository_impl.dart';
import 'package:travvie/features/trip/domain/repository/trip_repository.dart';
import 'package:travvie/features/trip/domain/repository/trip_remote_repository.dart';
import 'package:travvie/features/trip/domain/use_case/add_trip.dart';
import 'package:travvie/features/trip/domain/use_case/get_all_trips.dart';
import 'package:travvie/features/trip/domain/use_case/delete_trip.dart';
import 'package:travvie/features/trip/domain/use_case/update_trip.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_bloc.dart';

// SAVED TRIPS
import 'package:travvie/features/saved/data/data_source/local_datasource/local_saved_trip_datasource.dart';
import 'package:travvie/features/saved/data/repository/local_repository/saved_trip_repository_impl.dart';
import 'package:travvie/features/saved/domain/repository/saved_trip_repository.dart';
import 'package:travvie/features/saved/domain/use_case/add_saved_trip.dart';
import 'package:travvie/features/saved/domain/use_case/get_all_saved_trips.dart';
import 'package:travvie/features/saved/domain/use_case/delete_saved_trip.dart';
import 'package:travvie/features/saved/presentation/view_model/saved_trip_bloc.dart';

// DEEPSEEK - AI
import 'package:travvie/features/deepseek/data/data_source/remote_datasource/remote_deepseek_datasource.dart';
import 'package:travvie/features/deepseek/data/repository/remote_repository/deepseek_repository_impl.dart';
import 'package:travvie/features/deepseek/domain/repository/deepseek_repository.dart';
import 'package:travvie/features/deepseek/domain/use_case/generate_trip.dart';
import 'package:travvie/features/deepseek/presentation/view_model/deepseek_bloc.dart';

// DASHBOARD
import 'package:travvie/features/dashboard/presentation/view_model/dashboard_bloc.dart';

final sl = GetIt.instance;

Future<void> initLocator() async {
  // ------------------------
  // CORE
  // ------------------------
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ApiService>(() => ApiService(sl<Dio>()));
  sl.registerLazySingleton<HiveService>(() => HiveService());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );

  // ------------------------
  // DATA SOURCES
  // ------------------------

  // Local
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl<HiveService>()),
  );

  sl.registerLazySingleton<LocalTripDataSource>(
    () => LocalTripDataSourceImpl(sl<HiveService>()),
  );

  sl.registerLazySingleton<LocalSavedTripDataSource>(
    () => LocalSavedTripDataSourceImpl(sl<HiveService>()),
  );

  // Remote
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiService>()),
  );

  sl.registerLazySingleton<TripRemoteDataSource>(
    () => TripRemoteDataSourceImpl(sl<ApiService>()),
  );

  sl.registerLazySingleton<RemoteDeepSeekDataSource>(
    () => RemoteDeepSeekDataSourceImpl(sl<ApiService>()),
  );

  // ------------------------
  // REPOSITORIES
  // ------------------------

  sl.registerLazySingleton<AuthLocalRepository>(
    () => AuthLocalRepositoryImpl(sl<AuthLocalDataSource>()),
  );

  sl.registerLazySingleton<AuthRemoteRepository>(
    () => AuthRemoteRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  sl.registerLazySingleton<TripRepository>(
    () => TripRepositoryImpl(sl<LocalTripDataSource>()),
  );

  sl.registerLazySingleton<TripRemoteRepository>(
    () => TripRemoteRepositoryImpl(sl<TripRemoteDataSource>()),
  );

  sl.registerLazySingleton<SavedTripRepository>(
    () => SavedTripRepositoryImpl(sl<LocalSavedTripDataSource>()),
  );

  sl.registerLazySingleton<DeepSeekRepository>(
    () => DeepSeekRepositoryImpl(
      remoteDataSource: sl<RemoteDeepSeekDataSource>(),
    ),
  );

  // ------------------------
  // USE CASES
  // ------------------------

  // Auth
  sl.registerLazySingleton(() => RemoteLoginUser(sl()));
  sl.registerLazySingleton(() => RemoteRegisterUser(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  sl.registerLazySingleton(() => ForgotPassword(sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => GetUserEmail(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));

  // Trips (local + remote)
  sl.registerLazySingleton(
    () => AddTrip(
      sl<TripRepository>(),
      sl<TripRemoteRepository>(),
      sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteTrip(sl<TripRepository>(), sl<TripRemoteRepository>()),
  );
  sl.registerLazySingleton(
    () => UpdateTrip(sl<TripRepository>(), sl<TripRemoteRepository>()),
  );
  sl.registerLazySingleton(
    () => GetAllTrips(sl<TripRepository>(), sl<TripRemoteRepository>()),
  );

  // Saved Trips
  sl.registerLazySingleton(() => AddSavedTrip(sl()));
  sl.registerLazySingleton(() => GetAllSavedTrips(sl()));
  sl.registerLazySingleton(() => DeleteSavedTrip(sl()));

  // DeepSeek
  sl.registerLazySingleton(() => GenerateTrip(sl()));

  // ------------------------
  // BLOCS / CUBITS
  // ------------------------

  sl.registerFactory(
    () => ProfileCubit(
      getUserEmail: sl(),
      changePassword: sl(),
      deleteUser: sl(),
      hive: sl(),
      localRepo: sl(),
    ),
  );

  sl.registerFactory(() => SplashCubit(sl()));

  sl.registerFactory(
    () => AuthBloc(sl<RemoteLoginUser>(), sl<RemoteRegisterUser>()),
  );

  sl.registerFactory(
    () => TripBloc(
      addTrip: sl(),
      getAllTrips: sl(),
      deleteTrip: sl(),
      updateTrip: sl(),
    ),
  );

  sl.registerFactory(
    () => SavedTripBloc(
      addSavedTrip: sl(),
      getAllSavedTrips: sl(),
      deleteSavedTrip: sl(),
    ),
  );

  sl.registerFactory(() => DeepSeekBloc(sl<GenerateTrip>()));
  sl.registerFactory(() => DashboardBloc());
}
