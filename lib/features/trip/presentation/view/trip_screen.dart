import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/features/saved/presentation/view_model/saved_trip_bloc.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_bloc.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_event.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_state.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/presentation/view/trip_details_screen.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  String searchQuery = '';
  String selectedStatus = 'ALL';

  @override
  void initState() {
    super.initState();
    context.read<TripBloc>().add(LoadTripsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Trips"),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: const Color(0xFF09A8C8),
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: BlocBuilder<TripBloc, TripState>(
              builder: (context, state) {
                if (state is TripLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TripLoaded) {
                  final filteredTrips = _filterTrips(state.trips);
                  return _buildTripList(context, filteredTrips);
                } else if (state is TripError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text("No trips found."));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() => searchQuery = value.trim().toLowerCase());
            },
            decoration: InputDecoration(
              hintText: 'Search by destination or origin',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Filter by status: "),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: selectedStatus,
                items: const [
                  DropdownMenuItem(value: 'ALL', child: Text('All')),
                  DropdownMenuItem(value: 'PLANNED', child: Text('Planned')),
                  DropdownMenuItem(value: 'UPCOMING', child: Text('Upcoming')),
                  DropdownMenuItem(value: 'COMPLETED', child: Text('Completed')),
                  DropdownMenuItem(value: 'CANCELLED', child: Text('Cancelled')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedStatus = value);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<TripEntity> _filterTrips(List<TripEntity> trips) {
    return trips.where((trip) {
      final matchesSearch = trip.from.toLowerCase().contains(searchQuery) ||
          trip.to.toLowerCase().contains(searchQuery);
      final matchesStatus = selectedStatus == 'ALL' ||
          trip.status.toUpperCase() == selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  Widget _buildTripList(BuildContext context, List<TripEntity> trips) {
    if (trips.isEmpty) {
      return const Center(
        child: Text(
          "No trips match your filter.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trips.length,
      itemBuilder: (_, index) {
        final trip = trips[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: context.read<TripBloc>()),
                      BlocProvider(create: (_) => sl<SavedTripBloc>()),
                    ],
                    child: TripDetailsScreen(trip: trip),
                  ),
                ),
              );
              context.read<TripBloc>().add(LoadTripsEvent());
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text("${trip.from} → ${trip.to}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text("Dates: ${_formatDate(trip.startDate)} → ${_formatDate(trip.endDate)}"),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text("Status: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      _statusLabel(trip.status),
                      style: TextStyle(color: _statusColor(trip.status), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case "COMPLETED":
        return "Completed";
      case "PLANNED":
        return "Planned";
      case "UPCOMING":
        return "Upcoming";
      case "CANCELLED":
        return "Cancelled";
      default:
        return "Unknown";
    }
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case "COMPLETED":
        return Colors.green;
      case "PLANNED":
        return Colors.orange;
      case "UPCOMING":
        return Colors.blue;
      case "CANCELLED":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
