import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/trip/domain/repository/trip_repository.dart';
import 'package:travvie/features/trip/domain/repository/trip_remote_repository.dart';
import 'package:travvie/features/trip/domain/use_case/delete_trip.dart';

class MockTripRepository extends Mock implements TripRepository {}

class MockTripRemoteRepository extends Mock implements TripRemoteRepository {}

void main() {
  late MockTripRepository localRepo;
  late MockTripRemoteRepository remoteRepo;
  late DeleteTrip usecase;

  const tripId = '123';

  setUp(() {
    localRepo = MockTripRepository();
    remoteRepo = MockTripRemoteRepository();
    usecase = DeleteTrip(localRepo, remoteRepo);
  });

  test('should delete trip locally and remotely on success', () async {
    // Arrange
    when(() => localRepo.deleteTrip(tripId))
        .thenAnswer((_) async => const Right(null));
    when(() => remoteRepo.deleteTripFromRemote(tripId))
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(tripId);

    // Assert
    expect(result, const Right(null));
    verify(() => localRepo.deleteTrip(tripId)).called(1);
    verify(() => remoteRepo.deleteTripFromRemote(tripId)).called(1);
  });

  test('should return local failure and not call remote', () async {
    // Arrange
    when(() => localRepo.deleteTrip(tripId))
        .thenAnswer((_) async => const Left(ApiFailure(statusCode: 500, message: "Remote delete failed")));

    // Act
    final result = await usecase(tripId);

    // Assert
    expect(result, const Left(ApiFailure(statusCode: 500, message: "Remote delete failed")));
    verify(() => localRepo.deleteTrip(tripId)).called(1);
    verifyNever(() => remoteRepo.deleteTripFromRemote(tripId));
  });

  test('should return remote failure after successful local delete', () async {
  // Arrange
  when(() => localRepo.deleteTrip(tripId))
      .thenAnswer((_) async => const Right(null));
  when(() => remoteRepo.deleteTripFromRemote(tripId))
      .thenAnswer((_) async => const Left(ApiFailure(statusCode: 500, message: "Remote delete failed")));

  // Act
  final result = await usecase(tripId);

  // Assert
  expect(result, const Left(ApiFailure(statusCode: 500, message: "Remote delete failed")));
  verify(() => localRepo.deleteTrip(tripId)).called(1);
  verify(() => remoteRepo.deleteTripFromRemote(tripId)).called(1);
});

}

