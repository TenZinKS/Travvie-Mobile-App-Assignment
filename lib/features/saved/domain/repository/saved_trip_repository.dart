import 'package:dartz/dartz.dart';
import 'package:travvie/features/saved/domain/entity/saved_trip_entity.dart';
import 'package:travvie/core/error/failure.dart';

abstract class SavedTripRepository {
  Future<Either<Failure, void>> addSavedTrip(SavedTripEntity trip);
  Future<Either<Failure, List<SavedTripEntity>>> getAllSavedTrips();
  Future<Either<Failure, void>> deleteSavedTrip(String tripId);
}
