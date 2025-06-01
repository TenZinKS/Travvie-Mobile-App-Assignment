import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/cubit/splash_screen_cubit.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();

    // Delay for 2 seconds, then trigger cubit
    Future.delayed(const Duration(seconds: 2), () {
      context.read<SplashScreenCubit>().completeSplash();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashScreenCubit, bool>(
      listener: (context, state) {
        if (state) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
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

              // App Name
              const Text(
                'Travvie',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 30),

              // Loading Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
