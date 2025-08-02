import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/core/network/hive_service.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';
import 'package:travvie/features/auth/domain/repository/auth_remote_repository.dart';
import 'package:travvie/features/auth/presentation/view/login_view.dart';
import 'package:travvie/features/profile/presentation/view/change_password_screen.dart';
import 'package:travvie/features/profile/presentation/view_model/profile_cubit.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userEmail;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    userEmail = sl<AuthLocalRepository>().getCurrentUserEmail();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    if (userEmail == null) return;
    final path = await sl<HiveService>().getProfileImagePath(userEmail!);
    if (mounted) {
      setState(() {
        _imagePath = path;
      });
    }
  }

  Future<void> _pickImage() async {
    if (userEmail == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      await sl<HiveService>().saveProfileImagePath(userEmail!, picked.path);
      setState(() {
        _imagePath = picked.path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile image updated.")),
      );
    }
  }

  Future<void> _deleteAccount() async {
    final localRepo = sl<AuthLocalRepository>();
    final remoteRepo = sl<AuthRemoteRepository>();
    final hive = sl<HiveService>();

    final email = localRepo.getCurrentUserEmail();
    final UserEntity? userModel = localRepo.getCurrentUser();

    if (email == null || userModel == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text("Are you sure you want to delete your account? This cannot be undone."),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: const Text("Delete"),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await hive.deleteUser(email);
        await remoteRepo.deleteUserById(userModel.id);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginView()),
          (route) => false,
        );
      } catch (e) {
        print("Error deleting account: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete account: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ProfileCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF09A8C8),
          title: const Text('Profile', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: const Color(0xFF09A8C8),
                  backgroundImage:
                      _imagePath != null ? FileImage(File(_imagePath!)) : null,
                  child: _imagePath == null
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                userEmail ?? 'Unknown User',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _profileButton(
                      icon: Icons.lock,
                      label: "Change Password",
                      onTap: () {
                        if (userEmail == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("No user logged in.")),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: sl<ProfileCubit>(),
                              child: ChangePasswordScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                    _profileButton(
                      icon: Icons.delete,
                      label: "Delete Account",
                      onTap: _deleteAccount,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await sl<AuthLocalRepository>().logout();
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
        ),
      ),
    );
  }

  Widget _profileButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
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
