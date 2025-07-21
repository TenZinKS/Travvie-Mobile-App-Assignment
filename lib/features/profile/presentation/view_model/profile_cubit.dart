import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';
import 'package:travvie/features/profile/presentation/view_model/profile_state.dart';
import 'package:travvie/features/profile/domain/use_case/get_user_email.dart';
import 'package:travvie/features/auth/domain/use_case/change_password.dart';
import 'package:travvie/features/profile/domain/use_case/delete_user.dart';
import 'package:travvie/core/network/hive_service.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserEmail getUserEmail;
  final ChangePassword changePassword;
  final DeleteUser deleteUser;
  final HiveService hive;
  final AuthLocalRepository localRepo;


  ProfileCubit({
    required this.getUserEmail,
    required this.changePassword,
    required this.deleteUser,
    required this.hive,
    required this.localRepo,

  }) : super(ProfileInitial());

  void loadUserEmail() async {
    emit(ProfileLoading());

    final result = await getUserEmail();

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (email) async {
        final profilePath = await hive.getProfileImagePath(email);
        emit(ProfileLoaded(email: email, profileImagePath: profilePath));
      },
    );
  }

  Future<void> changeUserPassword({
  required String email,
  required String currentPassword,
  required String newPassword,
}) async {
  emit(ProfileLoading());

  final user = localRepo.getCurrentUser();
  if (user == null) {
    emit(ProfileError(message: "User not found"));
    return;
  }

  final result = await changePassword(
    userId: user.id,
    currentPassword: currentPassword,
    newPassword: newPassword,
  );

  result.fold(
    (failure) => emit(ProfileError(message: failure.message)),
    (_) => emit(ProfilePasswordChanged()),
  );
}


  Future<void> deleteAccount({required String id, required String email}) async {
    emit(ProfileLoading());

    try {
      await deleteUser(id); // ✅ Use ID here
      await hive.deleteUser(email); // ✅ Delete from Hive using email
      emit(ProfileDeleted());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> updateProfileImage(String email) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      await hive.saveProfileImagePath(email, picked.path);
      emit(ProfileLoaded(email: email, profileImagePath: picked.path));
    }
  }
}
