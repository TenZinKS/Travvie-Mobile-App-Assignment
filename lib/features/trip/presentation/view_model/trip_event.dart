// lib/features/trip/presentation/view_model/trip_event.dart

import 'package:equatable/equatable.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';

abstract class TripEvent extends Equatable {
  const TripEvent();

  @override
  List<Object?> get props => [];
}

class LoadTripsEvent extends TripEvent {}

class AddTripEvent extends TripEvent {
  final TripEntity trip;

  const AddTripEvent(this.trip);

  @override
  List<Object?> get props => [trip];
}

class DeleteTripEvent extends TripEvent {
  final String tripId;

  const DeleteTripEvent(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class UpdateTripEvent extends TripEvent {
  final TripEntity trip;

  const UpdateTripEvent(this.trip);

  @override
  List<Object?> get props => [trip];
}

class SaveTripAsWishlistEvent extends TripEvent {
  final TripEntity trip;

  SaveTripAsWishlistEvent(this.trip);
}