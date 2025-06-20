import 'package:flutter/material.dart';
import 'package:travvie/features/splash/presentation/view/splash_screen_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Travvie',
      debugShowCheckedModeBanner: false,
      home: SplashScreenView(), // 👈 Start directly from splash
    );
  }
}
