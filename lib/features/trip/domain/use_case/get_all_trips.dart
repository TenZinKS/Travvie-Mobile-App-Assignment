import '../entity/trip_entity.dart';
import '../repository/trip_repository.dart';

class GetAllTrips {
  final TripRepository repository;

  GetAllTrips(this.repository);

  Future<List<TripEntity>> call() {
    return repository.getAllTrips();
  }
}
