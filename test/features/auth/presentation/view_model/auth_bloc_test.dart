import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:travvie/features/auth/domain/use_case/remote_login_user.dart';
import 'package:travvie/features/auth/domain/use_case/remote_register_user.dart';
import 'package:travvie/features/auth/domain/entity/login_response_entity.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_event.dart';
import 'package:travvie/features/auth/presentation/view_model/auth_state.dart';
import 'package:travvie/core/network/hive_service.dart';

/// Mocks
class MockRemoteLoginUser extends Mock implements RemoteLoginUser {}

class MockRemoteRegisterUser extends Mock implements RemoteRegisterUser {}

class MockHiveService extends Mock implements HiveService {}

/// Dummy data
const tEmail = 'test@example.com';
const tPassword = 'password123';

final tUserEntity = UserEntity(
  id: '1',
  email: tEmail,
  password: tPassword,
  profilePic: 'https://example.com/profile.jpg',
  isAdmin: true,
);

final tLoginResponse = LoginResponseEntity(
  token: 'dummy-token-123',
  user: tUserEntity,
);

void main() {
  final sl = GetIt.instance;

  late AuthBloc authBloc;
  late MockRemoteLoginUser mockRemoteLoginUser;
  late MockRemoteRegisterUser mockRemoteRegisterUser;
  late MockHiveService mockHiveService;

  setUp(() {
    mockRemoteLoginUser = MockRemoteLoginUser();
    mockRemoteRegisterUser = MockRemoteRegisterUser();
    mockHiveService = MockHiveService();

    // Register HiveService in GetIt for tests
    sl.registerLazySingleton<HiveService>(() => mockHiveService);

    // ✅ Stub generic save<String> calls
    when(() => mockHiveService.save<String>(any(), any(), any()))
        .thenAnswer((_) async => Future.value());

    // ✅ Stub save<dynamic> calls as fallback
    when(() => mockHiveService.save<dynamic>(any(), any(), any()))
        .thenAnswer((_) async => Future.value());

    // ✅ Stub openUserBoxes
    when(() => mockHiveService.openUserBoxes())
        .thenAnswer((_) async => Future.value());

    authBloc = AuthBloc(mockRemoteLoginUser, mockRemoteRegisterUser);
  });

  tearDown(() {
    sl.reset();
  });

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthSuccess] when login succeeds',
    build: () {
      when(() => mockRemoteLoginUser.call(
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => Right(tLoginResponse));
      return authBloc;
    },
    act: (bloc) => bloc.add(
      LoginEvent(email: tEmail, password: tPassword),
    ),
    expect: () => [
      AuthLoading(),
      AuthSuccess(),
    ],
    verify: (_) {
      verify(() => mockRemoteLoginUser.call(
            email: tEmail,
            password: tPassword,
          )).called(1);
      verify(() => mockHiveService.save<String>(
            any(),
            any(),
            any(),
          )).called(greaterThan(0));
      verify(() => mockHiveService.openUserBoxes()).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthFailure] when login fails',
    build: () {
      when(() => mockRemoteLoginUser.call(
            email: tEmail,
            password: tPassword,
          )).thenAnswer(
        (_) async => Left(
          ApiFailure(
            statusCode: 401,
            message: 'Invalid credentials',
          ),
        ),
      );
      return authBloc;
    },
    act: (bloc) => bloc.add(
      LoginEvent(email: tEmail, password: tPassword),
    ),
    expect: () => [
      AuthLoading(),
      AuthFailure('Invalid credentials'),
    ],
    verify: (_) {
      verify(() => mockRemoteLoginUser.call(
            email: tEmail,
            password: tPassword,
          )).called(1);
      verifyNever(() => mockHiveService.save(any(), any(), any()));
      verifyNever(() => mockHiveService.openUserBoxes());
    },
  );
}
