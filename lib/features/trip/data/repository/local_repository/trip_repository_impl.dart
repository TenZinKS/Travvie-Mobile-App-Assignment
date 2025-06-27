import 'package:travvie/features/trip/data/data_source/local_datasource/local_trip_datasource.dart';
import 'package:travvie/features/trip/data/model/trip_model.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/domain/repository/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final LocalTripDataSource localDataSource;

  TripRepositoryImpl(this.localDataSource);

  @override
  Future<void> addTrip(TripEntity trip) {
    return localDataSource.addTrip(TripModel.fromEntity(trip));
  }

  @override
  Future<List<TripEntity>> getAllTrips() async {
    final trips = await localDataSource.getAllTrips();
    return trips.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> deleteTrip(String id) {
    return localDataSource.deleteTrip(id);
  }

  @override
  Future<void> updateTrip(TripEntity trip) {
    return localDataSource.updateTrip(TripModel.fromEntity(trip));
  }
}
