import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/features/home/presentation/view/home_screen.dart';
import 'package:travvie/features/deepseek/presentation/view/deepseek_screen.dart';
import 'package:travvie/features/profile/presentation/view/profile_screen.dart';
import 'package:travvie/features/saved/presentation/view/saved_screen.dart';
import 'package:travvie/features/saved/presentation/view_model/saved_trip_bloc.dart';
import 'package:travvie/features/trip/presentation/view/trip_screen.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_bloc.dart';
import 'package:travvie/features/deepseek/presentation/view_model/deepseek_bloc.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_event.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      const HomeScreen(),
      BlocProvider(
        create: (_) => sl<TripBloc>()..add(LoadTripsEvent()),
        child: const TripScreen(),
      ),
      BlocProvider(
        create: (_) => sl<DeepSeekBloc>(),
        child: const DeepSeekScreen(),
      ),
      BlocProvider(
        create: (_) => sl<SavedTripBloc>()..add(LoadSavedTripsEvent()),
        child: const SavedScreen(),
      ),
      const ProfileScreen(),
    ];
  }

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
              offset: const Offset(0, -10),
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
