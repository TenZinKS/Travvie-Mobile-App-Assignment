import 'package:travvie/features/saved/domain/entity/saved_trip_entity.dart';

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
