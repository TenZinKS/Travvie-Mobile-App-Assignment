import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/core/network/network_info.dart';
import 'package:travvie/features/auth/data/data_source/local_datasource/auth_local_datasource.dart';
import 'package:travvie/features/auth/data/data_source/remote_datasource/auth_remote_datasource.dart';
import 'package:travvie/features/auth/data/model/user_model.dart';
import 'package:travvie/features/auth/domain/entity/login_response_entity.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';
import 'package:travvie/features/auth/domain/repository/auth_remote_repository.dart';

class AuthRemoteRepositoryImpl implements AuthRemoteRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRemoteRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, LoginResponseEntity>> login(
      String email, String password) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final remoteModel =
            await remoteDataSource.loginUser(email, password);

        // Save user locally
        await localDataSource.registerUser(
          UserModel.fromEntity(remoteModel.user),
        );

        return Right(remoteModel.toEntity());
      } catch (e) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    } else {
      final localUser = await localDataSource.loginUser(email, password);
      if (localUser != null) {
        return Right(
          LoginResponseEntity(
            token: "OFFLINE_MODE_TOKEN",
            user: localUser.toEntity(),
          ),
        );
      } else {
        return Left(LocalDatabaseFailure(
            message: "No local user found. Please connect to internet."));
      }
    }
  }

  @override
  Future<Either<Failure, void>> register(UserEntity user) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        await remoteDataSource.registerUser(user);
        await localDataSource.registerUser(UserModel.fromEntity(user));
        return const Right(null);
      } catch (e) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    } else {
      return Left(RemoteDatabaseFailure(
          message: "No internet connection. Registration failed."));
    }
  }
}
