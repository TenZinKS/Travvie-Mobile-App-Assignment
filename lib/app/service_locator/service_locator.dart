import 'package:get_it/get_it.dart';
import 'package:travvie/app/use_case/login_user.dart';
import 'package:travvie/app/use_case/register_user.dart';
import 'package:travvie/features/auth/data/data_source/local_datasource/auth_local_datasource.dart';
import 'package:travvie/features/auth/data/repository/local_repository/auth_local_repository_impl.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:travvie/features/splash/presentation/view_model/splash_cubit.dart';

final sl = GetIt.instance;

Future<void> initLocator() async {
  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl());

  // Repositories
  sl.registerLazySingleton<AuthLocalRepository>(() => AuthLocalRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));

  // BLoC / Cubits
  sl.registerFactory(() => AuthBloc(sl(), sl())); 
  sl.registerFactory(() => SplashCubit(sl()));
}
