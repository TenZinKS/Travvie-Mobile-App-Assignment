class DeepSeekRequestEntity {
  final String from;
  final String to;
  final int numberOfPeople;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? refinePrompt;
  final List<Map<String, String>> previousMessages;

  DeepSeekRequestEntity({
    required this.from,
    required this.to,
    required this.numberOfPeople,
    this.startDate,
    this.endDate,
    this.refinePrompt,
    this.previousMessages = const [],
  });
}
