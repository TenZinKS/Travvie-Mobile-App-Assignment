import '../../domain/entity/deepseek_response_entity.dart';

abstract class DeepSeekState {}

class DeepSeekInitial extends DeepSeekState {}

class DeepSeekLoading extends DeepSeekState {}

class DeepSeekLoaded extends DeepSeekState {
  final DeepSeekResponseEntity response;

  DeepSeekLoaded(this.response);
}

class DeepSeekError extends DeepSeekState {
  final String message;

  DeepSeekError(this.message);
}
