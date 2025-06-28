import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/saved/data/data_source/local_datasource/local_saved_trip_datasource.dart';
import 'package:travvie/features/saved/data/model/saved_trip_model.dart';
import 'package:travvie/features/saved/domain/entity/saved_trip_entity.dart';
import 'package:travvie/features/saved/domain/repository/saved_trip_repository.dart';

class SavedTripRepositoryImpl implements SavedTripRepository {
  final LocalSavedTripDataSource local;

  SavedTripRepositoryImpl(this.local);

  @override
  Future<Either<Failure, void>> addSavedTrip(SavedTripEntity trip) async {
    try {
      await local.addSavedTrip(SavedTripModel.fromEntity(trip));
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SavedTripEntity>>> getAllSavedTrips() async {
    try {
      final models = await local.getAllSavedTrips();
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSavedTrip(String id) async {
    try {
      await local.deleteSavedTrip(id);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
