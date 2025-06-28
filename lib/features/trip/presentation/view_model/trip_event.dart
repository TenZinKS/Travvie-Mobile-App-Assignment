part of 'trip_bloc.dart';

abstract class TripEvent extends Equatable {
  const TripEvent();

  @override
  List<Object> get props => [];
}

class LoadTripsEvent extends TripEvent {}

class AddTripEvent extends TripEvent {
  final TripEntity trip;

  AddTripEvent(this.trip);
}

class DeleteTripEvent extends TripEvent {
  final String tripId;

  DeleteTripEvent(this.tripId);
}

class UpdateTripEvent extends TripEvent {
  final TripEntity trip;

  UpdateTripEvent(this.trip);
}

class SaveTripAsWishlistEvent extends TripEvent {
  final TripEntity trip;

  const SaveTripAsWishlistEvent(this.trip);

  @override
  List<Object> get props => [trip];
}
