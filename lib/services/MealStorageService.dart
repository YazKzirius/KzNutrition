import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:kznutrition/models/MealEntry.dart';

class MealStorageService {
  // Finds the correct local path to store the file.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Gets a reference to the actual file.
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/meal_entries.json');
  }

  // Reads the file and decodes the JSON to a list of MealEntry objects.
  Future<List<MealEntry>> loadMeals() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return []; // If the file doesn't exist, return an empty list.
      }
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => MealEntry.fromJson(json)).toList();
    } catch (e) {
      print("Error loading meals: $e");
      return []; // If an error occurs, return an empty list.
    }
  }

  // Encodes a list of MealEntry objects to JSON and writes it to the file.
  Future<File> saveMeals(List<MealEntry> meals) async {
    final file = await _localFile;
    final List<Map<String, dynamic>> jsonList = meals.map((meal) => meal.toJson()).toList();
    return file.writeAsString(json.encode(jsonList));
  }
}