part of 'deepseek_bloc.dart';

abstract class DeepSeekState {}

class DeepSeekInitial extends DeepSeekState {}

class DeepSeekLoading extends DeepSeekState {}

class DeepSeekFailure extends DeepSeekState {
  final String message;

  DeepSeekFailure(this.message);
}

class DeepSeekSuccess extends DeepSeekState {
  final DeepSeekRequestModel request;
  final DeepSeekResponseEntity response;

  DeepSeekSuccess({
    required this.request,
    required this.response,
  });
}
