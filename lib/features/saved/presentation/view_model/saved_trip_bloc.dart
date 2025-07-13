import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/features/saved/domain/use_case/add_saved_trip.dart';
import 'package:travvie/features/saved/domain/use_case/get_all_saved_trips.dart';
import 'package:travvie/features/saved/domain/use_case/delete_saved_trip.dart';
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

  Future<void> _onLoad(LoadSavedTripsEvent event, Emitter<SavedTripState> emit) async {
    emit(SavedTripLoading());
    final result = await getAllSavedTrips();
    result.fold(
      (failure) => emit(SavedTripError(failure.message)),
      (trips) => emit(SavedTripLoaded(trips)),
    );
  }

  Future<void> _onAdd(AddSavedTripEvent event, Emitter<SavedTripState> emit) async {
    emit(SavedTripLoading());
    final result = await addSavedTrip(event.trip);
    result.fold(
      (failure) => emit(SavedTripError(failure.message)),
      (_) => add(LoadSavedTripsEvent()),
    );
  }

  Future<void> _onDelete(DeleteSavedTripEvent event, Emitter<SavedTripState> emit) async {
    emit(SavedTripLoading());
    final result = await deleteSavedTrip(event.tripId);
    result.fold(
      (failure) => emit(SavedTripError(failure.message)),
      (_) => add(LoadSavedTripsEvent()),
    );
  }
}
