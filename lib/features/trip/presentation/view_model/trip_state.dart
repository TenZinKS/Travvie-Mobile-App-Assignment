import 'package:equatable/equatable.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';

abstract class TripState extends Equatable {
  const TripState();

  @override
  List<Object?> get props => [];
}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripLoaded extends TripState {
  final List<TripEntity> trips;

  const TripLoaded(this.trips);

  @override
  List<Object?> get props => [trips];
}

class TripAddedSuccess extends TripState {}

class TripUpdateSuccess extends TripState {}

class TripDeletedSuccess extends TripState {}

class TripError extends TripState {
  final String message;

  const TripError(this.message);

  @override
  List<Object?> get props => [message];
}
