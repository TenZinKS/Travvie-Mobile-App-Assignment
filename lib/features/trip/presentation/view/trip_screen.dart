import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/presentation/view/trip_details_screen.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_bloc.dart';

class TripScreen extends StatelessWidget {
  const TripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripBloc, TripState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Your Trips"),
            backgroundColor: const Color(0xFF09A8C8),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF09A8C8),
            onPressed: () {
              _showTripDialog(context);
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: _buildBody(state, context),
        );
      },
    );
  }

  Widget _buildBody(TripState state, BuildContext context) {
    if (state is TripLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is TripLoaded) {
      if (state.trips.isEmpty) {
        return const Center(child: Text("No trips yet."));
      }
      return ListView.builder(
        itemCount: state.trips.length,
        itemBuilder: (context, index) {
          final trip = state.trips[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            color: Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(
                trip.title,
                style: const TextStyle(
                  color: Color(0xFF09A8C8),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Destination: ${trip.destination}"),
                  Text("Dates: ${_formatDate(trip.startDate)} → ${_formatDate(trip.endDate)}"),
                  Text("Status: ${trip.isCompleted ? "Completed" : "Planned"}"),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF09A8C8)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<TripBloc>(context),
                      child: TripDetailsScreen(trip: trip),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    } else if (state is TripError) {
      return Center(child: Text(state.message));
    }
    return const SizedBox();
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }


  void _showTripDialog(BuildContext context, {TripEntity? existingTrip}) {
    final titleController = TextEditingController(text: existingTrip?.title);
    final destinationController = TextEditingController(text: existingTrip?.destination);
    final itineraryController = TextEditingController(text: existingTrip?.itinerary);

    DateTime? startDate = existingTrip?.startDate;
    DateTime? endDate = existingTrip?.endDate;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(existingTrip == null ? "Add Trip" : "Edit Trip"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: destinationController,
                  decoration: const InputDecoration(labelText: "Destination"),
                ),
                TextField(
                  controller: itineraryController,
                  decoration: const InputDecoration(labelText: "Itinerary"),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      startDate = picked;
                    }
                  },
                  child: Text(startDate == null
                      ? "Pick Start Date"
                      : "Start Date: ${startDate!.toLocal().toIso8601String().substring(0, 10)}"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      endDate = picked;
                    }
                  },
                  child: Text(endDate == null
                      ? "Pick End Date"
                      : "End Date: ${endDate!.toLocal().toIso8601String().substring(0, 10)}"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final trip = TripEntity(
                  id: existingTrip?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  destination: destinationController.text,
                  startDate: startDate ?? DateTime.now(),
                  endDate: endDate ?? DateTime.now(),
                  itinerary: itineraryController.text,
                  isCompleted: existingTrip?.isCompleted ?? false,
                );

                if (existingTrip == null) {
                  BlocProvider.of<TripBloc>(context).add(AddTripEvent(trip));
                } else {
                  BlocProvider.of<TripBloc>(context).add(UpdateTripEvent(trip));
                }

                Navigator.of(ctx).pop();
              },
              child: Text(existingTrip == null ? "Add" : "Update"),
            )
          ],
        );
      },
    );
  }
}
