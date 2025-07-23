import 'package:hive_flutter/hive_flutter.dart';
import 'package:travvie/features/saved/domain/entity/saved_trip_entity.dart';

part 'saved_trip_model.g.dart';

@HiveType(typeId: 2)
class SavedTripModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String from;

  @HiveField(2)
  String to;

  @HiveField(3)
  int numberOfPeople;

  @HiveField(4)
  DateTime? startDate; 

  @HiveField(5)
  DateTime? endDate;   

  @HiveField(6)
  String itinerary;

  SavedTripModel({
    required this.id,
    required this.from,
    required this.to,
    required this.numberOfPeople,
    this.startDate, // ✅ Optional
    this.endDate,   // ✅ Optional
    required this.itinerary,
  });

  SavedTripEntity toEntity() {
    return SavedTripEntity(
      id: id,
      from: from,
      to: to,
      numberOfPeople: numberOfPeople,
      startDate: startDate, 
      endDate: endDate,     
      itinerary: itinerary,
    );
  }

  factory SavedTripModel.fromEntity(SavedTripEntity entity) {
    return SavedTripModel(
      id: entity.id,
      from: entity.from,
      to: entity.to,
      numberOfPeople: entity.numberOfPeople,
      startDate: entity.startDate, 
      endDate: entity.endDate,     
      itinerary: entity.itinerary,
    );
  }
}
