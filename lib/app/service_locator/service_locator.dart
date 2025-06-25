import 'package:get_it/get_it.dart';
import 'package:travvie/features/auth/data/repository/local_repository/auth_local_repository_impl.dart';
import '../../core/network/hive_service.dart';
import '../../features/auth/data/data_source/local_datasource/auth_local_datasource.dart';
import '../../features/auth/domain/repository/auth_local_repository.dart';
import '../../features/auth/presentation/view_model/auth_bloc.dart';
import '../../features/splash/presentation/view_model/splash_cubit.dart';
import '../use_case/login_user.dart';
import '../use_case/register_user.dart';

final sl = GetIt.instance;

Future<void> initLocator() async {
  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl());
  sl.registerLazySingleton<HiveService>(() => HiveService());


  // Repositories
  sl.registerLazySingleton<AuthLocalRepository>(() => AuthLocalRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));

  // BLoC / Cubits
  sl.registerFactory(() => AuthBloc(sl(), sl())); 
  sl.registerFactory(() => SplashCubit(sl()));
}
