// lib/features/saved/presentation/view_model/saved_trip_state.dart

import 'package:travvie/features/saved/domain/entity/saved_trip_entity.dart';

abstract class SavedTripState {}

class SavedTripInitial extends SavedTripState {}

class SavedTripLoading extends SavedTripState {}

class SavedTripLoaded extends SavedTripState {
  final List<SavedTripEntity> trips;

  SavedTripLoaded(this.trips);
}

class SavedTripError extends SavedTripState {
  final String message;

  SavedTripError(this.message);
}
