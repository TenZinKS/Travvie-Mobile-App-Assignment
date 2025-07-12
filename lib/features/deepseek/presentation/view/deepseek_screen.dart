import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/features/deepseek/data/model/deepseek_request_model.dart';
import 'package:travvie/features/deepseek/presentation/view_model/deepseek_bloc.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_bloc.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_event.dart';

class DeepSeekScreen extends StatefulWidget {
  const DeepSeekScreen({super.key});

  @override
  State<DeepSeekScreen> createState() => _DeepSeekScreenState();
}

class _DeepSeekScreenState extends State<DeepSeekScreen> {
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final peopleController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  final refineController = TextEditingController();
  List<Map<String, String>> chatMessages = [];
  DeepSeekRequestModel? lastRequest;

  String _tripStatus = "UPCOMING"; // new field

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<DeepSeekBloc>()),
        BlocProvider(create: (_) => sl<TripBloc>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("DeepSeek AI Trip Planner"),
          backgroundColor: const Color(0xFF09A8C8),
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<DeepSeekBloc, DeepSeekState>(
          listener: (context, state) {
            if (state is DeepSeekFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is DeepSeekSuccess) {
              setState(() {
                chatMessages.add({
                  "role": "assistant",
                  "content": state.response.itinerary,
                });
              });
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (lastRequest == null) ...[
                    _buildTextField("From", fromController),
                    const SizedBox(height: 12),
                    _buildTextField("To", toController),
                    const SizedBox(height: 12),
                    _buildTextField("Number of People", peopleController,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    _buildDatePicker("Start Date", startDate, (picked) {
                      setState(() => startDate = picked);
                    }),
                    const SizedBox(height: 12),
                    _buildDatePicker("End Date", endDate, (picked) {
                      setState(() => endDate = picked);
                    }),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF09A8C8),
                        ),
                        onPressed: state is DeepSeekLoading
                            ? null
                            : () => _submitInitial(context),
                        child: state is DeepSeekLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Generate Trip",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ] else ...[
                    _buildChatHistory(chatMessages),
                    const SizedBox(height: 20),
                    _buildTextField("Refine your trip...", refineController),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF09A8C8),
                        ),
                        onPressed: state is DeepSeekLoading
                            ? null
                            : () => _sendRefinement(context),
                        child: state is DeepSeekLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Send",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Save Trip As:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    RadioListTile<String>(
                      title: const Text("Upcoming Trip"),
                      value: "UPCOMING",
                      groupValue: _tripStatus,
                      onChanged: (val) {
                        setState(() => _tripStatus = val ?? "UPCOMING");
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text("Planned Trip"),
                      value: "PLANNED",
                      groupValue: _tripStatus,
                      onChanged: (val) {
                        setState(() => _tripStatus = val ?? "UPCOMING");
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        _saveTrip(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      icon: const Icon(Icons.save),
                      label: const Text("Save Trip"),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime? selectedDate,
    Function(DateTime) onDatePicked,
  ) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDatePicked(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        width: double.infinity,
        child: Text(
          selectedDate != null
              ? DateFormat.yMMMd().format(selectedDate)
              : label,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildChatHistory(List<Map<String, String>> messages) {
    return Column(
      children: messages.map((message) {
        final isUser = message["role"] == "user";
        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF09A8C8) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message["content"] ?? "",
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _submitInitial(BuildContext context) {
    if (fromController.text.isEmpty ||
        toController.text.isEmpty ||
        peopleController.text.isEmpty ||
        startDate == null ||
        endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    final requestModel = DeepSeekRequestModel(
      from: fromController.text.trim(),
      to: toController.text.trim(),
      numberOfPeople: int.tryParse(peopleController.text.trim()) ?? 1,
      startDate: startDate!,
      endDate: endDate!,
      previousMessages: [],
    );

    lastRequest = requestModel;

    setState(() {
      chatMessages.add({
        "role": "user",
        "content":
            "Please generate a trip itinerary:\n- From: ${requestModel.from}\n- To: ${requestModel.to}\n- Number of people: ${requestModel.numberOfPeople}\n- Start date: ${DateFormat.yMMMd().format(requestModel.startDate!)}\n- End date: ${DateFormat.yMMMd().format(requestModel.endDate!)}\n\nProvide a day-wise itinerary.",
      });
    });

    context.read<DeepSeekBloc>().add(
          GenerateTripEvent(requestModel),
        );
  }

  void _sendRefinement(BuildContext context) {
    final text = refineController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      chatMessages.add({"role": "user", "content": text});
      refineController.clear();
    });

    context.read<DeepSeekBloc>().add(
          GenerateTripEvent(
            DeepSeekRequestModel(
              from: lastRequest?.from ?? "",
              to: lastRequest?.to ?? "",
              numberOfPeople: lastRequest?.numberOfPeople ?? 1,
              startDate: lastRequest?.startDate,
              endDate: lastRequest?.endDate,
              refinePrompt: text,
              previousMessages: chatMessages,
            ),
          ),
        );
  }

  void _saveTrip(BuildContext context) {
    final aiReply = chatMessages.lastWhere(
          (msg) => msg["role"] == "assistant",
          orElse: () => {"content": ""},
        )["content"] ??
        "";

    if (lastRequest == null || aiReply.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No trip data to save.")),
      );
      return;
    }

    final trip = TripEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      from: lastRequest!.from,
      to: lastRequest!.to,
      numberOfPeople: lastRequest!.numberOfPeople,
      startDate: lastRequest!.startDate ?? DateTime.now(),
      endDate: lastRequest!.endDate ?? DateTime.now(),
      itinerary: aiReply,
      status: _tripStatus,
    );

    context.read<TripBloc>().add(AddTripEvent(trip));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Trip saved as $_tripStatus!"),
      ),
    );

    setState(() {
      lastRequest = null;
      chatMessages.clear();
      _tripStatus = "UPCOMING";
    });
  }
}
