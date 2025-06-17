import 'package:flutter/material.dart';
import 'package:travvie/features/home/presentation/bottom_view/explore_screen.dart';
import 'package:travvie/features/home/presentation/bottom_view/home_screen.dart';
import 'package:travvie/features/home/presentation/bottom_view/plan_screen.dart';
import 'package:travvie/features/home/presentation/bottom_view/profile_screen.dart';
import 'package:travvie/features/home/presentation/bottom_view/saved_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key}); 

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  List<Widget> lstBottomScreen = [
    const HomeScreen(),
    const ExploreScreen(),
    const PlanScreen(),
    const SavedScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: lstBottomScreen[_selectedIndex],
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
