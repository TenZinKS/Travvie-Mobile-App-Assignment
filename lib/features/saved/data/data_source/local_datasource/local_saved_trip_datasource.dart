import 'package:travvie/app/constant/hive_table_constants.dart';
import 'package:travvie/core/network/hive_service.dart';
import 'package:travvie/features/saved/data/model/saved_trip_model.dart';

abstract class LocalSavedTripDataSource {
  Future<void> addSavedTrip(SavedTripModel trip);
  Future<List<SavedTripModel>> getAllSavedTrips();
  Future<void> deleteSavedTrip(String tripId);
}

class LocalSavedTripDataSourceImpl implements LocalSavedTripDataSource {
  final HiveService hiveService;

  static const boxName = HiveTableConstants.savedTripsBox;

  LocalSavedTripDataSourceImpl(this.hiveService);

  @override
  Future<void> addSavedTrip(SavedTripModel trip) async {
    await hiveService.save<SavedTripModel>(boxName, trip.id, trip);
  }

  @override
  Future<void> deleteSavedTrip(String tripId) async {
    await hiveService.delete<SavedTripModel>(boxName, tripId);
  }

  @override
  Future<List<SavedTripModel>> getAllSavedTrips() async {
    return await hiveService.getAll<SavedTripModel>(boxName);
  }
}
