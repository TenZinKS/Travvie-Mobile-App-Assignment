import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';

abstract class TripRemoteRepository {
  Future<Either<Failure, List<TripEntity>>> getAllTripsFromRemote();
  Future<Either<Failure, void>> addTripToRemote(TripEntity trip);
  Future<Either<Failure, void>> updateTripInRemote(TripEntity trip);
  Future<Either<Failure, void>> deleteTripFromRemote(String tripId);
}
