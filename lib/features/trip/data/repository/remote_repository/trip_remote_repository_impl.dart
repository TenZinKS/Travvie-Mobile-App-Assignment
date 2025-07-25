import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/trip/data/data_source/remote_datasource/trip_remote_data_source.dart';
import 'package:travvie/features/trip/data/model/trip_model.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/domain/repository/trip_remote_repository.dart';
import 'package:dio/dio.dart';
import 'package:travvie/core/network/token_provider.dart';

class TripRemoteRepositoryImpl implements TripRemoteRepository {
  final TripRemoteDataSource remoteDataSource;

  TripRemoteRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> addTripToRemote(TripEntity trip) async {
    try {
      final userId = await TokenProvider.getUserId(); 
      final model = TripModel.fromEntity(trip, userId: userId);
      await remoteDataSource.addTrip(model);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ApiFailure(
        statusCode: e.response?.statusCode ?? 500,
        message: e.message ?? 'Dio error occurred',
      ));
    } catch (e) {
      return const Left(ApiFailure(statusCode: 500, message: "Unexpected error occurred"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTripFromRemote(String tripId) async {
    try {
      await remoteDataSource.deleteTrip(tripId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ApiFailure(
        statusCode: e.response?.statusCode ?? 500,
        message: e.message ?? 'Dio error occurred',
      ));
    } catch (e) {
      return const Left(ApiFailure(statusCode: 500, message: "Unexpected error occurred"));
    }
  }

  @override
  Future<Either<Failure, List<TripEntity>>> getAllTripsFromRemote() async {
    try {
      final models = await remoteDataSource.getAllTrips();
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on DioException catch (e) {
      return Left(ApiFailure(
        statusCode: e.response?.statusCode ?? 500,
        message: e.message ?? 'Dio error occurred',
      ));
    } catch (e) {
      return const Left(ApiFailure(statusCode: 500, message: "Unexpected error occurred"));
    }
  }

  @override
  Future<Either<Failure, void>> updateTripInRemote(TripEntity trip) async {
    try {
      final model = TripModel.fromEntity(trip);
      await remoteDataSource.updateTrip(model);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ApiFailure(
        statusCode: e.response?.statusCode ?? 500,
        message: e.message ?? 'Dio error occurred',
      ));
    } catch (e) {
      return const Left(ApiFailure(statusCode: 500, message: "Unexpected error occurred"));
    }
  }
}
