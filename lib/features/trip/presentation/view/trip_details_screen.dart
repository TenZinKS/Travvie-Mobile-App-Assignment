import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/presentation/view/widgets/trip_dialog.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_bloc.dart';

class TripDetailsScreen extends StatelessWidget {
  final TripEntity trip;

  const TripDetailsScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trip.title),
        backgroundColor: const Color(0xFF09A8C8),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pop(context);
              Future.delayed(Duration.zero, () {
                _showEditDialog(context, trip);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              BlocProvider.of<TripBloc>(context).add(DeleteTripEvent(trip.id));
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5,
                spreadRadius: 1,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.title,
                  style: const TextStyle(
                    color: Color(0xFF09A8C8),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _infoRow("Destination", trip.destination),
                _infoRow("Start Date", _formatDate(trip.startDate)),
                _infoRow("End Date", _formatDate(trip.endDate)),
                _infoRow("Status", trip.isCompleted ? "Completed" : "Planned"),
                const Divider(height: 30),
                const Text(
                  "Itinerary",
                  style: TextStyle(
                    color: Color(0xFF09A8C8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  trip.itinerary,
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        BlocProvider.of<TripBloc>(context).add(
                          UpdateTripEvent(
                            trip.copyWith(isCompleted: !trip.isCompleted),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        trip.isCompleted ? Icons.undo : Icons.check,
                      ),
                      label: Text(
                        trip.isCompleted
                            ? "Mark as Incomplete"
                            : "Mark as Completed",
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF09A8C8),
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        BlocProvider.of<TripBloc>(context).add(
                          SaveTripAsWishlistEvent(trip),
                        );
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.favorite_border),
                      label: const Text("Save as Wishlist"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                      ),
                    ),

                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: add cancel trip logic
                      },
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text("Cancel Trip"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF09A8C8),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _showEditDialog(BuildContext context, TripEntity existingTrip) {
    showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: BlocProvider.of<TripBloc>(context),
          child: AlertDialog(
            title: const Text("Edit Trip"),
            content: SingleChildScrollView(
              child: TripDialog(existingTrip: existingTrip),
            ),
          ),
        );
      },
    );
  }
}
