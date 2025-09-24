import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900, // Dark background
    primary: Colors.blue.shade400, // Lighter vibrant blue for primary actions
    secondary: Colors.blue.shade900, // Darker blue for accents
    tertiary: Colors.grey.shade800, // Dark grey for containers
    inversePrimary: Colors.blue.shade100, // Light blue for contrast
    onPrimary: Colors.white, // Text on primary color
    onSurface: Colors.white, // Text on background
  ),
);