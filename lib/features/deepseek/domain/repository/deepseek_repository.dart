import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/deepseek/data/model/deepseek_request_model.dart';
import 'package:travvie/features/deepseek/domain/entity/deepseek_response_entity.dart';

abstract class DeepSeekRepository {
  Future<Either<Failure, DeepSeekResponseEntity>> generateTrip(
    DeepSeekRequestModel requestModel,
  );
}
