import 'package:flutter/material.dart';

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
            // Profile Picture
            const SizedBox(height: 30),
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                "https://www.shutterstock.com/image-vector/july-3-2023-vector-illustration-600nw-2326749515.jpg",
              ),
            ),
            const SizedBox(height: 10),

            // Name
            const Text(
              'Tenzin Kunsel Sherpa',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // Profile Options
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Travvie'),
              onTap: () {},
            ),

            const Spacer(),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
            ),
          ],
        ),
      );
  }
}
