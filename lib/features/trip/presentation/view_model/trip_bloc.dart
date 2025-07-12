// lib/features/trip/presentation/view_model/trip_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/features/trip/domain/use_case/get_all_trips.dart';
import 'package:travvie/features/trip/domain/use_case/add_trip.dart';
import 'package:travvie/features/trip/domain/use_case/delete_trip.dart';
import 'package:travvie/features/trip/domain/use_case/update_trip.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_event.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final GetAllTrips getAllTrips;
  final AddTrip addTrip;
  final DeleteTrip deleteTrip;
  final UpdateTrip updateTrip;

  TripBloc({
    required this.getAllTrips,
    required this.addTrip,
    required this.deleteTrip,
    required this.updateTrip,
  }) : super(TripInitial()) {
    on<LoadTripsEvent>(_onLoadTrips);
    on<AddTripEvent>(_onAddTrip);
    on<DeleteTripEvent>(_onDeleteTrip);
    on<UpdateTripEvent>(_onUpdateTrip);
  }

  Future<void> _onLoadTrips(
      LoadTripsEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    final result = await getAllTrips();
    result.fold(
      (failure) => emit(TripError(failure.message)),
      (trips) => emit(TripLoaded(trips)),
    );
  }

  Future<void> _onAddTrip(
      AddTripEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    final result = await addTrip(event.trip);
    result.fold(
      (failure) => emit(TripError(failure.message)),
      (_) => add(LoadTripsEvent()),
    );
  }

  Future<void> _onDeleteTrip(
      DeleteTripEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    final result = await deleteTrip(event.tripId);
    result.fold(
      (failure) => emit(TripError(failure.message)),
      (_) => add(LoadTripsEvent()),
    );
  }

  Future<void> _onUpdateTrip(
      UpdateTripEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    final result = await updateTrip(event.trip);
    result.fold(
      (failure) => emit(TripError(failure.message)),
      (_) => add(LoadTripsEvent()),
    );
  }
}
