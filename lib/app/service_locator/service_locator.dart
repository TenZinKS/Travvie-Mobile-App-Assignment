import 'package:get_it/get_it.dart';
import 'package:travvie/app/use_case/login_user.dart';
import 'package:travvie/app/use_case/register_user.dart';
import 'package:travvie/core/network/hive_service.dart';
import 'package:travvie/features/auth/data/data_source/local_datasource/auth_local_datasource.dart';
import 'package:travvie/features/auth/data/repository/local_repository/auth_local_repository_impl.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:travvie/features/profile/domain/use_case/get_user_email.dart';
import 'package:travvie/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:travvie/features/splash/presentation/view_model/splash_cubit.dart';

final sl = GetIt.instance;

Future<void> initLocator() async {
  // Core
  sl.registerLazySingleton<HiveService>(() => HiveService());

  // Data Source
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthLocalRepository>(
    () => AuthLocalRepositoryImpl(sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => GetUserEmail(sl()));

  // Cubit
  sl.registerFactory(() => ProfileCubit(sl()));


  // BLoC
  sl.registerFactory(() => AuthBloc(sl(), sl()));
  sl.registerFactory(() => SplashCubit(sl()));
}
