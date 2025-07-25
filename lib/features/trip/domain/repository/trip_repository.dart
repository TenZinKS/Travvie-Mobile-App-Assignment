import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';

abstract class TripRepository {
  Future<Either<Failure, List<TripEntity>>> getAllTrips();
  Future<Either<Failure, void>> addTrip(TripEntity trip);
  Future<Either<Failure, void>> updateTrip(TripEntity trip);
  Future<Either<Failure, void>> deleteTrip(String tripId);
}
