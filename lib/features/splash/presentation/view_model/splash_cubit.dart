import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/repository/auth_local_repository.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthLocalRepository repository;

  SplashCubit(this.repository) : super(SplashInitial());

  void checkUserLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    final email = repository.getCurrentUserEmail();

    print('[SplashCubit] currentUserEmail = $email');

    if (email != null && email.isNotEmpty) {
      emit(SplashLoggedIn());
    } else {
      emit(SplashLoggedOut());
    }
  }
}
