import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/features/dashboard/presentation/view_model/dashboard_bloc.dart';
import 'package:travvie/features/dashboard/presentation/view_model/dashboard_event.dart';
import 'package:travvie/features/dashboard/presentation/view_model/dashboard_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardBloc>()..add(LoadDashboardEvent()),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is DashboardLoaded) {
            final dashboard = state.dashboard;

            // For random tips/facts
            final tips = [
              "Always carry a power bank when exploring new cities.",
              "Learn a few local phrases to help navigate abroad.",
              "Keep digital and physical copies of your documents.",
              "Try local street food — it’s often the best part!",
            ];

            final funFacts = [
              "Japan has vending machines for almost everything — even ramen!",
              "Iceland is powered by 100% renewable energy.",
              "Machu Picchu was unknown to the outside world until 1911.",
              "The Eiffel Tower can grow up to 6 inches in summer heat.",
            ];

            final random = Random();
            final travelTip = tips[random.nextInt(tips.length)];
            final funFact = funFacts[random.nextInt(funFacts.length)];

            return Scaffold(
              appBar: AppBar(
                title: const Text("Travvie Dashboard"),
                centerTitle: true,
                backgroundColor: const Color(0xFF09A8C8),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome back 👋",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Here’s a snapshot of your travel journey!",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Dashboard Stats Cards
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        _buildStatCard(Icons.check_circle, "Trips Completed",
                            "${dashboard.completedTrips}", Colors.blueAccent),
                        _buildStatCard(Icons.cancel, "Trips Cancelled",
                            "${dashboard.cancelledTrips}", Colors.redAccent),
                        _buildStatCard(Icons.access_time, "Upcoming Trips",
                            "${dashboard.upcomingTrips}", Colors.orangeAccent),
                        _buildStatCard(Icons.favorite, "Wishlists",
                            "${dashboard.wishlistCount}", Colors.pinkAccent),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Completion Rate Card
                    _buildInfoCard(
                      title: "🎯 Completion Rate",
                      message:
                          "${dashboard.completionRate.toStringAsFixed(1)}% · Rank: ${dashboard.travellerRank}",
                      backgroundColor: Colors.lightBlue[50],
                      icon: Icons.emoji_events,
                      iconColor: Colors.blue,
                    ),

                    const SizedBox(height: 24),

                    // Travel Tip of the Day
                    _buildInfoCard(
                      title: "🌍 Travel Tip of the Day",
                      message: travelTip,
                      backgroundColor: Colors.teal[50],
                      icon: Icons.lightbulb_outline,
                      iconColor: Colors.teal,
                    ),

                    const SizedBox(height: 20),

                    // Fun Fact
                    _buildInfoCard(
                      title: "🗺️ Did You Know?",
                      message: funFact,
                      backgroundColor: Colors.indigo[50],
                      icon: Icons.explore,
                      iconColor: Colors.indigo,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }

          return const Scaffold(
            body: Center(
              child: Text("Error loading dashboard."),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
      IconData icon, String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String message,
    required Color? backgroundColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: iconColor)),
                const SizedBox(height: 4),
                Text(message,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
