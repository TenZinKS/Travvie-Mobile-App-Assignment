import 'package:flutter/material.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key}); // Removed key since you prefer it that way

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Center aligns the content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Homepage",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20), // Adds space between text and button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
