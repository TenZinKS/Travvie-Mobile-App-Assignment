import '../entity/trip_entity.dart';
import '../repository/trip_repository.dart';

class UpdateTrip {
  final TripRepository repository;

  UpdateTrip(this.repository);

  Future<void> call(TripEntity trip) {
    return repository.updateTrip(trip);
  }
}
