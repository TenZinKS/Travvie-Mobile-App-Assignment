// lib/features/saved/presentation/view_model/saved_trip_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/features/saved/domain/use_case/add_saved_trip.dart';
import 'package:travvie/features/saved/domain/use_case/get_all_saved_trips.dart';
import 'package:travvie/features/saved/domain/use_case/delete_saved_trip.dart';
import 'package:travvie/features/saved/presentation/view_model/saved_trip_event.dart';
import 'package:travvie/features/saved/presentation/view_model/saved_trip_state.dart';

class SavedTripBloc extends Bloc<SavedTripEvent, SavedTripState> {
  final AddSavedTrip addSavedTrip;
  final GetAllSavedTrips getAllSavedTrips;
  final DeleteSavedTrip deleteSavedTrip;

  SavedTripBloc({
    required this.addSavedTrip,
    required this.getAllSavedTrips,
    required this.deleteSavedTrip,
  }) : super(SavedTripInitial()) {
    on<LoadSavedTripsEvent>(_onLoad);
    on<AddSavedTripEvent>(_onAdd);
    on<DeleteSavedTripEvent>(_onDelete);
  }

  Future<void> _onLoad(
    LoadSavedTripsEvent event,
    Emitter<SavedTripState> emit,
  ) async {
    emit(SavedTripLoading());
    final result = await getAllSavedTrips();
    result.fold(
      (failure) => emit(SavedTripError(failure.message)),
      (trips) => emit(SavedTripLoaded(trips)),
    );
  }

  Future<void> _onAdd(
    AddSavedTripEvent event,
    Emitter<SavedTripState> emit,
  ) async {
    emit(SavedTripLoading());
    final result = await addSavedTrip(event.trip);
    result.fold(
      (failure) => emit(SavedTripError(failure.message)),
      (_) => add(LoadSavedTripsEvent()),
    );
  }

  Future<void> _onDelete(
    DeleteSavedTripEvent event,
    Emitter<SavedTripState> emit,
  ) async {
    emit(SavedTripLoading());
    final result = await deleteSavedTrip(event.tripId);
    result.fold(
      (failure) => emit(SavedTripError(failure.message)),
      (_) => add(LoadSavedTripsEvent()),
    );
  }
}
