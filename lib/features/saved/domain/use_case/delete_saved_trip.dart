import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/saved/domain/repository/saved_trip_repository.dart';

class DeleteSavedTrip {
  final SavedTripRepository repo;

  DeleteSavedTrip(this.repo);

  Future<Either<Failure, void>> call(String tripId) {
    return repo.deleteSavedTrip(tripId);
  }
}
