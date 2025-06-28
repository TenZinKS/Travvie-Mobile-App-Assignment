import 'package:equatable/equatable.dart';

class SavedTripEntity extends Equatable {
  final String id;
  final String title;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String itinerary;
  final bool isCompleted;

  const SavedTripEntity({
    required this.id,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.itinerary,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        destination,
        startDate,
        endDate,
        itinerary,
        isCompleted,
      ];
}
