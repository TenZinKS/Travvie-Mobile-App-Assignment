import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/domain/repository/trip_repository.dart';
import 'package:travvie/features/trip/domain/repository/trip_remote_repository.dart';
import 'package:travvie/features/trip/domain/use_case/get_all_trips.dart';

class MockLocalTripRepo extends Mock implements TripRepository {}

class MockRemoteTripRepo extends Mock implements TripRemoteRepository {}

void main() {
  late GetAllTrips usecase;
  late MockLocalTripRepo localRepo;
  late MockRemoteTripRepo remoteRepo;

  final trips = [
    const TripEntity(
      id: '1',
      from: 'A',
      to: 'B',
      numberOfPeople: 2,
      startDate: null,
      endDate: null,
      itinerary: 'Something',
      status: 'PLANNED',
    ),
  ];

  setUp(() {
    localRepo = MockLocalTripRepo();
    remoteRepo = MockRemoteTripRepo();
    usecase = GetAllTrips(localRepo, remoteRepo);
  });

  test('should return remote trips even if local call is made first', () async {
    when(() => localRepo.getAllTrips())
        .thenAnswer((_) async => Right([]));
    when(() => remoteRepo.getAllTripsFromRemote())
        .thenAnswer((_) async => Right(trips));

    final result = await usecase();

    expect(result, Right(trips));
    verify(() => localRepo.getAllTrips()).called(1);
    verify(() => remoteRepo.getAllTripsFromRemote()).called(1);
  });

  test('should return remote failure if remote call fails', () async {
    when(() => localRepo.getAllTrips())
        .thenAnswer((_) async => Right([]));
    when(() => remoteRepo.getAllTripsFromRemote())
        .thenAnswer((_) async => Left(ApiFailure(statusCode: 404, message: 'Not found')));

    final result = await usecase();

    expect(result, Left(ApiFailure(statusCode: 404, message: 'Not found')));
    verify(() => localRepo.getAllTrips()).called(1);
    verify(() => remoteRepo.getAllTripsFromRemote()).called(1);
  });
}
