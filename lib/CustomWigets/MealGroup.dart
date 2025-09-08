import 'package:flutter/material.dart';
import 'package:kznutrition/models/MealEntry.dart';
import 'package:kznutrition/CustomWigets/MealEntryCard.dart';
import 'package:kznutrition/utils/AppColours.dart';

class MealGroup extends StatelessWidget {
  final String title;
  final List<MealEntry> meals;
  final Function(MealEntry) onDeleteMeal;
  final Function(MealEntry) onMealTap;

  const MealGroup({
    super.key,
    required this.title,
    required this.meals,
    required this.onDeleteMeal,
    required this.onMealTap,
  });

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalCalories = meals.fold<int>(0, (sum, item) => sum + item.calories);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColours.textSecondary)),
            Text('$totalCalories cal',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColours.textSecondary)),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return MealEntryCard(
              meal: meal,
              onDelete: () => onDeleteMeal(meal),
              onTap: () => onMealTap(meal),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
        ),
      ],
    );
  }
}