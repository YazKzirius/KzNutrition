import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class GoalStorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user_goals.json');
  }

  /// Reads the file and decodes the JSON to a Set of goal strings.
  Future<Set<String>> loadGoals() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return {}; // If the file doesn't exist, return an empty set.
      }
      final contents = await file.readAsString();
      // The JSON is a list of dynamic, which we cast to strings.
      final List<dynamic> jsonList = json.decode(contents);
      // Convert the List<String> into a Set<String> to return.
      return jsonList.map((item) => item.toString()).toSet();
    } catch (e) {
      print("Error loading goals: $e");
      return {}; // On error, return an empty set to prevent a crash.
    }
  }

  /// Encodes a Set of goal strings to JSON and writes it to the file.
  Future<File> saveGoals(Set<String> goals) async {
    final file = await _localFile;
    // Convert the Set to a List before encoding, as JSON supports arrays (lists).
    final List<String> goalList = goals.toList();
    return file.writeAsString(json.encode(goalList));
  }
}