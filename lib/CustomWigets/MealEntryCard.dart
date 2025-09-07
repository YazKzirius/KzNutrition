import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kznutrition/models/MealEntry.dart';
import 'package:kznutrition/utils/AppColours.dart';

class MealEntryCard extends StatelessWidget {
  final MealEntry meal;

  const MealEntryCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColours.card,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // This allows the text to wrap and prevents overflow.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.foodName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColours.textPrimary,
                  ),
                  // Optional: to prevent extremely long names from taking too much space
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${meal.mealType} • ${DateFormat.jm().format(meal.timestamp)}',
                  style: const TextStyle(
                      fontSize: 14, color: AppColours.textSecondary),
                ),
                // --- NEW: Display nutritional info if available ---
                if (meal.protein != null || meal.carbs != null || meal.fat != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _buildMacroString(),
                      style: const TextStyle(
                          fontSize: 13, color: AppColours.textSecondary),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16), // A little spacing
          Text(
            '${meal.calories} cal',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColours.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build the P • C • F string neatly
  String _buildMacroString() {
    final parts = [];
    if (meal.protein != null) parts.add('P: ${meal.protein!.toStringAsFixed(0)}g');
    if (meal.carbs != null) parts.add('C: ${meal.carbs!.toStringAsFixed(0)}g');
    if (meal.fat != null) parts.add('F: ${meal.fat!.toStringAsFixed(0)}g');
    return parts.join(' • ');
  }
}