import 'package:dartz/dartz.dart';
import '../entity/deepseek_response_entity.dart';
import '../repository/deepseek_repository.dart';
import 'package:travvie/core/error/failure.dart';

class GenerateTrip {
  final DeepSeekRepository repository;

  GenerateTrip(this.repository);

  Future<Either<Failure, DeepSeekResponseEntity>> call(String prompt) async {
    return await repository.generateTrip(prompt);
  }
}
