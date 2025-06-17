import 'package:flutter/material.dart';
import 'package:travvie/theme/theme.dart';
import 'package:travvie/view/dashboard.dart';
import 'package:travvie/view/login_view.dart';
import 'package:travvie/view/signup_view.dart';
import 'package:travvie/view/splash_screen_view.dart';

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
