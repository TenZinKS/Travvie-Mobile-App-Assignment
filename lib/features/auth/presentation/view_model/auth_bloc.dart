import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/app/use_case/login_user.dart';
import 'package:travvie/app/use_case/register_user.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_event.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_state.dart';
import 'package:travvie/core/error/failure.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;

  AuthBloc(this.loginUser, this.registerUser) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await loginUser(event.email.trim(), event.password.trim());

    result.fold(
      (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
      (_) => emit(AuthSuccess()),
    );
  }

  Future<void> _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final newUser = UserEntity(
      email: event.email.trim(),
      password: event.password.trim(),
    );

    final result = await registerUser(newUser);

    result.fold(
      (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
      (_) => emit(AuthSuccess()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is LocalDatabaseFailure) return failure.message;
    if (failure is ApiFailure) return 'API Error: ${failure.statusCode}';
    if (failure is RemoteDatabaseFailure) return 'Remote DB Error';
    return 'Unexpected Error';
  }
}
