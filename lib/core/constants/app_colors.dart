import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand
  static const primary = Color(0xFF1E88E5);
  static const primaryDark = Color(0xFF1565C0);
  static const secondary = Color(0xFF00ACC1);
  static const accent = Color(0xFF26A69A);

  // Semantic
  static const success = Color(0xFF43A047);
  static const warning = Color(0xFFFFA726);
  static const error = Color(0xFFE53935);
  static const info = Color(0xFF039BE5);

  // Calculator type colours
  static const dcaColor = Color(0xFF5C6BC0);
  static const carLoanColor = Color(0xFF26A69A);
  static const homeLoanColor = Color(0xFF42A5F5);
  static const savingGoalColor = Color(0xFFEF6C00);
  static const compoundColor = Color(0xFF7E57C2);

  // Light surface
  static const surfaceLight = Color(0xFFF5F7FA);
  static const cardLight = Color(0xFFFFFFFF);

  // Dark surface
  static const surfaceDark = Color(0xFF121212);
  static const cardDark = Color(0xFF1E1E1E);
  static const cardDark2 = Color(0xFF252525);

  // Chart palette
  static const chartColors = [
    Color(0xFF1E88E5),
    Color(0xFF43A047),
    Color(0xFFFFA726),
    Color(0xFFE53935),
    Color(0xFF7E57C2),
    Color(0xFF00ACC1),
  ];
}
