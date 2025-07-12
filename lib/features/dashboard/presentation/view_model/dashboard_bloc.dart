import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/app/constant/hive_table_constants.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/core/network/hive_service.dart';
import 'package:travvie/features/dashboard/domain/entity/dashboard_entity.dart';
import 'package:travvie/features/dashboard/presentation/view_model/dashboard_event.dart';
import 'package:travvie/features/dashboard/presentation/view_model/dashboard_state.dart';
import 'package:travvie/features/trip/data/model/trip_model.dart';
import 'package:travvie/features/saved/data/model/saved_trip_model.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
      LoadDashboardEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());

    try {
      final hive = sl<HiveService>();

      final currentEmail = hive.getCurrentUserEmail();
      if (currentEmail == null) {
        emit(DashboardError("No user logged in."));
        return;
      }

      /// Open user-specific boxes
      await hive.openUserBoxes();

      // Read all trips
      final trips = await hive.getAll<TripModel>(
          "${HiveTableConstants.tripsBox}_$currentEmail");

      int completedTrips = trips.where((t) => t.status == "COMPLETED").length;
      int cancelledTrips = trips.where((t) => t.status == "CANCELLED").length;
      int upcomingTrips = trips.where((t) => t.status == "UPCOMING").length;

      // Read wishlist items
      final savedTrips = await hive.getAll<SavedTripModel>(
          "${HiveTableConstants.savedTripsBox}_$currentEmail");
      int wishlistCount = savedTrips.length;

      final totalTrips = completedTrips + cancelledTrips;
      double completionRate = totalTrips > 0
          ? (completedTrips / totalTrips) * 100
          : 0.0;

      String travellerRank;
      if (completionRate >= 80) {
        travellerRank = "Gold Traveller";
      } else if (completionRate >= 50) {
        travellerRank = "Silver Traveller";
      } else {
        travellerRank = "Bronze Traveller";
      }

      final dashboard = DashboardEntity(
        completedTrips: completedTrips,
        cancelledTrips: cancelledTrips,
        upcomingTrips: upcomingTrips,
        wishlistCount: wishlistCount,
        completionRate: completionRate,
        travellerRank: travellerRank,
      );

      emit(DashboardLoaded(dashboard));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
