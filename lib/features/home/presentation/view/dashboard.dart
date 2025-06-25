import 'package:flutter/material.dart';
import 'package:travvie/features/home/presentation/bottom_view/trips_screen.dart';
import 'package:travvie/features/home/presentation/bottom_view/home_screen.dart';
import 'package:travvie/features/home/presentation/bottom_view/ai_chat_screen.dart'; 
import 'package:travvie/features/home/presentation/bottom_view/profile_screen.dart';
import 'package:travvie/features/home/presentation/bottom_view/saved_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TripsScreen(),
    const AiChatScreen(),
    const SavedScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF09A8C8),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.terrain_sharp),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: const Offset(0, -10), // float slightly above
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF09A8C8),
                ),
                child: const Icon(
                  Icons.smart_toy_outlined,
                  size: 34,
                  color: Colors.white,
                ),
              ),
            ),
            label: 'AI',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Saved',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
