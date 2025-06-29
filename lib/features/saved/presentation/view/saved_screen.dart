import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/features/saved/presentation/view_model/saved_trip_bloc.dart';

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
              title: const Text(
                "Saved Trips",
                style: TextStyle(color: Colors.white),
              ),
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
    if (state is SavedTripLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is SavedTripLoaded) {
      final trips = state.trips;

      if (trips.isEmpty) {
        return Center(
          child: Text(
            "No saved trips yet.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Text(
                trip.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF09A8C8),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "${trip.destination} | ${_formatDate(trip.startDate)} - ${_formatDate(trip.endDate)}",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  BlocProvider.of<SavedTripBloc>(context).add(
                    DeleteSavedTripEvent(trip.id),
                  );
                },
              ),
              onTap: () {
                _showTripDetailsDialog(context, trip);
              },
            ),
          );
        },
      );
    } else if (state is SavedTripError) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return const SizedBox();
  }

  void _showTripDetailsDialog(BuildContext context, trip) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          trip.title,
          style: const TextStyle(
            color: Color(0xFF09A8C8),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow("Destination", trip.destination),
            _infoRow("Start Date", _formatDate(trip.startDate)),
            _infoRow("End Date", _formatDate(trip.endDate)),
            const SizedBox(height: 12),
            const Text(
              "Itinerary",
              style: TextStyle(
                color: Color(0xFF09A8C8),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              trip.itinerary,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close",
              style: TextStyle(
                color: Color(0xFF09A8C8),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              color: Color(0xFF09A8C8),
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
