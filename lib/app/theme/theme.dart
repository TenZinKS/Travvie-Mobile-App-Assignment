import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.blueAccent,
      fontFamily: 'Poppins', // 👈 use custom font

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        bodyMedium: TextStyle(
            fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
      ),

      iconTheme: const IconThemeData(color: Colors.blueAccent),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
}
