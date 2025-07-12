// lib/features/trip/domain/use_case/update_trip.dart

import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/domain/repository/trip_repository.dart';

class UpdateTrip {
  final TripRepository repository;

  UpdateTrip(this.repository);

  Future<Either<Failure, void>> call(TripEntity trip) {
    return repository.updateTrip(trip);
  }
}
