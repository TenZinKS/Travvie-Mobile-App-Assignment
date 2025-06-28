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
          if (state is SavedTripLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SavedTripLoaded) {
            final trips = state.trips; // ✅ Corrected name

            if (trips.isEmpty) {
              return const Center(child: Text("No saved trips yet."));
            }

            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return ListTile(
                  title: Text(trip.title),
                  subtitle: Text(
                    "${trip.destination} | ${_formatDate(trip.startDate)} - ${_formatDate(trip.endDate)}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      BlocProvider.of<SavedTripBloc>(context).add(
                        DeleteSavedTripEvent(trip.id),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is SavedTripError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
