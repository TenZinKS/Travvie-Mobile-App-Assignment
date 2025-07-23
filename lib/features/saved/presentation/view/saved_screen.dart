import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/features/saved/domain/entity/saved_trip_entity.dart';
import 'package:travvie/features/saved/presentation/view_model/saved_trip_bloc.dart';
import 'package:travvie/features/saved/presentation/view_model/saved_trip_event.dart';
import 'package:travvie/features/saved/presentation/view_model/saved_trip_state.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_bloc.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_event.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SavedTripBloc>()..add(LoadSavedTripsEvent()),
      child: BlocBuilder<SavedTripBloc, SavedTripState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Saved Trips", style: TextStyle(color: Colors.white)),
              backgroundColor: const Color(0xFF09A8C8),
              centerTitle: true,
            ),
            body: _buildBody(state, context),
          );
        },
      ),
    );
  }

  Widget _buildBody(SavedTripState state, BuildContext context) {
    if (state is SavedTripLoading) return const Center(child: CircularProgressIndicator());
    if (state is SavedTripError) return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));

    if (state is SavedTripLoaded) {
      final trips = state.trips;
      if (trips.isEmpty) {
        return Center(
          child: Text("No saved trips yet.", style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final trip = trips[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 1)],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Text("${trip.from} → ${trip.to}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF09A8C8))),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  BlocProvider.of<SavedTripBloc>(context).add(DeleteSavedTripEvent(trip.id));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Trip deleted successfully.")));
                },
              ),
              onTap: () => _showTripDetailsDialog(context, trip),
            ),
          );
        },
      );
    }

    return const SizedBox();
  }

  Future<void> _showTripDetailsDialog(BuildContext context, SavedTripEntity trip) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.bookmark, color: Color(0xFF09A8C8)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                trip.from,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF09A8C8)),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow("From", trip.from),
              _infoRow("To", trip.to),
              _infoRow("People", trip.numberOfPeople.toString()),
              const SizedBox(height: 12),
              const Text("🗺️ Itinerary", style: TextStyle(color: Color(0xFF09A8C8), fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(
                trip.itinerary.isNotEmpty ? trip.itinerary : "No itinerary provided.",
                style: const TextStyle(fontSize: 14.5, color: Colors.black87),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.assignment, color: Color(0xFF09A8C8)),
            label: const Text("Move to Planned"),
            onPressed: () => _promptForDatesAndMove(context, trip, "PLANNED"),
          ),
          TextButton.icon(
            icon: const Icon(Icons.flight_takeoff, color: Color(0xFF09A8C8)),
            label: const Text("Move to Upcoming"),
            onPressed: () => _promptForDatesAndMove(context, trip, "UPCOMING"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Color(0xFF09A8C8), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _promptForDatesAndMove(BuildContext context, SavedTripEntity trip, String status) {
    DateTime? startDate;
    DateTime? endDate;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Select Dates"),
          content: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => startDate = picked);
                  },
                  child: Text(startDate == null ? "Select Check-in Date" : "Check-in: ${_formatDate(startDate)}"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: startDate ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => endDate = picked);
                  },
                  child: Text(endDate == null ? "Select Check-out Date" : "Check-out: ${_formatDate(endDate)}"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (startDate != null && endDate != null) {
                  sl<TripBloc>().add(AddTripEvent(
                    TripEntity(
                      id: trip.id,
                      from: trip.from,
                      to: trip.to,
                      numberOfPeople: trip.numberOfPeople,
                      startDate: startDate!,
                      endDate: endDate!,
                      status: status,
                      itinerary: trip.itinerary,
                    ),
                  ));
                  sl<SavedTripBloc>().add(DeleteSavedTripEvent(trip.id));
                  Navigator.pop(context); // close date dialog
                  Navigator.pop(context); // close trip details dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select both check-in and check-out dates.")),
                  );
                }
              },
              child: const Text("Save", style: TextStyle(color: Color(0xFF09A8C8))),
            ),
          ],
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(color: Color(0xFF09A8C8), fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14.5, color: Colors.black87))),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day}/${date.month}/${date.year}";
  }
}
