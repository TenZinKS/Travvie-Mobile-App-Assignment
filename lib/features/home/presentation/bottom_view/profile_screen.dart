import 'package:flutter/material.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';
import 'package:travvie/features/auth/presentation/view/login_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail = sl<AuthLocalRepository>().getCurrentUserEmail();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF09A8C8),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 30),

          // Avatar + Email
          CircleAvatar(
            radius: 45,
            backgroundColor: const Color(0xFF09A8C8),
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            userEmail ?? 'Unknown User',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _profileButton(
                  context,
                  icon: Icons.edit,
                  label: "Edit Profile",
                  onTap: () {
                    // Navigate to edit profile screen
                  },
                ),
                _profileButton(
                  context,
                  icon: Icons.lock,
                  label: "Change Password",
                  onTap: () {
                    // Navigate to change password screen
                  },
                ),
                _profileButton(
                  context,
                  icon: Icons.history,
                  label: "Check Travel History",
                  onTap: () {
                    // Navigate to travel history screen
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await sl<AuthLocalRepository>().logout();

                    // Navigate back to login view
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Logout", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileButton(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF09A8C8)),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
