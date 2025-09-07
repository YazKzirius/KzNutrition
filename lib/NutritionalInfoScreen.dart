import 'package:flutter/material.dart';
import 'package:kznutrition/models/MealEntry.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:kznutrition/utils/AppColours.dart';
import 'package:kznutrition/CustomWigets/ScanButton.dart';

class NutritionalInfoScreen extends StatelessWidget {
  final String foodName;
  final int calories;
  final String? summary;
  final double? protein;
  final double? carbs;
  final double? fat;

  const NutritionalInfoScreen({
    super.key,
    required this.foodName,
    required this.calories,
    this.summary,
    this.protein,
    this.carbs,
    this.fat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: Text(foodName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main nutritional card (calories and macros)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColours.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text("Estimated Calories", style: TextStyle(fontSize: 18, color: AppColours.textSecondary)),
                  const SizedBox(height: 8),
                  Text(calories.toString(), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MacroWidget(title: 'Protein', value: protein),
                      _MacroWidget(title: 'Carbs', value: carbs),
                      _MacroWidget(title: 'Fat', value: fat),
                    ],
                  ),
                ],
              ),
            ),

            // This widget will only build if a summary string exists.
            if (summary != null && summary!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColours.card.withOpacity(0.5), // A slightly more subtle card
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Symbols.lightbulb_outline, color: Colors.yellow.shade700, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          summary!,
                          style: const TextStyle(
                            color: AppColours.textSecondary,
                            fontSize: 15,
                            height: 1.5, // Improves readability for multiple lines
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const Spacer(), // Pushes the button to the bottom

            // Add to Log button
            ScanButton(
              icon: Symbols.add,
              text: 'Add to Today\'s Log',
              onPressed: () {
                final newEntry = MealEntry(
                  mealType: 'Snack',
                  foodName: foodName,
                  timestamp: DateTime.now(),
                  calories: calories,
                  summary: summary,
                  protein: protein,
                  carbs: carbs,
                  fat: fat,
                );
                Navigator.pop(context, newEntry);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Helper widget for a cleaner layout (no changes needed here)
class _MacroWidget extends StatelessWidget {
  final String title;
  final double? value;

  const _MacroWidget({required this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: AppColours.textSecondary, fontSize: 16)),
        const SizedBox(height: 4),
        Text(
          value != null ? '${value!.toStringAsFixed(0)}g' : '-',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}