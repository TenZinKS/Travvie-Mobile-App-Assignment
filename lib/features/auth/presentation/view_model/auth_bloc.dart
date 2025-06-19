import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthLocalRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await repository.login(event.email, event.password);
    if (user != null) {
      emit(AuthSuccess());
    } else {
      emit(AuthFailure("Invalid email or password"));
    }
  }

  void _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final newUser = UserEntity(
        email: event.email.trim(),
        password: event.password.trim(),
      );
      await repository.register(newUser);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure("User already exists with this email"));
    }
  }
}
