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
  Map<String, dynamic> toJson() => {
    'mealType': mealType,
    'foodName': foodName,
    'timestamp': timestamp.toIso8601String(),
    'calories': calories,
    'summary': summary,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'imagePath': imagePath,
  };

  factory MealEntry.fromJson(Map<String, dynamic> json) => MealEntry(
    mealType: json['mealType'],
    foodName: json['foodName'],
    timestamp: DateTime.parse(json['timestamp']),
    calories: json['calories'],
    summary: json['summary'],
    protein: json['protein'],
    carbs: json['carbs'],
    fat: json['fat'],
    imagePath: json['imagePath'],
  );
}