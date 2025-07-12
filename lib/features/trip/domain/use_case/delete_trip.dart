// lib/features/trip/domain/use_case/delete_trip.dart

import 'package:dartz/dartz.dart';
import 'package:travvie/core/error/failure.dart';
import 'package:travvie/features/trip/domain/repository/trip_repository.dart';

class DeleteTrip {
  final TripRepository repository;

  DeleteTrip(this.repository);

  Future<Either<Failure, void>> call(String tripId) {
    return repository.deleteTrip(tripId);
  }
}
