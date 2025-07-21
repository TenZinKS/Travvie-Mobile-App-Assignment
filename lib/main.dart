import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/app/app.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/core/network/hive_service.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:travvie/features/splash/presentation/view_model/splash_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator and all dependencies
  await initLocator();

  // Init HiveService (register adapters + open boxes)
  await sl<HiveService>().init();

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
