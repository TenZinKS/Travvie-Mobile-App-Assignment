import 'package:equatable/equatable.dart';

class TripEntity extends Equatable {
  final String id;
  final String from;
  final String to;
  final int numberOfPeople;
  final DateTime? startDate;
  final DateTime? endDate;
  final String itinerary;
  final String status;

  const TripEntity({
    required this.id,
    required this.from,
    required this.to,
    required this.numberOfPeople,
    this.startDate,
    this.endDate,
    required this.itinerary,
    required this.status,
  });

  TripEntity copyWith({
    String? id,
    String? from,
    String? to,
    int? numberOfPeople,
    DateTime? startDate,
    DateTime? endDate,
    String? itinerary,
    String? status,
  }) {
    return TripEntity(
      id: id ?? this.id,
      from: from ?? this.from,
      to: to ?? this.to,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      itinerary: itinerary ?? this.itinerary,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        from,
        to,
        numberOfPeople,
        startDate,
        endDate,
        itinerary,
        status,
      ];
}
