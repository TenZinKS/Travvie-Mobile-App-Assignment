import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/saved/domain/entity/saved_trip_entity.dart';
import 'package:travvie/features/saved/domain/repository/saved_trip_repository.dart';

class GetAllSavedTrips {
  final SavedTripRepository repository;

  GetAllSavedTrips(this.repository);

  Future<Either<Failure, List<SavedTripEntity>>> call() {
    return repository.getAllSavedTrips();
  }
}
