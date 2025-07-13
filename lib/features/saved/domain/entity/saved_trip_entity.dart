import 'package:equatable/equatable.dart';

class SavedTripEntity extends Equatable {
  final String id;
  final String from;
  final String to;
  final int numberOfPeople;
  final DateTime startDate;
  final DateTime endDate;
  final String itinerary;

  const SavedTripEntity({
    required this.id,
    required this.from,
    required this.to,
    required this.numberOfPeople,
    required this.startDate,
    required this.endDate,
    required this.itinerary,
  });

  @override
  List<Object?> get props => [id, from, to, numberOfPeople, startDate, endDate, itinerary];
}
