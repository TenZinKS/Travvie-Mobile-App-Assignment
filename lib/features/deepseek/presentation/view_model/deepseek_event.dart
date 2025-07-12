abstract class DeepSeekEvent {}

class GenerateTripEvent extends DeepSeekEvent {
  final String prompt;

  GenerateTripEvent(this.prompt);
}
