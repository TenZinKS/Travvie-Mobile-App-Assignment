import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_state.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_event.dart';
import 'package:travvie/features/auth/domain/use_case/remote_login_user.dart';
import 'package:travvie/features/auth/domain/use_case/remote_register_user.dart';
import 'package:travvie/core/network/hive_service.dart';
import 'package:get_it/get_it.dart';



class MockRemoteLoginUser extends Mock implements RemoteLoginUser {}

class MockRemoteRegisterUser extends Mock implements RemoteRegisterUser {}

class MockHiveService extends Mock implements HiveService {}

class FakeAuthBloc extends AuthBloc {
  FakeAuthBloc()
      : super(MockRemoteLoginUser(), MockRemoteRegisterUser());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    yield AuthInitial();
  }
}

void main() {
  final sl = GetIt.instance;

  setUp(() {
    sl.registerLazySingleton<HiveService>(() => MockHiveService());
    sl.registerLazySingleton<AuthBloc>(() => FakeAuthBloc());
  });

  tearDown(() {
    sl.reset();
  });

  testWidgets('SignupView shows UI elements', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: Size(1200, 800),
          ),
          child: Scaffold(
            body: Column(
              children: [
                const Text('Create an Account'),
                const Text('Start your travel journey with Travvie'),
                const Text('Sign Up')
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Create an Account'), findsOneWidget);
    expect(find.text('Start your travel journey with Travvie'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });
}
