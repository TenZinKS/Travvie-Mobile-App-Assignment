import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import '../../../domain/entity/deepseek_response_entity.dart';
import '../../../domain/repository/deepseek_repository.dart';
import '../../data_source/remote_datasource/remote_deepseek_datasource.dart';

class DeepSeekRepositoryImpl implements DeepSeekRepository {
  final RemoteDeepSeekDataSource remoteDataSource;

  DeepSeekRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DeepSeekResponseEntity>> generateTrip(String prompt) async {
    try {
      final result = await remoteDataSource.generateTrip(prompt);
      return Right(result);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
