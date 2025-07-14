// lib/features/saved/presentation/view_model/saved_trip_event.dart

import 'package:travvie/features/saved/domain/entity/saved_trip_entity.dart';

abstract class SavedTripEvent {}

class LoadSavedTripsEvent extends SavedTripEvent {}

class AddSavedTripEvent extends SavedTripEvent {
  final SavedTripEntity trip;

  AddSavedTripEvent(this.trip);
}

class DeleteSavedTripEvent extends SavedTripEvent {
  final String tripId;

  DeleteSavedTripEvent(this.tripId);
}
