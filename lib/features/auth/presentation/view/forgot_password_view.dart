import 'package:flutter/material.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/features/auth/domain/use_case/forgot_password.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool success = false;

  void _resetPassword() async {
    final email = emailController.text.trim();
    final newPassword = newPasswordController.text.trim();

    if (email.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required.")),
      );
      return;
    }

    final result = await sl<ForgotPassword>().call(
      email: email,
      newPassword: newPassword,
    );

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.message)),
      ),
      (_) {
        setState(() {
          success = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password changed successfully!")),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: const Color(0xFF09A8C8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF09A8C8),
              ),
              child: const Text("Change Password"),
            ),
          ],
        ),
      ),
    );
  }
}
