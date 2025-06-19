import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/app/use_case/login_user.dart';
import 'package:travvie/app/use_case/register_user.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;

  AuthBloc(this.loginUser, this.registerUser) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final user = await loginUser(event.email, event.password);
      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("Invalid email or password"));
      }
    } catch (e) {
      emit(AuthFailure("Login failed"));
    }
  }

  Future<void> _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final newUser = UserEntity(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      await registerUser(newUser);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure("User already exists with this email"));
    }
  }
}
