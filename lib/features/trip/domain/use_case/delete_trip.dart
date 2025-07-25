import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/trip/domain/repository/trip_repository.dart';
import 'package:travvie/features/trip/domain/repository/trip_remote_repository.dart';

class DeleteTrip {
  final TripRepository localRepository;
  final TripRemoteRepository remoteRepository;

  DeleteTrip(this.localRepository, this.remoteRepository);

  Future<Either<Failure, void>> call(String tripId) async {
    final localResult = await localRepository.deleteTrip(tripId);
    return await localResult.fold(
      (failure) => Left(failure),
      (_) async {
        final remoteResult = await remoteRepository.deleteTripFromRemote(tripId);
        return remoteResult;
      },
    );
  }
}
