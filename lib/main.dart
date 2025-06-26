import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/app/app.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/core/network/hive_service.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:travvie/features/splash/presentation/view_model/splash_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Register all dependencies before using them
  await initLocator();

  // ✅ Now HiveService is safe to use
  await sl<HiveService>().init();

  // (Optional) Step 3: Add dummy user for testing if needed
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
