import 'package:hive_flutter/hive_flutter.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';

part 'trip_model.g.dart';

@HiveType(typeId: 1)
class TripModel extends HiveObject {
  @HiveField(0)
  final String id; // tripId (MongoDB _id)

  @HiveField(1)
  final String from;

  @HiveField(2)
  final String to;

  @HiveField(3)
  final int numberOfPeople;

  @HiveField(4)
  final DateTime? startDate;

  @HiveField(5)
  final DateTime? endDate;

  @HiveField(6)
  final String itinerary;

  @HiveField(7)
  final String status;

  // ✅ Not stored in Hive, just used for backend JSON
  final String? userId;

  TripModel({
    required this.id,
    required this.from,
    required this.to,
    required this.numberOfPeople,
    this.startDate,
    this.endDate,
    required this.itinerary,
    required this.status,
    this.userId,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json["_id"] ?? "",
      from: json["from"] ?? "",
      to: json["destination"] ?? "", // ✅ Must match backend key
      numberOfPeople: json["numberOfPeople"] ?? 1,
      startDate: json["startDate"] != null
          ? DateTime.tryParse(json["startDate"])
          : null,
      endDate: json["endDate"] != null
          ? DateTime.tryParse(json["endDate"])
          : null,
      itinerary: json["itinerary"] ?? "",
      status: json["status"] ?? "PLANNED",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "from": from,
      "destination": to, // ✅ Must match backend key
      "numberOfPeople": numberOfPeople,
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
      "itinerary": itinerary,
      "status": status,
      if (userId != null) "userId": userId,
    };
  }

  TripEntity toEntity() {
    return TripEntity(
      id: id,
      from: from,
      to: to,
      numberOfPeople: numberOfPeople,
      startDate: startDate,
      endDate: endDate,
      itinerary: itinerary,
      status: status,
    );
  }

  factory TripModel.fromEntity(TripEntity entity, {String? userId}) {
    return TripModel(
      id: entity.id,
      from: entity.from,
      to: entity.to,
      numberOfPeople: entity.numberOfPeople,
      startDate: entity.startDate,
      endDate: entity.endDate,
      itinerary: entity.itinerary,
      status: entity.status,
      userId: userId,
    );
  }
}
