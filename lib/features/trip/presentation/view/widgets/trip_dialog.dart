import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_bloc.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_event.dart';

class TripDialog extends StatefulWidget {
  final TripEntity? existingTrip;

  const TripDialog({super.key, this.existingTrip});

  @override
  State<TripDialog> createState() => _TripDialogState();
}

class _TripDialogState extends State<TripDialog> {
  late TextEditingController fromController;
  late TextEditingController toController;
  late TextEditingController itineraryController;
  late TextEditingController numberOfPeopleController;
  DateTime? startDate;
  DateTime? endDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fromController = TextEditingController(text: widget.existingTrip?.from ?? '');
    toController = TextEditingController(text: widget.existingTrip?.to ?? '');
    itineraryController = TextEditingController(text: widget.existingTrip?.itinerary ?? '');
    numberOfPeopleController = TextEditingController(
      text: widget.existingTrip?.numberOfPeople.toString() ?? '1',
    );
    startDate = widget.existingTrip?.startDate;
    endDate = widget.existingTrip?.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: fromController,
              decoration: const InputDecoration(labelText: "From"),
              validator: (value) => value == null || value.trim().isEmpty ? "Please enter a starting location" : null,
            ),
            TextFormField(
              controller: toController,
              decoration: const InputDecoration(labelText: "To (Destination)"),
              validator: (value) => value == null || value.trim().isEmpty ? "Please enter a destination" : null,
            ),
            TextFormField(
              controller: itineraryController,
              decoration: const InputDecoration(labelText: "Itinerary"),
              maxLines: 3,
              validator: (value) => value == null || value.trim().isEmpty ? "Please enter an itinerary" : null,
            ),
            TextFormField(
              controller: numberOfPeopleController,
              decoration: const InputDecoration(labelText: "Number of People"),
              keyboardType: TextInputType.number,
              validator: (value) {
                final num = int.tryParse(value ?? '');
                if (num == null || num < 1) return "Enter valid number (1 or more)";
                return null;
              },
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
                  setState(() => startDate = picked);
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
                  setState(() => endDate = picked);
                }
              },
              child: Text(endDate == null
                  ? "Pick End Date"
                  : "End: ${_formatDate(endDate!)}"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final trip = TripEntity(
                    id: widget.existingTrip?.id ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    from: fromController.text.trim(),
                    to: toController.text.trim(),
                    numberOfPeople:
                        int.tryParse(numberOfPeopleController.text.trim()) ?? 1,
                    startDate: startDate ?? DateTime.now(),
                    endDate: endDate ?? DateTime.now(),
                    itinerary: itineraryController.text.trim(),
                    status: widget.existingTrip?.status ?? "PLANNED",
                  );

                  if (widget.existingTrip == null) {
                    BlocProvider.of<TripBloc>(context).add(AddTripEvent(trip));
                  } else {
                    BlocProvider.of<TripBloc>(context).add(UpdateTripEvent(trip));
                  }

                  Navigator.of(context).pop(); // close the dialog
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF09A8C8),
              ),
              child: Text(widget.existingTrip == null ? "Save" : "Update"),
            )
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
