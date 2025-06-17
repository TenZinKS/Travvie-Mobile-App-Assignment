import 'package:flutter/material.dart';
import 'package:travvie/app/theme/theme.dart';
import 'package:travvie/features/home/presentation/view/dashboard.dart';
import 'package:travvie/features/auth/presentation/view/login_view.dart';
import 'package:travvie/features/auth/presentation/view/signup_view.dart';
import 'package:travvie/features/splash/presentation/view/splash_screen_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travvie',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreenView(),
        '/login': (context) => const LoginView(),
        '/homepage': (context) => const Dashboard(),
        '/signup': (context) => const SignupView(),
      },
      theme: getApplicationTheme(),
    );
  }
}
