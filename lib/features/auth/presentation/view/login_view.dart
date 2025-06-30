import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/features/auth/presentation/view/forgot_password_view.dart';
import 'package:travvie/features/auth/presentation/view/signup_view.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_event.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_state.dart';
import 'package:travvie/features/home/presentation/view/dashboard.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _login(BuildContext context) {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
    } else {
      context.read<AuthBloc>().add(LoginEvent(email: email, password: password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>(),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Dashboard()),
                );
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo/logo.png', height: 150),
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF09A8C8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Log in to your Travvie account',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ✅ NEW FORGOT PASSWORD BUTTON
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ForgotPasswordView()),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color(0xFF09A8C8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _login(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF09A8C8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: state is AuthLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text('Or login with', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 15),
                    SignInButton(Buttons.Google, onPressed: () {}),
                    const SizedBox(width: 10),
                    SignInButton(Buttons.Facebook, onPressed: () {}),
                    const SizedBox(width: 10),
                    SignInButton(Buttons.Apple, onPressed: () {}),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SignupView()),
                            );
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Color(0xFF09A8C8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
