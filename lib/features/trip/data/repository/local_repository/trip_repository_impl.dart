// lib/features/trip/data/repository/local_repository/trip_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/trip/data/data_source/local_datasource/local_trip_datasource.dart';
import 'package:travvie/features/trip/data/model/trip_model.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/domain/repository/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final LocalTripDataSource localDataSource;

  TripRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, void>> addTrip(TripEntity trip) async {
    try {
      await localDataSource.addTrip(TripModel.fromEntity(trip));
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTrip(String tripId) async {
    try {
      await localDataSource.deleteTrip(tripId);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TripEntity>>> getAllTrips() async {
    try {
      final trips = await localDataSource.getAllTrips();
      return Right(trips.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTrip(TripEntity trip) async {
    try {
      await localDataSource.updateTrip(TripModel.fromEntity(trip));
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
