import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/domain/repository/trip_repository.dart';
import 'package:travvie/features/trip/domain/repository/trip_remote_repository.dart';

class GetAllTrips {
  final TripRepository localRepository;
  final TripRemoteRepository remoteRepository;

  GetAllTrips(this.localRepository, this.remoteRepository);

  Future<Either<Failure, List<TripEntity>>> call() async {
    // Get from local first
    final localResult = await localRepository.getAllTrips();
    final remoteResult = await remoteRepository.getAllTripsFromRemote();

    // You can merge or replace here as needed (or use only remote if preferred)
    return remoteResult;
  }
}
