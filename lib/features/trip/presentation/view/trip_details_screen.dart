import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/presentation/view/widgets/trip_dialog.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_bloc.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_event.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_state.dart';
import 'package:travvie/features/saved/domain/entity/saved_trip_entity.dart';
import 'package:travvie/features/saved/presentation/view_model/saved_trip_bloc.dart';

import 'package:travvie/app/service_locator/service_locator.dart';

class TripDetailsScreen extends StatelessWidget {
  final TripEntity trip;

  const TripDetailsScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: BlocProvider.of<TripBloc>(context)),
        BlocProvider(create: (_) => sl<SavedTripBloc>()),
      ],
      child: BlocListener<TripBloc, TripState>(
        listener: (context, state) {
          if (state is TripLoaded) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Trip updated successfully!")),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("${trip.from} → ${trip.to}"),
            backgroundColor: const Color(0xFF09A8C8),
            actions: [
              if (_canEdit(trip.status))
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    _showEditDialog(context, trip);
                  },
                ),
              if (trip.status == "PLANNED")
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _confirmDelete(context, trip);
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${trip.from} → ${trip.to}",
                        style: const TextStyle(
                          color: Color(0xFF09A8C8),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _infoRow("Number of People", trip.numberOfPeople.toString()),
                      _infoRow("Start Date", _formatDate(trip.startDate)),
                      _infoRow("End Date", _formatDate(trip.endDate)),
                      _infoRow("Status", _statusLabel(trip.status)),
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
                        trip.itinerary.isNotEmpty
                            ? trip.itinerary
                            : "No itinerary provided.",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      ..._buildActions(context, trip),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, TripEntity trip) {
    if (trip.status == "COMPLETED" || trip.status == "CANCELLED") {
      return [];
    }

    List<Widget> actions = [];

    if (trip.status == "UPCOMING") {
      actions.addAll([
        ElevatedButton.icon(
          onPressed: () {
            BlocProvider.of<TripBloc>(context).add(
              UpdateTripEvent(
                trip.copyWith(status: "COMPLETED"),
              ),
            );
          },
          icon: const Icon(Icons.check),
          label: const Text("Mark as Completed"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF09A8C8),
            minimumSize: const Size.fromHeight(48),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            _confirmCancelTrip(context, trip);
          },
          icon: const Icon(Icons.cancel_outlined),
          label: const Text("Cancel Trip"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ]);
    } else if (trip.status == "PLANNED") {
      actions.addAll([
        ElevatedButton.icon(
          onPressed: () {
            _confirmSaveWishlist(context, trip);
          },
          icon: const Icon(Icons.favorite_border),
          label: const Text("Save as Wishlist"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            minimumSize: const Size.fromHeight(48),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            BlocProvider.of<TripBloc>(context).add(
              UpdateTripEvent(
                trip.copyWith(status: "UPCOMING"),
              ),
            );
          },
          icon: const Icon(Icons.arrow_forward),
          label: const Text("Mark as Upcoming"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF09A8C8),
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ]);
    }

    return actions;
  }

  void _confirmSaveWishlist(BuildContext context, TripEntity trip) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Save as Wishlist"),
        content: const Text(
          "This trip will be moved to your Saved list and removed from Trips. Continue?",
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Save"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
            ),
            onPressed: () {
              Navigator.pop(context);
              _saveAsWishlist(context, trip);
            },
          )
        ],
      ),
    );
  }

  void _saveAsWishlist(BuildContext context, TripEntity trip) {
    final savedTrip = SavedTripEntity(
      id: trip.id,
      from: "${trip.from} → ${trip.to}",
      to: trip.to,
      numberOfPeople: trip.numberOfPeople,
      startDate: trip.startDate!,
      endDate: trip.endDate!,
      itinerary: trip.itinerary,
    );

    BlocProvider.of<SavedTripBloc>(context).add(
      AddSavedTripEvent(savedTrip),
    );

    // Remove from Trips immediately
    BlocProvider.of<TripBloc>(context).add(
      DeleteTripEvent(trip.id),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Trip saved as wishlist!")),
    );

    Navigator.pop(context);
  }

  String _statusLabel(String status) {
    switch (status) {
      case "COMPLETED":
        return "Completed";
      case "PLANNED":
        return "Planned";
      case "UPCOMING":
        return "Upcoming";
      case "CANCELLED":
        return "Cancelled";
      default:
        return status;
    }
  }

  bool _canEdit(String status) {
    return status == "PLANNED" || status == "UPCOMING";
  }

  void _confirmCancelTrip(BuildContext context, TripEntity trip) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel Trip"),
        content: const Text(
          "Are you sure you want to cancel this trip? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            child: const Text("No"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Yes"),
            onPressed: () {
              BlocProvider.of<TripBloc>(context).add(
                UpdateTripEvent(
                  trip.copyWith(status: "CANCELLED"),
                ),
              );
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, TripEntity trip) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Trip"),
        content: const Text(
            "Are you sure you want to delete this trip? This cannot be undone."),
        actions: [
          TextButton(
            child: const Text("No"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Yes"),
            onPressed: () {
              BlocProvider.of<TripBloc>(context).add(
                DeleteTripEvent(trip.id),
              );
              Navigator.pop(context);
            },
          )
        ],
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

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
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
