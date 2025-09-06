import 'package:flutter/material.dart';
// Corrected import path and class name below
import '../utils/AppColours.dart';

class MealEntryCard extends StatelessWidget {
  final String mealType;
  final String time;
  final String calories;

  const MealEntryCard({
    super.key,
    required this.mealType,
    required this.time,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColours.card, // Changed
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mealType,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColours.textPrimary)), // Changed
              const SizedBox(height: 4),
              Text(time,
                  style: const TextStyle(
                      fontSize: 14, color: AppColours.textSecondary)), // Changed
            ],
          ),
          Text('$calories cal',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColours.textPrimary)), // Changed
        ],
      ),
    );
  }
}