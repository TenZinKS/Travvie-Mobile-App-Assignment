import 'package:travvie/features/deepseek/domain/entity/deepseek_request_entity.dart';

class DeepSeekRequestModel {
  final String from;
  final String to;
  final int numberOfPeople;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? refinePrompt;
  final List<Map<String, String>> previousMessages;

  DeepSeekRequestModel({
    required this.from,
    required this.to,
    required this.numberOfPeople,
    this.startDate,
    this.endDate,
    this.refinePrompt,
    this.previousMessages = const [],
  });

  /// Convert from domain entity to data model
  factory DeepSeekRequestModel.fromEntity(DeepSeekRequestEntity entity) {
    return DeepSeekRequestModel(
      from: entity.from,
      to: entity.to,
      numberOfPeople: entity.numberOfPeople,
      startDate: entity.startDate,
      endDate: entity.endDate,
      refinePrompt: entity.refinePrompt,
      previousMessages: entity.previousMessages,
    );
  }

  /// Convert model to domain entity
  DeepSeekRequestEntity toEntity() {
    return DeepSeekRequestEntity(
      from: from,
      to: to,
      numberOfPeople: numberOfPeople,
      startDate: startDate,
      endDate: endDate,
      refinePrompt: refinePrompt,
      previousMessages: previousMessages,
    );
  }

  /// Convert model to JSON for backend request
  Map<String, dynamic> toJson() {
    return {
      "from": from,
      "to": to,
      "numberOfPeople": numberOfPeople,
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
      "refinePrompt": refinePrompt,
      "messages": previousMessages,
    };
  }
}
