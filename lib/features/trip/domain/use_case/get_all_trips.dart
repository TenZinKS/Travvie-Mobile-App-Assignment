// lib/features/trip/domain/use_case/get_all_trips.dart

import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/domain/repository/trip_repository.dart';

class GetAllTrips {
  final TripRepository repository;

  GetAllTrips(this.repository);

  Future<Either<Failure, List<TripEntity>>> call() {
    return repository.getAllTrips();
  }
}
