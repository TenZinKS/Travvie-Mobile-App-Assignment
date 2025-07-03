import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// Core
import 'package:travvie/core/network/api_service.dart';
import 'package:travvie/core/network/hive_service.dart';

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

// PROFILE
import 'package:travvie/features/profile/domain/use_case/get_user_email.dart';
import 'package:travvie/features/profile/presentation/view_model/profile_cubit.dart';

// SPLASH
import 'package:travvie/features/splash/presentation/view_model/splash_cubit.dart';

// TRIPS
import 'package:travvie/features/trip/data/data_source/local_datasource/local_trip_datasource.dart';
import 'package:travvie/features/trip/data/repository/local_repository/trip_repository_impl.dart';
import 'package:travvie/features/trip/domain/repository/trip_repository.dart';
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

final sl = GetIt.instance;

Future<void> initLocator() async {
  // CORE SERVICES
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ApiService>(() => ApiService(sl<Dio>()));
  sl.registerLazySingleton<HiveService>(() => HiveService());

  // DATA SOURCES
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl<HiveService>()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiService>()),
  );
  sl.registerLazySingleton<LocalTripDataSource>(
    () => LocalTripDataSourceImpl(sl<HiveService>()),
  );
  sl.registerLazySingleton<LocalSavedTripDataSource>(
    () => LocalSavedTripDataSourceImpl(sl<HiveService>()),
  );

  // REPOSITORIES
  sl.registerLazySingleton<AuthLocalRepository>(
    () => AuthLocalRepositoryImpl(sl<AuthLocalDataSource>()),
  );
  sl.registerLazySingleton<AuthRemoteRepository>(
    () => AuthRemoteRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<TripRepository>(
    () => TripRepositoryImpl(sl<LocalTripDataSource>()),
  );
  sl.registerLazySingleton<SavedTripRepository>(
    () => SavedTripRepositoryImpl(sl<LocalSavedTripDataSource>()),
  );

  // AUTH - Remote Use Cases
  sl.registerLazySingleton(() => RemoteLoginUser(sl<AuthRemoteRepository>()));
  sl.registerLazySingleton(() => RemoteRegisterUser(sl<AuthRemoteRepository>()));

  // AUTH - Local Use Cases
  sl.registerLazySingleton(() => LoginUser(sl<AuthLocalRepository>()));
  sl.registerLazySingleton(() => RegisterUser(sl<AuthLocalRepository>()));
  sl.registerLazySingleton(() => GetUserEmail(sl<AuthLocalRepository>()));
  sl.registerLazySingleton(() => ChangePassword(sl<AuthLocalRepository>()));
  sl.registerLazySingleton(() => ForgotPassword(sl<AuthLocalRepository>()));

  // TRIP Use Cases
  sl.registerLazySingleton(() => AddTrip(sl<TripRepository>()));
  sl.registerLazySingleton(() => GetAllTrips(sl<TripRepository>()));
  sl.registerLazySingleton(() => DeleteTrip(sl<TripRepository>()));
  sl.registerLazySingleton(() => UpdateTrip(sl<TripRepository>()));

  // SAVED TRIPS Use Cases
  sl.registerLazySingleton(() => AddSavedTrip(sl<SavedTripRepository>()));
  sl.registerLazySingleton(() => GetAllSavedTrips(sl<SavedTripRepository>()));
  sl.registerLazySingleton(() => DeleteSavedTrip(sl<SavedTripRepository>()));

  // CUBITS
  sl.registerFactory(() => ProfileCubit(
        sl<GetUserEmail>(),
        sl<ChangePassword>(),
      ));
  sl.registerFactory(() => SplashCubit(sl()));

  // BLOCS
  sl.registerFactory(() => AuthBloc(
        sl<RemoteLoginUser>(),
        sl<RemoteRegisterUser>(),
      ));

  sl.registerFactory(() => TripBloc(
        addTrip: sl(),
        getAllTrips: sl(),
        deleteTrip: sl(),
        updateTrip: sl(),
        addSavedTrip: sl(),
      ));

  sl.registerFactory(() => SavedTripBloc(
        addSavedTrip: sl(),
        getAllSavedTrips: sl(),
        deleteSavedTrip: sl(),
      ));
}
