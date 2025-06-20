import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:travvie/app/app.dart';
import 'package:travvie/app/constant/hive_table_constants.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/features/auth/data/model/user_model.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:travvie/features/splash/presentation/view_model/splash_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());

  // Open Hive boxes
  await Hive.openBox<UserModel>(HiveTableConstants.usersBox);
  await Hive.openBox(HiveTableConstants.sessionBox);

  // Init service locator
  await initLocator();

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
