import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/auth/domain/entity/login_response_entity.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';
import 'package:travvie/features/auth/domain/use_case/remote_login_user.dart';

import 'package:travvie/features/auth/domain/repository/auth_remote_repository.dart';

import '../../../../helpers/token.mock.dart';
import '../../../../mocks/repository.mock.dart';

void main() {
  late RemoteLoginUser remoteLoginUser;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    remoteLoginUser = RemoteLoginUser(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';

  final tUserEntity = UserEntity(
    id: '1',
    email: tEmail,
    password: tPassword,
    profilePic: 'https://example.com/profile.jpg',
    isAdmin: true,
  );

  final tLoginResponseEntity = LoginResponseEntity(
    token: dummyToken,
    user: tUserEntity,
  );

  test('returns Right(LoginResponseEntity) when login succeeds', () async {
    // Arrange
    when(() => mockAuthRepository.login(tEmail, tPassword))
        .thenAnswer((_) async => Right(tLoginResponseEntity));

    // Act
    final result = await remoteLoginUser(
      email: tEmail,
      password: tPassword,
    );

    // Assert
    expect(result, Right(tLoginResponseEntity));
    verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
  });

  test('returns Left(ApiFailure) when login fails', () async {
    // Arrange
    final failure = ApiFailure(
      statusCode: 401,
      message: 'Invalid credentials',
    );
    when(() => mockAuthRepository.login(tEmail, tPassword))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await remoteLoginUser(
      email: tEmail,
      password: tPassword,
    );

    // Assert
    expect(result, Left(failure));
    verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
  });
}
