import 'package:travvie/core/network/hive_service.dart';
import 'package:travvie/app/constant/hive_table_constants.dart';
import 'package:travvie/features/saved/data/model/saved_trip_model.dart';

abstract class LocalSavedTripDataSource {
  Future<void> addSavedTrip(SavedTripModel trip);
  Future<List<SavedTripModel>> getAllSavedTrips();
  Future<void> deleteSavedTrip(String tripId);
}

class LocalSavedTripDataSourceImpl implements LocalSavedTripDataSource {
  final HiveService hive;

  LocalSavedTripDataSourceImpl(this.hive);

  @override
  Future<void> addSavedTrip(SavedTripModel trip) async {
    final userEmail = hive.getCurrentUserEmail();
    await hive.save<SavedTripModel>(
      "${HiveTableConstants.savedTripsBox}_$userEmail",
      trip.id,
      trip,
    );
  }

  @override
  Future<List<SavedTripModel>> getAllSavedTrips() async {
    final userEmail = hive.getCurrentUserEmail();
    return await hive.getAll<SavedTripModel>(
      "${HiveTableConstants.savedTripsBox}_$userEmail",
    );
  }

  @override
  Future<void> deleteSavedTrip(String tripId) async {
    final userEmail = hive.getCurrentUserEmail();
    await hive.delete<SavedTripModel>(
      "${HiveTableConstants.savedTripsBox}_$userEmail",
      tripId,
    );
  }
}
