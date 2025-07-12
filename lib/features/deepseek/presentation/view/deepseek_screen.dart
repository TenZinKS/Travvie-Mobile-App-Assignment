import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/deepseek_bloc.dart';
import '../view_model/deepseek_state.dart';
import '../view_model/deepseek_event.dart';
import 'package:travvie/app/service_locator/service_locator.dart';

class DeepSeekScreen extends StatelessWidget {
  DeepSeekScreen({super.key});

  final TextEditingController _promptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DeepSeekBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("AI Trip Generator"),
          backgroundColor: Color(0xFF09A8C8),
        ),
        body: BlocBuilder<DeepSeekBloc, DeepSeekState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _promptController,
                    decoration: InputDecoration(
                      labelText: "Enter your travel prompt",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DeepSeekBloc>().add(
                            GenerateTripEvent(_promptController.text.trim()),
                          );
                    },
                    child: Text("Generate Trip"),
                  ),
                  SizedBox(height: 24),
                  if (state is DeepSeekLoading) ...[
                    CircularProgressIndicator(),
                  ] else if (state is DeepSeekLoaded) ...[
                    Text(
                      state.response.content,
                      style: TextStyle(fontSize: 16),
                    ),
                  ] else if (state is DeepSeekError) ...[
                    Text(
                      state.message,
                      style: TextStyle(color: Colors.red),
                    )
                  ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
