import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/domain/repository/trip_repository.dart';
import 'package:travvie/features/trip/domain/repository/trip_remote_repository.dart';

class UpdateTrip {
  final TripRepository localRepository;
  final TripRemoteRepository remoteRepository;

  UpdateTrip(this.localRepository, this.remoteRepository);

  Future<Either<Failure, void>> call(TripEntity trip) async {
    final localResult = await localRepository.updateTrip(trip);
    return await localResult.fold(
      (failure) => Left(failure),
      (_) async {
        final remoteResult = await remoteRepository.updateTripInRemote(trip);
        return remoteResult;
      },
    );
  }
}
