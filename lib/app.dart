import 'package:flutter/material.dart';
import 'package:travvie/view/home_page_view.dart';
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
        '/': (context) =>  SplashScreenView(),
        '/login': (context) => const LoginView(),
        '/homepage': (context) => const HomePageView(),
        '/signup': (context) => const SignupView(),
      },
    );
  }
}
