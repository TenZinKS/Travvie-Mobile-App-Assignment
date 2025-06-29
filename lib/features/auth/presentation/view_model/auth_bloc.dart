import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/app/constant/hive_table_constants.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/app/use_case/login_user.dart';
import 'package:travvie/app/use_case/register_user.dart';
import 'package:travvie/core/network/hive_service.dart';
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

    await result.fold(
      (failure) async {
        emit(AuthFailure(_mapFailureToMessage(failure)));
      },
      (user) async {
        // ✅ This opens user-specific boxes!
        await sl<HiveService>().openUserBoxes();
        emit(AuthSuccess());
      },
    );
  }

  Future<void> _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final newUser = UserEntity(
      email: event.email.trim(),
      password: event.password.trim(),
    );

    final result = await registerUser(newUser);

    await result.fold(
      (failure) async {
        emit(AuthFailure(_mapFailureToMessage(failure)));
      },
      (_) async {
        // ✅ Save the newly registered user as logged in
        await sl<HiveService>().save<String>(
          HiveTableConstants.sessionBox,
          HiveTableConstants.currentUserEmail,
          newUser.email,
        );

        await sl<HiveService>().openUserBoxes();
        emit(AuthSuccess());
      },
    );
  }


  String _mapFailureToMessage(Failure failure) {
    if (failure is LocalDatabaseFailure) return failure.message;
    if (failure is ApiFailure) return 'API Error: ${failure.statusCode}';
    if (failure is RemoteDatabaseFailure) return 'Remote DB Error';
    return 'Unexpected Error';
  }
}
