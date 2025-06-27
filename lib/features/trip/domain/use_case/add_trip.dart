import '../entity/trip_entity.dart';
import '../repository/trip_repository.dart';

class AddTrip {
  final TripRepository repository;

  AddTrip(this.repository);

  Future<void> call(TripEntity trip) {
    return repository.addTrip(trip);
  }
}
