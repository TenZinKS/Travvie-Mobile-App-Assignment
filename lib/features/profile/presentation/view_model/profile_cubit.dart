import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/features/profile/domain/use_case/get_user_email.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserEmail getUserEmail;

  ProfileCubit(this.getUserEmail) : super(ProfileInitial());

  void loadUserEmail() async {
    emit(ProfileLoading());

    final result = await getUserEmail();

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (email) => emit(ProfileLoaded(email: email)),
    );
  }
}
