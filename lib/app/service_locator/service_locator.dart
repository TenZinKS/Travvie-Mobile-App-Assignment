import 'package:get_it/get_it.dart';
import 'package:travvie/app/use_case/login_user.dart';
import 'package:travvie/app/use_case/register_user.dart';
import 'package:travvie/core/network/hive_service.dart';
import 'package:travvie/features/auth/data/data_source/local_datasource/auth_local_datasource.dart';
import 'package:travvie/features/auth/data/repository/local_repository/auth_local_repository_impl.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';
import 'package:travvie/features/auth/domain/use_case/change_password.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:travvie/features/profile/domain/use_case/get_user_email.dart';
import 'package:travvie/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:travvie/features/splash/presentation/view_model/splash_cubit.dart';
import 'package:travvie/features/trip/data/data_source/local_datasource/local_trip_datasource.dart';
import 'package:travvie/features/trip/data/repository/local_repository/trip_repository_impl.dart';
import 'package:travvie/features/trip/domain/repository/trip_repository.dart';
import 'package:travvie/features/trip/domain/use_case/add_trip.dart';
import 'package:travvie/features/trip/domain/use_case/get_all_trips.dart';
import 'package:travvie/features/trip/domain/use_case/delete_trip.dart';
import 'package:travvie/features/trip/domain/use_case/update_trip.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_bloc.dart';

import 'package:travvie/features/saved/data/data_source/local_datasource/local_saved_trip_datasource.dart';
import 'package:travvie/features/saved/data/repository/local_repository/saved_trip_repository_impl.dart';
import 'package:travvie/features/saved/domain/repository/saved_trip_repository.dart';
import 'package:travvie/features/saved/domain/use_case/add_saved_trip.dart';
import 'package:travvie/features/saved/domain/use_case/get_all_saved_trips.dart';
import 'package:travvie/features/saved/domain/use_case/delete_saved_trip.dart';
import 'package:travvie/features/saved/presentation/view_model/saved_trip_bloc.dart';

final sl = GetIt.instance;

Future<void> initLocator() async {
  // Core
  sl.registerLazySingleton<HiveService>(() => HiveService());

  // Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl<HiveService>()));
  sl.registerLazySingleton<LocalTripDataSource>(
      () => LocalTripDataSourceImpl(sl<HiveService>()));
  sl.registerLazySingleton<LocalSavedTripDataSource>(
      () => LocalSavedTripDataSourceImpl(sl<HiveService>()));

  // Repositories
  sl.registerLazySingleton<AuthLocalRepository>(
      () => AuthLocalRepositoryImpl(sl<AuthLocalDataSource>()));
  sl.registerLazySingleton<TripRepository>(
      () => TripRepositoryImpl(sl<LocalTripDataSource>()));
  sl.registerLazySingleton<SavedTripRepository>(
      () => SavedTripRepositoryImpl(sl<LocalSavedTripDataSource>()));

  // Usecases - Auth
  sl.registerLazySingleton(() => LoginUser(sl<AuthLocalRepository>()));
  sl.registerLazySingleton(() => RegisterUser(sl<AuthLocalRepository>()));
  sl.registerLazySingleton(() => GetUserEmail(sl<AuthLocalRepository>()));
  sl.registerLazySingleton(() => ChangePassword(sl<AuthLocalRepository>()));

  // Usecases - Trips
  sl.registerLazySingleton(() => AddTrip(sl<TripRepository>()));
  sl.registerLazySingleton(() => GetAllTrips(sl<TripRepository>()));
  sl.registerLazySingleton(() => DeleteTrip(sl<TripRepository>()));
  sl.registerLazySingleton(() => UpdateTrip(sl<TripRepository>()));

  // Usecases - Saved Trips
  sl.registerLazySingleton(() => AddSavedTrip(sl<SavedTripRepository>()));
  sl.registerLazySingleton(() => GetAllSavedTrips(sl<SavedTripRepository>()));
  sl.registerLazySingleton(() => DeleteSavedTrip(sl<SavedTripRepository>()));

  // Cubits
  sl.registerFactory(() => ProfileCubit(
        sl<GetUserEmail>(),
        sl<ChangePassword>(),
      ));
  sl.registerFactory(() => SplashCubit(sl()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(sl(), sl()));

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
