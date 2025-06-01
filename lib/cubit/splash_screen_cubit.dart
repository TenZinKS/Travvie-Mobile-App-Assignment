import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenCubit extends Cubit<bool> {
  SplashScreenCubit() : super(false);

  void completeSplash() {
    emit(true); // After 2 seconds, trigger navigation
  }
}
