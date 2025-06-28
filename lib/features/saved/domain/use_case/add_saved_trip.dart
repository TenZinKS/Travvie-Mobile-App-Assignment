import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/saved/domain/entity/saved_trip_entity.dart';
import 'package:travvie/features/saved/domain/repository/saved_trip_repository.dart';

class AddSavedTrip {
  final SavedTripRepository repository;

  AddSavedTrip(this.repository);

  Future<Either<Failure, void>> call(SavedTripEntity trip) {
    return repository.addSavedTrip(trip);
  }
}
