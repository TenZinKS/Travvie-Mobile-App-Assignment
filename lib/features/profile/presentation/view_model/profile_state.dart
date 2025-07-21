abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String email;
  final String? profileImagePath;

  ProfileLoaded({
    required this.email,
    this.profileImagePath,
  });
}

class ProfilePasswordChanged extends ProfileState {}

class ProfileDeleted extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}
