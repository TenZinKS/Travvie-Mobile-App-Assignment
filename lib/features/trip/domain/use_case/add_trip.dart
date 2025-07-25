import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/core/network/network_info.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/domain/repository/trip_repository.dart';
import 'package:travvie/features/trip/domain/repository/trip_remote_repository.dart';

class AddTrip {
  final TripRepository repository;
  final TripRemoteRepository remoteRepository;
  final NetworkInfo networkInfo;

  AddTrip(this.repository, this.remoteRepository, this.networkInfo);

  Future<Either<Failure, void>> call(TripEntity trip) async {
    // Save locally
    final localResult = await repository.addTrip(trip);

    // Then save remotely if internet is available
    final connected = await networkInfo.isConnected;
    if (connected) {
      await remoteRepository.addTripToRemote(trip);
    }

    return localResult;
  }
}
