import 'package:equatable/equatable.dart';
import 'package:travvie/features/deepseek/domain/entity/deepseek_response_entity.dart';

class DeepSeekResponseModel extends Equatable {
  final String reply;

  const DeepSeekResponseModel({
    required this.reply,
  });

  factory DeepSeekResponseModel.fromJson(Map<String, dynamic> json) {
    return DeepSeekResponseModel(
      reply: json["reply"] as String? ?? "",
    );
  }

  /// Convert model to domain entity
  DeepSeekResponseEntity toEntity() {
    return DeepSeekResponseEntity(itinerary: reply);
  }

  @override
  List<Object?> get props => [reply];
}
