import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/app/app.dart';
import 'app/service_locator/service_locator.dart';
import 'core/network/hive_service.dart';
import 'features/auth/presentation/view_model/auth_bloc.dart';
import 'features/splash/presentation/view_model/splash_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init service locator (which registers HiveService)
  await initLocator();

  // Init Hive + register adapters + open boxes
  await sl<HiveService>().init();

  // Optional: add dummy user for testing
  await sl<HiveService>().seedDummyUser();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<SplashCubit>()..checkUserLogin()),
      ],
      child: const App(),
    ),
  );
}
