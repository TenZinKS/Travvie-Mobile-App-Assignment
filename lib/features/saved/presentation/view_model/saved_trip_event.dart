part of 'saved_trip_bloc.dart';

abstract class SavedTripEvent {}

class LoadSavedTripsEvent extends SavedTripEvent {}

class AddSavedTripEvent extends SavedTripEvent {
  final SavedTripEntity trip;
  AddSavedTripEvent(this.trip);
}

class DeleteSavedTripEvent extends SavedTripEvent {
  final String id;
  DeleteSavedTripEvent(this.id);
}
