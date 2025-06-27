import 'package:equatable/equatable.dart';

class TripEntity extends Equatable {
  final String id;
  final String title;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String itinerary;
  final bool isCompleted;

  const TripEntity({
    required this.id,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.itinerary,
    required this.isCompleted,
  });

  TripEntity copyWith({
    String? id,
    String? title,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    String? itinerary,
    bool? isCompleted,
  }) {
    return TripEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      itinerary: itinerary ?? this.itinerary,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

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
