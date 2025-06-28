import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_bloc.dart';

class TripDialog extends StatefulWidget {
  final TripEntity? existingTrip;

  const TripDialog({super.key, this.existingTrip});

  @override
  State<TripDialog> createState() => _TripDialogState();
}

class _TripDialogState extends State<TripDialog> {
  late TextEditingController titleController;
  late TextEditingController destinationController;
  late TextEditingController itineraryController;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    titleController =
        TextEditingController(text: widget.existingTrip?.title ?? '');
    destinationController =
        TextEditingController(text: widget.existingTrip?.destination ?? '');
    itineraryController =
        TextEditingController(text: widget.existingTrip?.itinerary ?? '');
    startDate = widget.existingTrip?.startDate;
    endDate = widget.existingTrip?.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              firstDate: DateTime(2022),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              setState(() {
                startDate = picked;
              });
            }
          },
          child: Text(startDate == null
              ? "Pick Start Date"
              : "Start: ${_formatDate(startDate!)}"),
        ),
        ElevatedButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: endDate ?? DateTime.now(),
              firstDate: DateTime(2022),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              setState(() {
                endDate = picked;
              });
            }
          },
          child: Text(endDate == null
              ? "Pick End Date"
              : "End: ${_formatDate(endDate!)}"),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final trip = TripEntity(
              id: widget.existingTrip?.id ??
                  DateTime.now().millisecondsSinceEpoch.toString(),
              title: titleController.text,
              destination: destinationController.text,
              startDate: startDate ?? DateTime.now(),
              endDate: endDate ?? DateTime.now(),
              itinerary: itineraryController.text,
              isCompleted: widget.existingTrip?.isCompleted ?? false,
            );

            if (widget.existingTrip == null) {
              BlocProvider.of<TripBloc>(context).add(AddTripEvent(trip));
            } else {
              BlocProvider.of<TripBloc>(context).add(UpdateTripEvent(trip));
            }

            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF09A8C8),
          ),
          child: Text(widget.existingTrip == null ? "Save" : "Update"),
        )
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
