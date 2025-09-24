import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.blue.shade700, // Vibrant blue
    secondary: Colors.blue.shade100, // Lighter blue for accents
    tertiary: Colors.grey.shade200, // Subtle grey for containers
    inversePrimary: Colors.blue.shade900, // Darker blue for contrast
    onPrimary: Colors.white, // Text on primary color
    onSurface: Colors.grey.shade900, // Text on background
  ),
);