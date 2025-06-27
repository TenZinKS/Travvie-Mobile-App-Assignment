import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/domain/use_case/add_trip.dart';
import 'package:travvie/features/trip/domain/use_case/delete_trip.dart';
import 'package:travvie/features/trip/domain/use_case/get_all_trips.dart';
import 'package:travvie/features/trip/domain/use_case/update_trip.dart';


part 'trip_event.dart';
part 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final AddTrip addTrip;
  final GetAllTrips getAllTrips;
  final DeleteTrip deleteTrip;
  final UpdateTrip updateTrip;

  TripBloc({
    required this.addTrip,
    required this.getAllTrips,
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
    try {
      final trips = await getAllTrips();
      emit(TripLoaded(trips));
    } catch (e) {
      emit(TripError("Failed to load trips: $e"));
    }
  }

  Future<void> _onAddTrip(AddTripEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    try {
      await addTrip(event.trip);
      final trips = await getAllTrips();
      emit(TripLoaded(trips));
    } catch (e) {
      emit(TripError("Failed to add trip: $e"));
    }
  }

  Future<void> _onDeleteTrip(
      DeleteTripEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    try {
      await deleteTrip(event.tripId);
      final trips = await getAllTrips();
      emit(TripLoaded(trips));
    } catch (e) {
      emit(TripError("Failed to delete trip: $e"));
    }
  }

  Future<void> _onUpdateTrip(
      UpdateTripEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    try {
      await updateTrip(event.trip);
      final trips = await getAllTrips();
      emit(TripLoaded(trips));
    } catch (e) {
      emit(TripError("Failed to update trip: $e"));
    }
  }
}
