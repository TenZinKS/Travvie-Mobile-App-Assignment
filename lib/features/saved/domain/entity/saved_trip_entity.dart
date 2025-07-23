import 'package:equatable/equatable.dart';

class SavedTripEntity extends Equatable {
  final String id;
  final String from;
  final String to;
  final int numberOfPeople;
  final DateTime? startDate; // made nullable
  final DateTime? endDate;   // made nullable
  final String itinerary;

  const SavedTripEntity({
    required this.id,
    required this.from,
    required this.to,
    required this.numberOfPeople,
    this.startDate, // optional
    this.endDate,   // optional
    required this.itinerary,
  });

  @override
  List<Object?> get props => [
        id,
        from,
        to,
        numberOfPeople,
        startDate,
        endDate,
        itinerary,
      ];
}
