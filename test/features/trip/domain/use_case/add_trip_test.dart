import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/core/network/network_info.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/domain/repository/trip_repository.dart';
import 'package:travvie/features/trip/domain/repository/trip_remote_repository.dart';
import 'package:travvie/features/trip/domain/use_case/add_trip.dart';

class MockTripRepository extends Mock implements TripRepository {}

class MockTripRemoteRepository extends Mock implements TripRemoteRepository {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockTripRepository mockTripRepository;
  late MockTripRemoteRepository mockTripRemoteRepository;
  late MockNetworkInfo mockNetworkInfo;
  late AddTrip usecase;

  const trip = TripEntity(
    id: "123",
    from: "Pokhara",
    to: "Lumbini",
    numberOfPeople: 2,
    startDate: null,
    endDate: null,
    itinerary: "Explore peaceful places",
    status: "PLANNED",
  );

  setUp(() {
    mockTripRepository = MockTripRepository();
    mockTripRemoteRepository = MockTripRemoteRepository();
    mockNetworkInfo = MockNetworkInfo();
    usecase = AddTrip(mockTripRepository, mockTripRemoteRepository, mockNetworkInfo);
  });

  test("should add trip locally and remotely if connected", () async {
    // Arrange
    when(() => mockTripRepository.addTrip(trip)).thenAnswer((_) async => const Right(null));
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(() => mockTripRemoteRepository.addTripToRemote(trip)).thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(trip);

    // Assert
    expect(result, const Right(null));
    verify(() => mockTripRepository.addTrip(trip)).called(1);
    verify(() => mockTripRemoteRepository.addTripToRemote(trip)).called(1);
    verify(() => mockNetworkInfo.isConnected).called(1);
  });

  test("should only add trip locally if not connected", () async {
    // Arrange
    when(() => mockTripRepository.addTrip(trip)).thenAnswer((_) async => const Right(null));
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

    // Act
    final result = await usecase(trip);

    // Assert
    expect(result, const Right(null));
    verify(() => mockTripRepository.addTrip(trip)).called(1);
    verifyNever(() => mockTripRemoteRepository.addTripToRemote(trip));
    verify(() => mockNetworkInfo.isConnected).called(1);
  });
}
