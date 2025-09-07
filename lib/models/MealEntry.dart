class MealEntry {
  final String mealType;
  final String foodName;
  final DateTime timestamp;
  final int calories;
  final String? summary;
  final double? protein;
  final double? carbs;
  final double? fat;
  final String? imagePath;

  MealEntry({
    required this.mealType,
    required this.foodName,
    required this.timestamp,
    required this.calories,
    this.summary,
    this.protein,
    this.carbs,
    this.fat,
    this.imagePath,
  });
}