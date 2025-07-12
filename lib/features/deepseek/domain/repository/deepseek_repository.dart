import 'package:dartz/dartz.dart';
import '../entity/deepseek_response_entity.dart';
import 'package:travvie/core/error/failure.dart';

abstract class DeepSeekRepository {
  Future<Either<Failure, DeepSeekResponseEntity>> generateTrip(String prompt);
}
