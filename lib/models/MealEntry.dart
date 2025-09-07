class MealEntry {
  final String mealType;
  final String foodName;
  final DateTime timestamp;
  final int calories;
  final String? summary;
  // --- NEW: Add macronutrient fields ---
  final double? protein;
  final double? carbs;
  final double? fat;

  MealEntry({
    required this.mealType,
    required this.foodName,
    required this.timestamp,
    required this.calories,
    this.summary,
    // Add to constructor
    this.protein,
    this.carbs,
    this.fat,
  });
}