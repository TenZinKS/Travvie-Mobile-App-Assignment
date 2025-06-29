import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/profile/domain/use_case/get_user_email.dart';
import 'package:travvie/features/auth/domain/use_case/change_password.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserEmail getUserEmail;
  final ChangePassword changePassword;

  ProfileCubit(this.getUserEmail, this.changePassword) : super(ProfileInitial());

  void loadUserEmail() async {
    emit(ProfileLoading());

    final result = await getUserEmail();

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (email) => emit(ProfileLoaded(email: email)),
    );
  }

  Future<void> changeUserPassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ProfileLoading());

    final result = await changePassword(
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (_) => emit(ProfilePasswordChanged()),
    );
  }
}
