import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _signupUser() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
    } else if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
    } else {
      // Simulate success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup Successful")),
      );
      Navigator.pop(context); // back to login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo/logo.png', height: 120),
            const SizedBox(height: 20),
            const Text('Create an Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF09A8C8))),
            const SizedBox(height: 10),
            const Text('Start your travel journey with Travvie', style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 40),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _signupUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF09A8C8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 30),

            const Text('Or sign up with', style: TextStyle(color: Colors.black54)),
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
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Login', style: TextStyle(color: Color(0xFF09A8C8), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
