import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/features/auth/presentation/view/login_view.dart';
import 'package:travvie/features/home/presentation/view/dashboard.dart';
import '../view_model/splash_cubit.dart';
import '../view_model/splash_state.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashLoggedIn) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Dashboard()),
            );
          } else if (state is SplashLoggedOut) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginView()),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo/logo.png', height: 400),
              const SizedBox(height: 30),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
