part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String email;

  ProfileLoaded({required this.email});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}
