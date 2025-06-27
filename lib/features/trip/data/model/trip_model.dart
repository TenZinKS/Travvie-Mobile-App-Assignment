
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entity/trip_entity.dart';

part 'trip_model.g.dart';

@HiveType(typeId: 1)
class TripModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String destination;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final DateTime endDate;

  @HiveField(5)
  final String itinerary;

  @HiveField(6)
  final bool isCompleted;

  TripModel({
    required this.id,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.itinerary,
    required this.isCompleted,
  });

  TripEntity toEntity() {
    return TripEntity(
      id: id,
      title: title,
      destination: destination,
      startDate: startDate,
      endDate: endDate,
      itinerary: itinerary,
      isCompleted: isCompleted,
    );
  }

  factory TripModel.fromEntity(TripEntity entity) {
    return TripModel(
      id: entity.id,
      title: entity.title,
      destination: entity.destination,
      startDate: entity.startDate,
      endDate: entity.endDate,
      itinerary: entity.itinerary,
      isCompleted: entity.isCompleted,
    );
  }
}
