import 'package:flutter/material.dart';
import 'package:travvie/features/auth/presentation/view/login_view.dart';
import 'package:travvie/features/auth/presentation/view/signup_view.dart';
import 'package:travvie/features/home/presentation/view/dashboard.dart';
import 'package:travvie/features/splash/presentation/view/splash_screen_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travvie',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreenView(),
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignupView(),
        '/dashboard': (context) => const Dashboard(),
      }
    );
  }
}
