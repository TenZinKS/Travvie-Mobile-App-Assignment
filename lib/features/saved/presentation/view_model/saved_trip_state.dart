part of 'saved_trip_bloc.dart';

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
