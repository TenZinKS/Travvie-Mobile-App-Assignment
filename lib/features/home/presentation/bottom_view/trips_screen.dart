import 'package:flutter/material.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trips"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}