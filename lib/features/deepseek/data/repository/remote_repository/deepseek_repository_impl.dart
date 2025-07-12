import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/deepseek/data/data_source/remote_datasource/remote_deepseek_datasource.dart';
import 'package:travvie/features/deepseek/data/model/deepseek_request_model.dart';
import 'package:travvie/features/deepseek/domain/entity/deepseek_response_entity.dart';
import 'package:travvie/features/deepseek/domain/repository/deepseek_repository.dart';

class DeepSeekRepositoryImpl implements DeepSeekRepository {
  final RemoteDeepSeekDataSource remoteDataSource;

  DeepSeekRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DeepSeekResponseEntity>> generateTrip(
      DeepSeekRequestModel requestModel) async {
    try {
      final result = await remoteDataSource.generateTrip(requestModel);
      return Right(result.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
