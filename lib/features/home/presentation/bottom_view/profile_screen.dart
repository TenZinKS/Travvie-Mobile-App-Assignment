import 'package:flutter/material.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body:
        Column(
          children: [
            const Spacer(),
            // Logout Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  sl<AuthLocalRepository>().logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text("Logout"),
              )
            ),
          ],
        ),
      );
  }
}
