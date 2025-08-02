import 'package:flutter_test/flutter_test.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';

void main() {
  group('TripEntity', () {
    final baseDate = DateTime(2025, 8, 10);

    final trip1 = TripEntity(
      id: 'trip_001',
      from: 'Kathmandu',
      to: 'Tokyo',
      numberOfPeople: 3,
      startDate: baseDate,
      endDate: baseDate.add(const Duration(days: 5)),
      itinerary: '🌅 Morning sightseeing\n🍽️ Sushi lunch\n🛏️ Hotel stay',
      status: 'PLANNED',
    );

    final trip2 = TripEntity(
      id: 'trip_001',
      from: 'Kathmandu',
      to: 'Tokyo',
      numberOfPeople: 3,
      startDate: baseDate,
      endDate: baseDate.add(const Duration(days: 5)),
      itinerary: '🌅 Morning sightseeing\n🍽️ Sushi lunch\n🛏️ Hotel stay',
      status: 'PLANNED',
    );

    test('supports value equality', () {
      expect(trip1, equals(trip2));
      expect(trip1 == trip2, isTrue);
    });

    test('props contain all fields', () {
      expect(
        trip1.props,
        [
          'trip_001',
          'Kathmandu',
          'Tokyo',
          3,
          baseDate,
          baseDate.add(const Duration(days: 5)),
          '🌅 Morning sightseeing\n🍽️ Sushi lunch\n🛏️ Hotel stay',
          'PLANNED',
        ],
      );
    });

    test('copyWith overrides individual fields correctly', () {
      final updatedTrip = trip1.copyWith(
        status: 'COMPLETED',
        numberOfPeople: 5,
      );

      expect(updatedTrip.id, 'trip_001');
      expect(updatedTrip.status, 'COMPLETED');
      expect(updatedTrip.numberOfPeople, 5);
      expect(updatedTrip.to, 'Tokyo'); // unchanged
    });
  });
}
