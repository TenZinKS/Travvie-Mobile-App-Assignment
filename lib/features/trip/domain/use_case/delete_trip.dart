import '../repository/trip_repository.dart';

class DeleteTrip {
  final TripRepository repository;

  DeleteTrip(this.repository);

  Future<void> call(String tripId) {
    return repository.deleteTrip(tripId);
  }
}
