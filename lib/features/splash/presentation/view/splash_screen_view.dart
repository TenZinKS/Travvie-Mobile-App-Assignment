import 'package:flutter/material.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();

    // Delay for 2 seconds, then navigate to login
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'assets/logo/logo.png',
              width: 500,
              height: 500,
            ),

            const SizedBox(height: 30),

            // Loading Indicator
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
