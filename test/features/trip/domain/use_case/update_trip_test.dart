import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/domain/repository/trip_remote_repository.dart';
import 'package:travvie/features/trip/domain/repository/trip_repository.dart';
import 'package:travvie/features/trip/domain/use_case/update_trip.dart';

class MockTripRepository extends Mock implements TripRepository {}

class MockTripRemoteRepository extends Mock implements TripRemoteRepository {}

void main() {
  late MockTripRepository localRepo;
  late MockTripRemoteRepository remoteRepo;
  late UpdateTrip usecase;

  setUp(() {
    localRepo = MockTripRepository();
    remoteRepo = MockTripRemoteRepository();
    usecase = UpdateTrip(localRepo, remoteRepo);
  });

  final trip = TripEntity(
    id: "1",
    from: "Pokhara",
    to: "Kathmandu",
    numberOfPeople: 2,
    startDate: DateTime(2025, 8, 10),
    endDate: DateTime(2025, 8, 15),
    itinerary: "Fun days",
    status: "PLANNED",
  );

  test('should update trip locally and remotely', () async {
    // Arrange
    when(() => localRepo.updateTrip(trip))
        .thenAnswer((_) async => const Right(null));
    when(() => remoteRepo.updateTripInRemote(trip))
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(trip);

    // Assert
    expect(result, const Right(null));
    verify(() => localRepo.updateTrip(trip)).called(1);
    verify(() => remoteRepo.updateTripInRemote(trip)).called(1);
  });

  test('should return failure if local update fails', () async {
    // Arrange
    when(() => localRepo.updateTrip(trip))
        .thenAnswer((_) async => const Left(LocalDatabaseFailure(message: "Local failed")));

    // Act
    final result = await usecase(trip);

    // Assert
    expect(result, const Left(LocalDatabaseFailure(message: "Local failed")));
    verify(() => localRepo.updateTrip(trip)).called(1);
    verifyNever(() => remoteRepo.updateTripInRemote(trip));
  });

  test('should return failure if remote update fails after local succeeds', () async {
    // Arrange
    when(() => localRepo.updateTrip(trip))
        .thenAnswer((_) async => const Right(null));
    when(() => remoteRepo.updateTripInRemote(trip))
        .thenAnswer((_) async => const Left(ApiFailure(statusCode: 500, message: "Remote failed")));

    // Act
    final result = await usecase(trip);

    // Assert
    expect(result, const Left(ApiFailure(statusCode: 500, message: "Remote failed")));
    verify(() => localRepo.updateTrip(trip)).called(1);
    verify(() => remoteRepo.updateTripInRemote(trip)).called(1);
  });
}
