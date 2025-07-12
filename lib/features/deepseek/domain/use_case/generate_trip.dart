import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/deepseek/data/model/deepseek_request_model.dart';
import 'package:travvie/features/deepseek/domain/entity/deepseek_response_entity.dart';
import 'package:travvie/features/deepseek/domain/repository/deepseek_repository.dart';

class GenerateTrip {
  final DeepSeekRepository repository;

  GenerateTrip(this.repository);

  Future<Either<Failure, DeepSeekResponseEntity>> call(DeepSeekRequestModel requestModel) {
    return repository.generateTrip(requestModel);
  }
}
