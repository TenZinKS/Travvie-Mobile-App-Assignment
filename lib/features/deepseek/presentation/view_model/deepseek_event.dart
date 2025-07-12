part of 'deepseek_bloc.dart';

abstract class DeepSeekEvent {}

class GenerateTripEvent extends DeepSeekEvent {
  final DeepSeekRequestModel requestModel;

  GenerateTripEvent(this.requestModel);
}
