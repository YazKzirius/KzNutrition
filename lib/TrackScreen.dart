import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kznutrition/models/MealEntry.dart';
import 'package:kznutrition/CameraScanner.dart';
import 'package:kznutrition/NutritionalInfoScreen.dart';
import 'package:kznutrition/services/GeminiService.dart';
import 'package:kznutrition/utils/AppColours.dart';
import 'package:kznutrition/CustomWigets/MealGroup.dart';
import 'package:kznutrition/CustomWigets/ScanButton.dart';

class TrackScreen extends StatefulWidget {
  final List<MealEntry> meals;
  final Function(MealEntry) onAddMeal;
  final Function(MealEntry) onDeleteMeal;

  const TrackScreen({
    super.key,
    required this.meals,
    required this.onAddMeal,
    required this.onDeleteMeal,
  });

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final GeminiService _geminiService = GeminiService();
  final ImagePicker _picker = ImagePicker();
  String? _lastAnalysisSummary;

  List<MealEntry> get _todayMeals {
    final now = DateTime.now();
    return widget.meals.where((meal) =>
    meal.timestamp.year == now.year &&
        meal.timestamp.month == now.month &&
        meal.timestamp.day == now.day
    ).toList();
  }

  List<MealEntry> get _yesterdayMeals {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return widget.meals.where((meal) =>
    meal.timestamp.year == yesterday.year &&
        meal.timestamp.month == yesterday.month &&
        meal.timestamp.day == yesterday.day
    ).toList();
  }

  void _showSummaryDialog(MealEntry meal) {
    // We only show the dialog if it's a Gemini summary (has an image path)
    if (meal.imagePath == null || meal.summary == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColours.card,
        title: Text(meal.foodName, style: const TextStyle(color: AppColours.textPrimary)),
        content: Text(
          meal.summary!,
          style: const TextStyle(color: AppColours.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppColours.textPrimary,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
  // This function now calls the parent's onAddMeal callback
  void _addMealEntry(MealEntry entry) {
    // This first line calls the parent to save the new meal to storage.
    widget.onAddMeal(entry);
    if (entry.imagePath != null) {
      setState(() {
        _lastAnalysisSummary = entry.summary;
      });
    }
  }
  Future<void> _analyzeImageAndAddEntry(String imagePath) async {
    if (!mounted) return;

    showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      final imageFile = File(imagePath);
      final analysis = await _geminiService.analyzeImage(imageFile);

      Navigator.pop(context);

      if (analysis != null && mounted) {
        double? toDouble(dynamic value) {
          if (value is num) return value.toDouble();
          return null;
        }

        final newEntry = await Navigator.push<MealEntry>(
          context,
          MaterialPageRoute(
            builder: (context) => NutritionalInfoScreen(
              foodName: analysis['foodName'] ?? 'Analyzed Food',
              calories: analysis['calories'] ?? 0,
              summary: analysis['summary'],
              protein: toDouble(analysis['protein']),
              carbs: toDouble(analysis['carbs']),
              fat: toDouble(analysis['fat']),
              imagePath: imagePath,
            ),
          ),
        );
        if (newEntry != null) {
          _addMealEntry(newEntry);
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not analyze image')),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      print("An error occurred during image analysis: $e");
    }
  }

  Future<void> _showImageSourceActionSheet() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColours.background,
      builder: (BuildContextcontext) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Symbols.photo_camera, color: AppColours.textSecondary),
                title: const Text('Take Photo', style: TextStyle(color: AppColours.textPrimary)),
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet
                  final String? imagePath = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CameraScannerScreen()),
                  );
                  if (imagePath != null) {
                    _analyzeImageAndAddEntry(imagePath);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Symbols.collections, color: AppColours.textSecondary),
                title: const Text('Choose from Gallery', style: TextStyle(color: AppColours.textPrimary)),
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet
                  final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery);
                  if (image != null) {
                    _analyzeImageAndAddEntry(image.path);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: AppColours.textSecondary,
        ),
        title: const Text('Track', style: TextStyle(fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColours.textPrimary)),
        actions: [
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScanButton(icon: Symbols.photo_camera,
                  text: 'Scan camera',
                  onPressed: _showImageSourceActionSheet),
              const SizedBox(height: 32),

              MealGroup(
                title: 'Today',
                meals: _todayMeals,
                onDeleteMeal: widget.onDeleteMeal,
                onMealTap: _showSummaryDialog,
              ),
              const SizedBox(height: 16),

              AnimatedOpacity(
                opacity: _lastAnalysisSummary != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: _lastAnalysisSummary != null
                    ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColours.card,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                          Symbols.lightbulb, color: Colors.yellow, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _lastAnalysisSummary!,
                          style: const TextStyle(
                              color: AppColours.textSecondary, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 32),

              MealGroup(
                title: 'Yesterday',
                meals: _yesterdayMeals,
                onDeleteMeal: widget.onDeleteMeal,
                onMealTap: _showSummaryDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }
}