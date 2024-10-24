import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const primary = Colors.blue;
  static const secondary = Colors.orange;

  // Status colors
  static const success = Colors.green;
  static const error = Colors.red;
  static const warning = Colors.yellow;

  // Background colors
  static const background = Colors.white;
  static const surface = Colors.white;

  // Text colors
  static const textPrimary = Colors.black87;
  static const textSecondary = Colors.black54;

  // Order status colors
  static final orderStatusColors = {
    'new_': Colors.blue,
    'inProgress': Colors.orange,
    'completed': Colors.green,
    'cancelled': Colors.red,
  };
}