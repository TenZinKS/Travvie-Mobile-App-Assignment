import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';
import 'package:travvie/features/profile/presentation/view/profile_screen.dart';
import 'package:travvie/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:travvie/features/profile/presentation/view_model/profile_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? userEmail;

  @override
  void initState() {
    super.initState();
    userEmail = sl<AuthLocalRepository>().getCurrentUserEmail();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() {
    if (!_formKey.currentState!.validate()) return;

    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();

    if (userEmail == null) {
      Fluttertoast.showToast(msg: "❌ No user logged in");
      return;
    }

    context.read<ProfileCubit>().changeUserPassword(
          email: userEmail!,
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Change Password", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: const Color(0xFF09A8C8),
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) async {
            if (state is ProfilePasswordChanged) {
              Fluttertoast.showToast(
                msg: "✅ Password changed successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );

              // Wait a bit before navigating
              await Future.delayed(const Duration(milliseconds: 800));

              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  (route) => false,
                );
              }
            } else if (state is ProfileError) {
              Fluttertoast.showToast(msg: "❌ ${state.message}");
            }
          },
          builder: (context, state) {
            final isLoading = state is ProfileLoading;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: currentPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Current Password",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Enter current password" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "New Password",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Enter new password";
                        if (value.length < 6) return "Minimum 6 characters";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Confirm New Password",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Confirm your password";
                        if (value != newPasswordController.text.trim()) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleChangePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF09A8C8),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Save",
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
  }
}
